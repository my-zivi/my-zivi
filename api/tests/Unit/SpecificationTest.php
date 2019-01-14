<?php

namespace Tests\Unit;

use App\Specification;

class SpecificationTest extends \TestCase
{
    public function testGetDailyFirstDayCosts()
    {
        $specification = factory(Specification::class)->make([
            'accommodation' => 15000,
            'firstday_breakfast_expenses' => 700,
            'firstday_lunch_expenses' => 1200,
            'firstday_dinner_expenses' => 900,
            'pocket' => 500,
        ]);

        $this->assertEquals(18300, $specification->daily_first_day_costs);
    }

    public function testGetDailyLastDayCosts()
    {
        $specification = factory(Specification::class)->make([
            'accommodation' => 16000,
            'lastday_breakfast_expenses' => 700,
            'lastday_lunch_expenses' => 1200,
            'lastday_dinner_expenses' => 900,
            'pocket' => 500,
        ]);

        $this->assertEquals(19300, $specification->daily_last_day_costs);
    }

    public function testGetDailySpareTimeDayCosts()
    {
        $specification = factory(Specification::class)->make([
            'accommodation' => 20000,
            'sparetime_breakfast_expenses' => 700,
            'sparetime_lunch_expenses' => 1200,
            'sparetime_dinner_expenses' => 900,
            'pocket' => 500,
        ]);

        $this->assertEquals(23300, $specification->daily_spare_time_costs);
    }

    public function testGetDailyWorkTimeDayCosts()
    {
        $specification = factory(Specification::class)->make([
            'accommodation' => 0,
            'pocket' => 500,
            'working_breakfast_expenses' => 700,
            'working_lunch_expenses' => 1200,
            'working_dinner_expenses' => 900,
        ]);

        $this->assertEquals(3300, $specification->daily_work_time_costs);
    }
}
