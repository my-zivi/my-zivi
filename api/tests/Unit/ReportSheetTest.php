<?php

namespace Tests\Unit;

use App\Mission;
use App\ReportSheet;
use App\Specification;
use Laravel\Lumen\Testing\DatabaseTransactions;

class ReportSheetTest extends \TestCase
{
    use DatabaseTransactions;

    public function testGetChargedDaysAttribute()
    {
        // should return a sum of all "covered" days in the report sheet
        $reportSheet = factory(ReportSheet::class)->make([
            'additional_workfree' => 5,
            'company_holiday_holiday' => 3,
            'company_holiday_vacation' => 5,
            'holiday' => 2,
            'ill' => 5,
            'vacation' => 5,
            'work' => 20,
            'workfree' => 10
        ]);

        $this->assertEquals(55, $reportSheet->charged_days);
    }

    public function testGetClothesDaysAttribute()
    {
        // should return the work, workfree, ill and holiday days
        $reportSheet = factory(ReportSheet::class)->make([
            'ill' => 10,
            'holiday' => 0,
            'work' => 15,
            'workfree' => 5,
        ]);

        $this->assertEquals(30, $reportSheet->clothes_days);
    }

    public function testGetDurationAttribute()
    {
        // should return the days between start and end
        $reportSheet = factory(ReportSheet::class)->make([
            'end' => '2018-12-31',
            'start' => '2018-12-01'
        ]);

        $this->assertEquals(31, $reportSheet->duration);
    }

    public function testGetFirstDayAttribute()
    {
        $mission = factory(Mission::class)->create([
            'start' => '2019-01-01'
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'ignore_first_last_day' => false,
            'mission_id' => $mission->id,
            'start' => '2019-01-01'
        ]);

        $this->assertEquals(1, $reportSheet->refresh()->first_day);

        $reportSheet->ignore_first_last_day = true;
        $this->assertEquals(0, $reportSheet->first_day);
    }

    public function testGetFirstDayCostsAttribute()
    {
        $specificationId = factory(Specification::class)->create([
            'accommodation' => 15000,
            'firstday_breakfast_expenses' => 700,
            'firstday_lunch_expenses' => 1200,
            'firstday_dinner_expenses' => 900,
            'pocket' => 500,
        ])->id;

        $missionId = factory(Mission::class)->create([
            'specification_id' => $specificationId,
            'start' => '2019-01-01'
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'ignore_first_last_day' => false,
            'mission_id' => $missionId,
            'start' => '2019-01-01'
        ]);

        $this->assertEquals(18300, $reportSheet->refresh()->first_day_costs);

        $reportSheet->ignore_first_last_day = true;
        $this->assertEquals(0, $reportSheet->first_day);
    }

    public function testGetHolidayCostsAttribute()
    {
        $specificationId = factory(Specification::class)->create([
            'accommodation' => 20000,
            'sparetime_breakfast_expenses' => 700,
            'sparetime_lunch_expenses' => 1200,
            'sparetime_dinner_expenses' => 900,
            'pocket' => 500,
        ])->id;

        $missionId = factory(Mission::class)->create([
            'specification_id' => $specificationId,
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'company_holiday_holiday' => 10,
            'holiday' => 10,
            'mission_id' => $missionId,
        ]);

        $this->assertEquals(20 * 23300, $reportSheet->refresh()->holidays_costs);
    }

    public function testGetIllDaysCostsAttribute()
    {
        $specificationId = factory(Specification::class)->create([
            'accommodation' => 20000,
            'sparetime_breakfast_expenses' => 700,
            'sparetime_lunch_expenses' => 1200,
            'sparetime_dinner_expenses' => 900,
            'pocket' => 500,
        ])->id;

        $missionId = factory(Mission::class)->create([
            'specification_id' => $specificationId,
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'ill' => 10,
            'mission_id' => $missionId,
        ]);

        $this->assertEquals(10 * 23300, $reportSheet->refresh()->ill_days_costs);
    }

    public function testGetNormalWorkDaysAttribute()
    {
        $missionId = factory(Mission::class)->create([
            'end' => '2012-12-21',
            'start' => '2012-12-01'
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'end' => '2012-12-21',
            'ignore_first_last_day' => false,
            'mission_id' => $missionId,
            'start' => '2012-12-01',
            'work' => 21
        ]);

        $this->assertEquals(19, $reportSheet->normal_work_days);

        $reportSheet->ignore_first_last_day = true;
        $this->assertEquals(21, $reportSheet->normal_work_days);
    }

