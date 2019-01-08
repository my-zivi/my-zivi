<?php

namespace Tests\Integrations;

use App\ReportSheet;
use App\User;
use Laravel\Lumen\Testing\DatabaseTransactions;

class ReportSheetControllerTest extends \TestCase
{
    use DatabaseTransactions;

    public function testDeleteAsUser()
    {
        // can't delete because object does not exist
        $reportSheetId = factory(ReportSheet::class)->create()->id;
        $this->asUser()->json('DELETE', 'api/report_sheets/' . $reportSheetId)->assertResponseStatus(401);
    }

    public function testInvalidDelete()
    {
        // can't delete because object does not exist
        $this->asAdmin()->json('DELETE', 'api/report_sheets/1789764')->assertResponseStatus(404);
    }

    public function testValidDelete()
    {
        $reportSheetId = factory(ReportSheet::class)->create()->id;
        $this->asAdmin()->json('DELETE', 'api/report_sheets/' . $reportSheetId)->assertResponseOk();
        $this->assertEquals('Entity deleted', $this->response->getContent());
    }

    public function testGetAsUser()
    {
        $reportSheetId = factory(ReportSheet::class)->create()->id;
        $this->asUser()->json('GET', 'api/report_sheets/' . $reportSheetId)->assertResponseStatus(401);
    }

    public function testGetAsAdmin()
    {
        $reportSheetId = factory(ReportSheet::class)->create()->id;
        $this->asAdmin()->json('GET', 'api/report_sheets/' . $reportSheetId)->assertResponseOk();
    }

    public function testGetIndexAsUser()
    {
        // user should only see the report sheets that belong to him
        // also, the state should be bigger than 0
        $user = factory(User::class)->create();

        factory(ReportSheet::class)->create();
        factory(ReportSheet::class)->create([
            'state' => 0,
            'user' => $user->id
        ]);
        $validReportSheet = factory(ReportSheet::class)->create([
            'state' => 3,
            'user' => $user->id
        ]);

        $this->asUser($user)->json('GET', 'api/report_sheets')->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertCount(1, $response);
        $this->assertEquals($validReportSheet->id, $response[0]['id']);
        $this->assertArrayNotHasKey('clothes_comment', $response[0]);
        $this->assertArrayNotHasKey('work_comment', $response[0]);
    }

    public function testPutAsUser()
    {
        $reportSheet = factory(ReportSheet::class)->create()->toArray();
        $this->asUser()->json('PUT', 'api/report_sheets/' . $reportSheet['id'], $reportSheet)->assertResponseStatus(401);
    }

    public function testPutAsAdminWithInvalidId()
    {
        $this->asAdmin()->json('PUT', 'api/report_sheets/238402830922', factory(ReportSheet::class)->make()->toArray())->assertResponseStatus(404);
    }

    public function testPutAsAdminInvalidData()
    {
        $reportSheetId = factory(ReportSheet::class)->create()->id;
        $this->asAdmin()->json('PUT', 'api/report_sheets/' . $reportSheetId, [])->assertResponseStatus(422);
    }

    public function testPutAsAdminWithValidData()
    {
        $originalReportSheet = factory(ReportSheet::class)->create();
        $reportSheetTemplate = factory(ReportSheet::class)->make()->toArray();

        $this->asAdmin()->json('PUT', 'api/report_sheets/' . $originalReportSheet->id, $reportSheetTemplate)->assertResponseOk();

        // TODO uncomment this line as soon as the get request for report_sheets is fixed
        //$this->assertResponseMatchesTemplate($reportSheetTemplate, true);
    }
}
