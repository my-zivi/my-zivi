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
        $this->authJson('POST', '/api/mission', 'zivi', $this->missionTemplate())->assertResponseStatus(401);
    }

    public function testValidUserPost()
    {
        $template = $this->missionTemplate();
        $user = factory(User::class)->create();
        $template['user'] = 'me';

        $this->authJson('POST', '/api/mission', $user, $template)->assertResponseOk();
        $this->assertEquals('inserted', $this->response->getContent());
    }

    public function testInvalidPut()
    {
        $missionId = factory(Mission::class)->create()->id;
        $this->authJson('PUT', '/api/mission/' . $missionId, 'zivi', $this->missionTemplate())->assertResponseStatus(401);
    }

    public function testShouldUpdateReportSheets()
    {
        $template = $this->missionTemplate();
        $this->authJson('POST', '/api/mission', 'admin', $template)->assertResponseOk();

        $mission = Mission::latest()->first();
        $mission->update(['draft' => '2018-11-05']);
        $countOfMissions = ReportSheet::where('mission', "=", $mission->id)->count();
        $template['end'] = '2021-12-31';

        $this->authJson('PUT', '/api/mission/' . $mission->id, 'admin', $template)->assertResponseOk();
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
