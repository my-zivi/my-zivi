<?php

namespace Tests\Integrations;

use App\Mission;
use App\ReportSheet;
use App\Specification;
use App\User;
use Carbon\Carbon;
use Laravel\Lumen\Testing\DatabaseTransactions;

class MissionControllerTest extends \Tests\TestCase
{
    use DatabaseTransactions;

    public function testInvalidUserPost()
    {
        $this->asUser()->json('POST', '/api/missions', $this->missionTemplate())->assertResponseStatus(401);
    }

    public function testValidUserPost()
    {
        $template = $this->missionTemplate();
        $user = factory(User::class)->create();
        $template['user_id'] = $user->id;

        $this->asUser($user)->json('POST', '/api/missions', $template)->assertResponseOk();
        $this->assertResponseMatchesTemplate($template);
    }

    public function testInvalidPut()
    {
        $missionId = factory(Mission::class)->create()->id;
        $this->asUser()->json('PUT', '/api/missions/' . $missionId, $this->missionTemplate())->assertResponseStatus(401);
    }

    public function testShouldUpdateReportSheets()
    {
        $template = $this->missionTemplate();
        $this->asAdmin()->json('POST', '/api/missions', $template)->assertResponseOk();

        $mission = Mission::latest()->first();
        $mission->update(['draft' => '2018-11-05']);
        $countOfMissions = ReportSheet::where('mission_id', "=", $mission->id)->count();
        $template['end'] = '2021-12-31';

        $this->asAdmin()->json('PUT', '/api/missions/' . $mission->id, $template);
        $this->assertResponseMatchesTemplate($template);
        $this->assertEquals($countOfMissions + 12, ReportSheet::where('mission_id', "=", $mission->id)->count());
    }

    public function testShouldMarkMissionDraftAsReceived()
    {
        $mission = factory(Mission::class)->create([
            'draft' => null,
            'end'   => (new Carbon())->modify('last day of this month')->format('Y-m-d'),
            'start' => (new Carbon())->subMonth(3)->modify('first day of this month')->format('Y-m-d'),
        ]);

        $countOfReportSheetsBeforeCall = count(ReportSheet::all());

        $this->asAdmin()->json('PUT', 'api/missions/' . $mission->id . '/received_draft')->assertResponseOk();

        $mission->refresh();
        $this->assertEquals((new \DateTime())->format('Y-m-d'), $mission->draft);
        $this->assertCount($countOfReportSheetsBeforeCall + 4, ReportSheet::all());
    }

    public function testInvalidMarkMissionDraftAsReceived()
    {
        $mission = factory(Mission::class)->create([
            'draft' => null,
            'end'   => (new Carbon())->modify('last day of this month')->format('Y-m-d'),
            'start' => (new Carbon())->subMonth(3)->modify('first day of this month')->format('Y-m-d'),
        ]);

        $this->asUser()->json('PUT', 'api/missions/' . $mission->id . '/received_draft')->assertResponseStatus(401);
    }

    public function testDeleteAsUser()
    {
        $mission = factory(Mission::class)->create();
        $this->asUser()->json('DELETE', 'api/missions/' . $mission->id)->assertResponseStatus(401);
    }

    public function testDeleteAsAdminWithInvalidId()
    {
        $this->asAdmin()->json('DELETE', 'api/missions/124324252')->assertResponseStatus(404);
    }

    public function testDeleteAsAdminWithValidId()
    {
        $reportSheet = factory(ReportSheet::class)->create();

        $countBeforeMissionDeletion = count(Mission::all());
        $countBeforeReportSheetDeletion = count(ReportSheet::all());

        $this->asAdmin()->json('DELETE', 'api/missions/' . $reportSheet->mission_id)->assertResponseOk();

        $this->assertCount($countBeforeMissionDeletion - 1, Mission::all());
        $this->assertCount($countBeforeReportSheetDeletion - 1, ReportSheet::all());
    }

    public function testIndexByYearAsUser()
    {
        $this->asUser()->json('GET', 'api/missions/2020')->assertResponseStatus(401);
    }

    public function testIndexByYearAsAdmin()
    {
        // should return all missions
        factory(Mission::class, 10)->create([
                                       'end'   => function () {
                                        return Carbon::parse('2020-01-01')->addWeeks(rand(26, 51));
                                       },
                                       'start' => function () {
                                        return Carbon::parse('2020-01-01')->addWeeks(rand(1, 25));
                                       },
                                   ]);
        $this->asAdmin()->json('GET', 'api/missions/2020')->assertResponseOk();
        $this->assertCount(Mission::whereDate('end', '>=', '2020-01-01')
            ->whereDate('start', '<=', '2020-12-31')->count(), $this->responseToArray());
    }

    private function missionTemplate()
    {
        return [
            'days'             => 365,
            'draft'            => true,
            'end'              => '2020-12-31',
            'first_time'       => false,
            'long_mission'     => false,
            'mission_type'     => rand(0, 2),
            'probation_period' => false,
            'specification_id' => factory(Specification::class)->create()->id,
            'start'            => '2020-01-01',
            'user_id'          => factory(User::class)->create()->id,
        ];
    }
}
