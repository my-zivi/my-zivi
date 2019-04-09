<?php

use App\Holiday;
use App\HolidayType;
use App\Services\Calculator\MissionDaysCalculator;
use Carbon\Carbon;

class MissionDaysCalculatorTest extends TestCase
{
    use \Laravel\Lumen\Testing\DatabaseTransactions;

    /**
     * @dataProvider sampleDataForEndDate
     *
     * @param int $days
     * @param string $start
     * @param string $end
     */
    public function testGetEndOfMissionDateGeneric(int $days, string $start, string $end)
    {
        factory(\App\Holiday::class)->create([
                                        'date_from'       => '2018-05-01',
                                        'date_to'         => '2018-05-01',
                                        'holiday_type_id' => factory(HolidayType::class)->create()->id,
                                    ]);

        $start = \Carbon\Carbon::parse($start);
        $this->assertSame($end, MissionDaysCalculator::calculatePossibleEndDate($start, $days)->format('Y-m-d'));
    }

    /**
     * @dataProvider sampleDataForEligibleDays
     *
     * @param int $days
     * @param string $start
     * @param string $end
     */
    public function testGetMissionsDaysGeneric(int $days, string $start, string $end)
    {
        // create first of mai as holiday
        factory(\App\Holiday::class)->create([
                                        'date_from'       => '2018-05-01',
                                        'date_to'         => '2018-05-01',
                                        'holiday_type_id' => factory(HolidayType::class)->create()->id,
                                    ]);

        $start = \Carbon\Carbon::parse($start);
        $end = \Carbon\Carbon::parse($end);
        $this->assertSame($days, MissionDaysCalculator::calculateEligibleDays($start, $end));
    }

    public function testSubtractionOfCompanyVacationIfZiviNotEnoughHolidays()
    {
        $companyVacationType = HolidayType::where('name', '=', 'Betriebsferien')->first();

        if (is_null($companyVacationType)) {
            $companyVacationTypeId = factory(HolidayType::class, 'company_vacation')->create()->id;
        } else {
            $companyVacationTypeId = $companyVacationType->id;
        }

        factory(Holiday::class)->create([
                                   'date_from'       => '2018-04-01',
                                   'date_to'         => '2018-04-30',
                                   'holiday_type_id' => $companyVacationTypeId,
                               ]);

        $this->assertEquals(167, MissionDaysCalculator::calculateEligibleDays(new Carbon('2018-01-01'), new Carbon('2018-06-29')));
    }

    public function testAddAdditionOfDaysIfPotentialEndDateIsInCompanyVacation()
    {
        $companyVacationType = HolidayType::where('name', '=', 'Betriebsferien')->first();

        if (is_null($companyVacationType)) {
            $companyVacationTypeId = factory(HolidayType::class, 'company_vacation')->create()->id;
        } else {
            $companyVacationTypeId = $companyVacationType->id;
        }

        factory(Holiday::class)->create([
                                   'date_from'       => '2018-04-12',
                                   'date_to'         => '2018-04-12',
                                   'holiday_type_id' => $companyVacationTypeId,
                               ]);

        $this->assertEquals('2018-04-16', MissionDaysCalculator::calculatePossibleEndDate(new Carbon('2018-03-12'), 32)->format('Y-m-d'));
    }

    public function sampleDataForEligibleDays(): array
    {
        return [
            [
                1,
                '2018-04-09',
                '2018-04-09',
            ],
            [
                2,
                '2018-04-09',
                '2018-04-10',
            ],
            [
                3,
                '2018-04-09',
                '2018-04-11',
            ],
            [
                4,
                '2018-04-09',
                '2018-04-12',
            ],
            [
                5,
                '2018-04-09',
                '2018-04-13',
            ],
            [
                7,
                '2018-04-09',
                '2018-04-16',
            ],
            [
                7,
                '2018-04-09',
                '2018-04-16',
            ],
            [
                8,
                '2018-04-09',
                '2018-04-17',
            ],
            [
                9,
                '2018-04-09',
                '2018-04-18',
            ],
            [
                11,
                '2018-04-09',
                '2018-04-19',
            ],
            [
                11,
                '2018-04-09',
                '2018-04-19',
            ],
            [
                12,
                '2018-04-09',
                '2018-04-20',
            ],
            [
                14,
                '2018-04-09',
                '2018-04-23',
            ],
            [
                14,
                '2018-04-09',
                '2018-04-23',
            ],
            [
                15,
                '2018-04-09',
                '2018-04-24',
            ],
            [
                16,
                '2018-04-09',
                '2018-04-25',
            ],
            [
                18,
                '2018-04-09',
                '2018-04-26',
            ],
            [
                18,
                '2018-04-09',
                '2018-04-26',
            ],
            [
                19,
                '2018-04-09',
                '2018-04-27',
            ],
            [
                21,
                '2018-04-09',
                '2018-04-30',
            ],
            [
                21,
                '2018-04-09',
                '2018-04-30',
            ],
            [
                22,
                '2018-04-09',
                '2018-05-02',
            ], // mit 1. Mai
            [
                24,
                '2018-04-09',
                '2018-05-03',
            ], // mit 1. Mai
            [
                26,
                '2018-04-09',
                '2018-05-04',
            ], // mit 1. Mai
            [
                26,
                '2018-04-09',
                '2018-05-04',
            ], // mit 1. Mai
            [
                26,
                '2018-04-09',
                '2018-05-04',
            ],
        ];
    }

    public function sampleDataForEndDate(): array
    {
        return [
            [
                1,
                '2018-04-09',
                '2018-04-09',
            ],
            [
                2,
                '2018-04-09',
                '2018-04-10',
            ],
            [
                3,
                '2018-04-09',
                '2018-04-11',
            ],
            [
                4,
                '2018-04-09',
                '2018-04-12',
            ],
            [
                5,
                '2018-04-09',
                '2018-04-13',
            ],
            [
                6,
                '2018-04-09',
                '2018-04-16',
            ],
            [
                7,
                '2018-04-09',
                '2018-04-16',
            ],
            [
                8,
                '2018-04-09',
                '2018-04-17',
            ],
            [
                9,
                '2018-04-09',
                '2018-04-18',
            ],
            [
                10,
                '2018-04-09',
                '2018-04-19',
            ],
            [
                11,
                '2018-04-09',
                '2018-04-19',
            ],
            [
                12,
                '2018-04-09',
                '2018-04-20',
            ],
            [
                13,
                '2018-04-09',
                '2018-04-23',
            ],
            [
                14,
                '2018-04-09',
                '2018-04-23',
            ],
            [
                15,
                '2018-04-09',
                '2018-04-24',
            ],
            [
                16,
                '2018-04-09',
                '2018-04-25',
            ],
            [
                17,
                '2018-04-09',
                '2018-04-26',
            ],
            [
                18,
                '2018-04-09',
                '2018-04-26',
            ],
            [
                19,
                '2018-04-09',
                '2018-04-27',
            ],
            [
                20,
                '2018-04-09',
                '2018-04-30',
            ],
            [
                21,
                '2018-04-09',
                '2018-04-30',
            ],
            [
                22,
                '2018-04-09',
                '2018-05-02',
            ], // mit 1. Mai
            [
                23,
                '2018-04-09',
                '2018-05-03',
            ], // mit 1. Mai
            [
                24,
                '2018-04-09',
                '2018-05-04',
            ], // mit 1. Mai
            [
                25,
                '2018-04-09',
                '2018-05-04',
            ], // mit 1. Mai
            [
                26,
                '2018-04-09',
                '2018-05-04',
            ],
        ];
    }
}
