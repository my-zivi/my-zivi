<?php

namespace Tests\Integrations;

use App\ReportSheet;
use App\User;
use Laravel\Lumen\Testing\DatabaseTransactions;

class ReportSheetControllerTest extends \TestCase
{
    use DatabaseTransactions;

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
}
