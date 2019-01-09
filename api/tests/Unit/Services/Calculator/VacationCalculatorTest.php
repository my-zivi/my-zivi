<?php

namespace Tests\Unit\Services\Calculator;

use App\Holiday;
use App\HolidayType;
use App\Services\Calculator\VacationCalculator;
use Carbon\Carbon;
use Laravel\Lumen\Testing\DatabaseTransactions;

class VacationCalculatorTest extends \TestCase
{
    use DatabaseTransactions;

    public function testCalculateZiviHolidayNotEligibleForHolidays()
    {
        $this->assertEquals(0, VacationCalculator::calculateZiviHolidays(10));
    }

    public function testCalculateZiviHolidayMinDaysForHolidays()
    {
        $this->assertEquals(8, VacationCalculator::calculateZiviHolidays(180));
    }

    public function testAdditionalZiviHolidayMonthsForHolidays()
    {
        $this->assertEquals(10, VacationCalculator::calculateZiviHolidays(210));
        $this->assertEquals(10, VacationCalculator::calculateZiviHolidays(211));
        $this->assertEquals(10, VacationCalculator::calculateZiviHolidays(224));
        $this->assertEquals(10, VacationCalculator::calculateZiviHolidays(225));
        $this->assertEquals(12, VacationCalculator::calculateZiviHolidays(240));
    }

    public function testCalculatePublicHolidaysShouldNotHitTimespan()
    {
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-04-13',
            'date_to' => '2020-04-17',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(0, VacationCalculator::calculatePublicHolidays(new Carbon('2020-04-06'), new Carbon('2020-04-10')));
    }

    public function testCalculatePublicHolidaysShouldPartiallyHitTimespan()
    {
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-04-13',
            'date_to' => '2020-04-17',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(3, VacationCalculator::calculatePublicHolidays(new Carbon('2020-04-06'), new Carbon('2020-04-15')));
    }

    public function testCalculatePublicHolidaysShouldNotCalculateWeekends()
    {
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-04-06',
            'date_to' => '2020-04-17',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(6, VacationCalculator::calculatePublicHolidays(new Carbon('2020-04-09'), new Carbon('2020-04-16')));
    }

    public function testCalculatePublicHolidaysOverlappingHolidays()
    {
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-04-06',
            'date_to' => '2020-04-17',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        factory(Holiday::class)->create([
            'date_from' => '2020-04-12',
            'date_to' => '2020-04-27',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(6, VacationCalculator::calculatePublicHolidays(new Carbon('2020-04-09'), new Carbon('2020-04-16')));
    }

    public function testCalculatePublicHolidaysOneHoliday()
    {
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-04-09',
            'date_to' => '2020-04-09',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(1, VacationCalculator::calculatePublicHolidays(new Carbon('2020-04-09'), new Carbon('2020-04-16')));
    }

    public function testCalculatePublicHolidaysTwoHolidays()
    {
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-04-09',
            'date_to' => '2020-04-10',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(2, VacationCalculator::calculatePublicHolidays(new Carbon('2020-04-09'), new Carbon('2020-04-16')));
    }

    public function testCalculateCompanyVacationsShouldReturnFullTimespan()
    {
        $companyVacationTypeId = $this->createOrUpdateCompanyVacationType();
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-03-30',
            'date_to' => '2020-04-03',
            'holiday_type_id' => $companyVacationTypeId
        ]);

        factory(Holiday::class)->create([
            'date_from' => '2020-04-30',
            'date_to' => '2020-05-03',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(5, VacationCalculator::calculateCompanyVacations(new Carbon('2020-03-30'), new Carbon('2020-04-03')));
    }

    public function testCalculateCompanyVacationsShouldReturnPartOfTimespan()
    {
        $companyVacationTypeId = $this->createOrUpdateCompanyVacationType();
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-03-30',
            'date_to' => '2020-04-03',
            'holiday_type_id' => $companyVacationTypeId
        ]);

        factory(Holiday::class)->create([
            'date_from' => '2020-04-01',
            'date_to' => '2020-05-03',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(2, VacationCalculator::calculateCompanyVacations(new Carbon('2020-03-30'), new Carbon('2020-04-03')));
    }

    public function testCalculateCompanyVacationsShouldIgnoreWeekends()
    {
        $companyVacationTypeId = $this->createOrUpdateCompanyVacationType();
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-03-30',
            'date_to' => '2020-04-11',
            'holiday_type_id' => $companyVacationTypeId
        ]);

        factory(Holiday::class)->create([
            'date_from' => '2020-04-06',
            'date_to' => '2020-04-11',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(5, VacationCalculator::calculateCompanyVacations(new Carbon('2020-03-30'), new Carbon('2020-04-11')));
    }

    public function testCalculateCompanyVacationsLongerVacationThanStartAndEndOfCalculation()
    {
        $companyVacationTypeId = $this->createOrUpdateCompanyVacationType();
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-02-28',
            'date_to' => '2020-05-11',
            'holiday_type_id' => $companyVacationTypeId
        ]);

        factory(Holiday::class)->create([
            'date_from' => '2020-04-06',
            'date_to' => '2020-04-11',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(5, VacationCalculator::calculateCompanyVacations(new Carbon('2020-03-30'), new Carbon('2020-04-11')));
    }

    public function testCalculateCompanyVacationsOverlappingVacationCalculation()
    {
        $companyVacationTypeId = $this->createOrUpdateCompanyVacationType();
        $generalHolidayTypeId = factory(HolidayType::class)->create()->id;

        factory(Holiday::class)->create([
            'date_from' => '2020-02-28',
            'date_to' => '2020-05-11',
            'holiday_type_id' => $companyVacationTypeId
        ]);

        factory(Holiday::class)->create([
            'date_from' => '2020-04-06',
            'date_to' => '2020-04-11',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        factory(Holiday::class)->create([
            'date_from' => '2020-04-09',
            'date_to' => '2020-04-15',
            'holiday_type_id' => $generalHolidayTypeId
        ]);

        $this->assertEquals(5, VacationCalculator::calculateCompanyVacations(new Carbon('2020-03-30'), new Carbon('2020-04-11')));
    }

    private function createOrUpdateCompanyVacationType() : int
    {
        $companyVacationType = HolidayType::where('name', '=', 'Betriebsferien')->first();

        if (is_null($companyVacationType)) {
            $companyVacationTypeId = factory(HolidayType::class, 'company_vacation')->create()->id;
        } else {
            $companyVacationTypeId = $companyVacationType->id;
        }

        return $companyVacationTypeId;
    }
}
