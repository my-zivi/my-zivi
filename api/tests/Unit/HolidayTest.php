<?php

namespace Tests\Unit;

use App\Holiday;
use App\HolidayType;

class HolidayTest extends \TestCase
{
    public function testHolidayTypeAssignment()
    {
        $holidayType = factory(HolidayType::class)->make();
        $holiday = factory(Holiday::class)->make();
        $holiday->holiday_type()->associate($holidayType);
        $this->assertEquals($holidayType, $holiday->holiday_type);
    }
}
