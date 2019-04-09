<?php

namespace tests\integrations;

use App\Holiday;
use Laravel\Lumen\Testing\DatabaseTransactions;
use TestCase;

class PDFControllerTest extends \Tests\TestCase
{
    use DatabaseTransactions;

    public function testGetPhoneList()
    {
        // PDF should not render as zivi
        $this->asUser()->json('GET', '/api/documents/phone_list')->assertResponseStatus(401);

        // PDF should render als admin
        factory(\App\Mission::class, 10)->create([
                                            'start' => '2019-01-02',
                                            'end'   => '2019-03-31',
                                        ]);

        $userWithoutMobileButPrivateId = factory(\App\User::class)->create([
            'phone_mobile'  => "",
            'phone_private' => '077 888 99 11',
        ])->id;

        $userWithoutMobileButBusinessId = factory(\App\User::class)->create([
            'phone_mobile'   => "",
            'phone_private'  => "",
            'phone_business' => '077 888 99 11',
        ])->id;

        factory(\App\Mission::class, 2)->create([
                                           'user_id' => $userWithoutMobileButPrivateId,
                                           'start'   => '2019-01-01',
                                           'end'     => '2019-04-01',
                                       ]);

        factory(\App\Mission::class, 2)->create([
                                           'user_id' => $userWithoutMobileButBusinessId,
                                           'start'   => '2019-01-01',
                                           'end'     => '2019-04-01',
                                       ]);

        $this->asAdmin()->json('GET', '/api/documents/phone_list?start=2019-01-01&end=2019-04-01')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetZiviReportSheet()
    {
        // report sheet of a zivi should be available for himself
        $reportSheet = factory(\App\ReportSheet::class)->create([
            'driving_charges_comment' => 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
            'ill_comment'             => 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',// to test comment wrapping
        ]);
        $zivi = $reportSheet->user;
        $this->asUser($zivi)->json('GET', '/api/report_sheets/' . $reportSheet->id . '/download')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');

        // report sheet of another zivi should not available for him
        $otherReportSheet = factory(\App\ReportSheet::class)->create();
        $this->asUser($zivi)->json('GET', '/api/report_sheets/' . $otherReportSheet->id . '/download')->assertResponseStatus(401);

        // but for the administrator
        $this->asAdmin()->json('GET', '/api/report_sheets/' . $otherReportSheet->id . '/download')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikNotForZivi()
    {
        // PDF should not render as zivi
        $this->asUser()->json('GET', '/api/documents/expenses_overview')->assertResponseStatus(401);
    }

    public function testGetSpesenstatistikFirstTimeType()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/documents/expenses_overview', [
            'time_type' => 1,
        ])->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikSecondType()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/documents/expenses_overview?time_type=2')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikThirdType()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/documents/expenses_overview?time_type=3')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikGeneralType()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/documents/expenses_overview')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikShowDetail()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/documents/expenses_overview?showDetails=1')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetAufgebot()
    {
        factory(Holiday::class)->create([
                                   'date_from'       => '2020-05-06',
                                   'date_to'         => '2020-06-06',
                                   'holiday_type_id' => 1,
                               ]);

        $mission = factory(\App\Mission::class)->create([
            'end'   => '2020-12-31',
            'start' => '2020-01-01',
        ]);

        // report sheet of a zivi should be available for himself
        $zivi = $mission->user;
        $this->asUser($zivi)->json('GET', '/api/missions/' . $mission->id . '/draft')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');

        // report sheet of another zivi should not available for him
        $otherMission = factory(\App\Mission::class)->create();
        $this->asUser($zivi)->json('GET', '/api/missions/' . $otherMission->id . '/draft')
            ->assertResponseStatus(401);

        // but for the administrator
        $this->asAdmin()->json('GET', '/api/missions/' . $otherMission->id . '/draft')
            ->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }
}
