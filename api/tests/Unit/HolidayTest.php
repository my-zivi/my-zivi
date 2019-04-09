<?php

namespace Tests\Unit;

use App\Holiday;
use App\HolidayType;

class HolidayTest extends \Tests\TestCase
{
    public function testHolidayTypeAssignment()
    {
        $holidayType = factory(HolidayType::class)->make();
        $holiday = factory(Holiday::class)->make();
        $holiday->holidayType()->associate($holidayType);
        $this->assertEquals($holidayType, $holiday->holidayType);
    }
}