    public function testGetLastDayAttribute()
    {
        $mission = factory(Mission::class)->create([
            'end' => '2019-01-01'
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'end' => '2019-01-01',
            'ignore_first_last_day' => false,
            'mission_id' => $mission->id
        ]);

        $this->assertEquals(1, $reportSheet->refresh()->last_day);

        $reportSheet->ignore_first_last_day = true;
        $this->assertEquals(0, $reportSheet->last_day);
    }

    public function testGetLastDayCostsAttribute()
    {
        $specificationId = factory(Specification::class)->create([
            'accommodation' => 15000,
            'lastday_breakfast_expenses' => 700,
            'lastday_lunch_expenses' => 1200,
            'lastday_dinner_expenses' => 900,
            'pocket' => 500,
        ])->id;

        $missionId = factory(Mission::class)->create([
            'end' => '2019-01-01',
            'specification_id' => $specificationId,
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'end' => '2019-01-01',
            'ignore_first_last_day' => false,
            'mission_id' => $missionId,
        ]);

        $this->assertEquals(18300, $reportSheet->refresh()->last_day_costs);

        $reportSheet->ignore_first_last_day = true;
        $this->assertEquals(0, $reportSheet->last_day_costs);
    }

    public function testGetTotalCostsAttribute()
    {
        $specificationId = factory(Specification::class)->create([
            'accommodation' => 20000,
            'sparetime_breakfast_expenses' => 700,
            'sparetime_lunch_expenses' => 1200,
            'sparetime_dinner_expenses' => 900,
            'pocket' => 500,
            'working_breakfast_expenses' => 700,
            'working_lunch_expenses' => 1200,
            'working_dinner_expenses' => 900,
        ])->id;

        $missionId = factory(Mission::class)->create([
            'specification_id' => $specificationId,
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'additional_workfree' => 5,
            'company_holiday_holiday' => 10,
            'clothes' => 24000,
            'driving_charges' => 12000,
            'extraordinarily' => -6000,
            'holiday' => 10,
            'ill' => 10,
            'mission_id' => $missionId,
            'ignore_first_last_day' => true,
            'work' => 12,
            'workfree' => 15
        ]);

        $this->assertEquals(10 * 23300 + 20 * 23300 + 12 * 23300 + 20 * 23300 + 12000 + 24000 - 6000, $reportSheet->refresh()->total_costs);
    }

    public function testGetWorkDaysCostsAttribute()
    {
        $specificationId = factory(Specification::class)->create([
            'accommodation' => 0,
            'pocket' => 500,
            'working_breakfast_expenses' => 700,
            'working_lunch_expenses' => 1200,
            'working_dinner_expenses' => 900,
        ])->id;

        $missionId = factory(Mission::class)->create([
            'specification_id' => $specificationId,
            'start' => '1998-05-06'
        ]);

        $reportSheet = factory(ReportSheet::class)->create([
            'ignore_first_last_day' => true,
            'mission_id' => $missionId,
            'start' => '1998-05-06',
            'work' => 12
        ]);

        $this->assertEquals(12 * 3300, $reportSheet->refresh()->work_days_costs);

        $reportSheet->ignore_first_last_day = false;
        $this->assertEquals(11 * 3300, $reportSheet->work_days_costs);
    }

    public function testGetWorkFreeDaysCostsAttribute()
    {
        $specificationId = factory(Specification::class)->create([
            'accommodation' => 20000,
            'sparetime_breakfast_expenses' => 700,
            'sparetime_lunch_expenses' => 1200,
            'sparetime_dinner_expenses' => 900,
            'pocket' => 500,
        ])->id;

        $missionId = factory(Mission::class)->create([
            'specification_id' => $specificationId,
        ])->id;

        $reportSheet = factory(ReportSheet::class)->create([
            'additional_workfree' => 5,
            'mission_id' => $missionId,
            'workfree' => 15
        ]);

        $this->assertEquals(20 * 23300, $reportSheet->refresh()->work_free_days_costs);
    }
}
