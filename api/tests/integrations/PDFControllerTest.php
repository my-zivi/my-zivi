<?php

namespace tests\integrations;

use App\Holiday;
use Laravel\Lumen\Testing\DatabaseTransactions;
use TestCase;

class PDFControllerTest extends TestCase
{
    use DatabaseTransactions;

    public function testGetPhoneList()
    {
        // PDF should not render as zivi
        $this->asUser()->json('GET', '/api/pdf/phoneList')->assertResponseStatus(401);

        // PDF should render als admin
        factory(\App\Mission::class, 10)->create([
            'start' => '2019-01-02',
            'end' => '2019-03-31'
        ]);

        $userWithoutMobileButPrivateId = factory(\App\User::class)->create([
            'phone_mobile' => "",
            'phone_private' => '077 888 99 11'
        ])->id;

        $userWithoutMobileButBusinessId = factory(\App\User::class)->create([
            'phone_mobile' => "",
            'phone_private' => "",
            'phone_business' => '077 888 99 11'
        ])->id;

        factory(\App\Mission::class, 2)->create([
            'user' => $userWithoutMobileButPrivateId,
            'start' => '2019-01-01',
            'end' => '2019-04-01'
        ]);

        factory(\App\Mission::class, 2)->create([
            'user' => $userWithoutMobileButBusinessId,
            'start' => '2019-01-01',
            'end' => '2019-04-01'
        ]);

        $this->asAdmin()->json('GET', '/api/pdf/phoneList?start=2019-01-01&end=2019-04-01')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetZiviReportSheet()
    {
        // report sheet of a zivi should be available for himself
        $reportSheet = factory(\App\ReportSheet::class)->create([
            'driving_charges_comment' => 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
            'ill_comment' => 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut'// to test comment wrapping
        ]);
        $zivi = \App\User::find($reportSheet->user);
        $this->asUser($zivi)->json('GET', '/api/pdf/zivireportsheet', [
            'reportSheetId' => $reportSheet->id
        ])->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');

        // report sheet of another zivi should not available for him
        $otherReportSheet = factory(\App\ReportSheet::class)->create();
        $this->asUser($zivi)->json('GET', '/api/pdf/zivireportsheet', [
            'reportSheetId' => $otherReportSheet->id
        ])->assertResponseStatus(401);

        // but for the administrator
        $this->asAdmin()->json('GET', '/api/pdf/zivireportsheet', [
            'reportSheetId' => $otherReportSheet->id
        ])->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikNotForZivi()
    {
        // PDF should not render as zivi
        $this->asUser()->json('GET', '/api/pdf/statistik')->assertResponseStatus(401);
    }

    public function testGetSpesenstatistikFirstTimeType()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/pdf/statistik?time_type=1')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikSecondType()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/pdf/statistik?time_type=2')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikThirdType()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/pdf/statistik?time_type=3')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikGeneralType()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/pdf/statistik')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetSpesenstatistikShowDetail()
    {
        // PDF should render als admin
        factory(\App\ReportSheet::class, 30)->create();
        $this->asAdmin()->json('GET', '/api/pdf/statistik?showDetails=1')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }

    public function testGetAufgebot()
    {
        factory(Holiday::class)->create([
            'date_from' => '2020-05-06',
            'date_to' => '2020-06-06',
            'holiday_type' => 1
        ]);
        $mission = factory(\App\Mission::class)->create([
            'end' => '2020-12-31',
            'start' => '2020-01-01'
        ]);

        // report sheet of a zivi should be available for himself
        $zivi = \App\User::find($mission->user);
        $this->asUser($zivi)->json('GET', '/api/mission/' . $mission->id . '/draft')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');

        // report sheet of another zivi should not available for him
        $otherMission = factory(\App\Mission::class)->create();
        $this->asUser($zivi)->json('GET', '/api/mission/' . $otherMission->id . '/draft')
            ->assertResponseStatus(401);

        // but for the administrator
        $this->asAdmin()->json('GET', '/api/mission/' . $otherMission->id . '/draft')
            ->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/pdf');
    }
}
