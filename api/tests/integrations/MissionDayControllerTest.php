<?php

namespace Tests\Integration;

class MissionDayControllerTest extends \TestCase
{
    public function testInvalidEligibleDays()
    {
        $this->asUser()->json('GET', 'api/mission_days/eligible_days')->assertResponseStatus(422);
    }

    public function testValidEligibleDays()
    {
        $this->asUser()->json('GET', 'api/mission_days/eligible_days', [
            'start' => '2019-01-01',
            'end'   => '2019-01-31',
        ])->assertResponseOk();

        $this->assertEquals(31, $this->response->getContent());
    }

    public function testInvalidEndDate()
    {
        $this->asUser()->json('GET', 'api/mission_days/possible_end_date')->assertResponseStatus(422);
    }

    public function testValidEndDate()
    {
        $this->asUser()->json('GET', 'api/mission_days/possible_end_date', [
            'start' => '2019-01-01',
            'days'  => '31',
        ])->assertResponseOk();

        $this->assertEquals('2019-01-31', $this->response->getContent());
    }
}
