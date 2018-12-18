<?php

namespace Tests\Integrations;

use App\Mission;
use App\ReportSheet;
use App\Specification;
use App\User;
use Laravel\Lumen\Testing\DatabaseTransactions;

class MissionControllerTest extends \TestCase
{
    use DatabaseTransactions;

    public function testInvalidUserPost()
    {
        $this->asUser()->json('POST', '/api/mission', $this->missionTemplate())->assertResponseStatus(401);
    }

    public function testValidUserPost()
    {
        $template = $this->missionTemplate();
        $user = factory(User::class)->create();
        $template['user'] = 'me';

        $this->asUser($user)->json('POST', '/api/mission', $template)->assertResponseOk();
        $this->assertEquals('inserted', $this->response->getContent());
    }

    public function testInvalidPut()
    {
        $missionId = factory(Mission::class)->create()->id;
        $this->asUser()->json('PUT', '/api/mission/' . $missionId, $this->missionTemplate())->assertResponseStatus(401);
    }

    public function testShouldUpdateReportSheets()
    {
        $template = $this->missionTemplate();
        $this->asAdmin()->json('POST', '/api/mission', $template)->assertResponseOk();

        $mission = Mission::latest()->first();
        $mission->update(['draft' => '2018-11-05']);
        $countOfMissions = ReportSheet::where('mission', "=", $mission->id)->count();
        $template['end'] = '2021-12-31';

        $this->asAdmin()->json('PUT', '/api/mission/' . $mission->id, $template)->assertResponseOk();
        $this->assertEquals('updated', $this->response->getContent());
        $this->assertEquals($countOfMissions + 12, ReportSheet::where('mission', "=", $mission->id)->count());
    }

    private function missionTemplate()
    {
        return [
            'draft' => true,
            'end' => '2020-12-31',
            'first_time' => false,
            'long_mission' => false,
            'mission_type' => false,
            'probation_period' => false,
            'specification' => factory(Specification::class)->create()->id,
            'start' => '2020-01-01',
            'user' => factory(User::class)->create()->id
        ];
    }
}
