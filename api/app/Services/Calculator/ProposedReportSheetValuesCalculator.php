<?php

namespace App\Services\Calculator;

use App\Holiday;
use App\HolidayType;
use App\ReportSheet;
use Carbon\Carbon;
use Carbon\CarbonPeriod;

class ProposedReportSheetValuesCalculator
{
    // TODO Those "taken values" are currently wrong
    // Basically, as the previous implementation did, the taken values take all report sheets into count
    // this leads to false values if you're reviewing an older report sheet
    //  because the proposed values are already calculated based on the new ones
    public static function propose(ReportSheet $reportSheet)
    {
        $mission = $reportSheet->mission;
        $specification = $mission->specification;

        $proposedValues = [
            'company_holidays_as_zivi_holidays'  => 0,
            'company_holidays_as_zivi_vacations' => 0,
            'costs_clothes'                      => 0,
            'costs_sparetime'                    => 0,
            'holidays_left'                      => $mission->eligible_holiday - $mission->taken_holidays,
            'illness_days_left'                  => $mission->illness_days_left,
            'total'                              => 0,
            'workdays'                           => 0,
            'work_free_days'                     => 0,
        ];

        // Calculate worked days
        $allDatesInRange = CarbonPeriod::create($reportSheet->start, $reportSheet->end);

        foreach ($allDatesInRange as $date) {
            if ($date->isWeekend() || self::isPublicHoliday($date) || self::isCompanyHoliday($date)) {
                $proposedValues['work_free_days']++;
            } else {
                $proposedValues['workdays']++;
            }
        }

        // Calculate Company Vacation compensations
        $companyVacationInRange = VacationCalculator::calculateCompanyVacations($reportSheet->start, $reportSheet->end);

        if ($companyVacationInRange > 0) {
            if ($mission->eligible_holiday > 0) {
                if ($mission->eligible_holiday - $mission->taken_holidays - $companyVacationInRange <= 0) {
                    $proposedValues['company_holidays_as_zivi_holidays'] = $mission->eligible_holiday - $mission->taken_holidays;
                } else {
                    $proposedValues['company_holidays_as_zivi_holidays'] = $companyVacationInRange;
                }

                $proposedValues['company_holidays_as_zivi_vacations'] = $companyVacationInRange - $proposedValues['company_holidays_as_zivi_holidays'];
            } else {
                $proposedValues['company_holidays_as_zivi_vacations'] = $companyVacationInRange;
            }
        }

        // Calculate proposal for clothes
        $clothesIdea = ($proposedValues['workdays'] + $proposedValues['work_free_days'] + $proposedValues['company_holidays_as_zivi_holidays']) * $specification->working_clothes_expense;
        $proposedValues['costs_clothes'] = min(24000, $clothesIdea);
        $proposedValues['costs_clothes'] = min($proposedValues['costs_clothes'], 24000 - $mission->paid_clothes_expenses);

        return $proposedValues;
    }

    private static function isPublicHoliday(Carbon $date)
    {
        $companyVacationType = HolidayType::where('name', '=', 'Betriebsferien')->first();

        if (is_null($companyVacationType)) {
            throw new \Exception('No type for company vacation registered in database!');
        }

        return !is_null(Holiday::where([
            [
                'date_from',
                '<=',
                $date,
            ],
            [
                'date_to',
                '>=',
                $date,
            ],
        ])->whereNotIn('holiday_type_id', [$companyVacationType->id])->first());
    }

    private static function isCompanyHoliday(Carbon $date)
    {
        $companyVacationType = HolidayType::where('name', '=', 'Betriebsferien')->first();

        if (is_null($companyVacationType)) {
            throw new \Exception('No type for company vacation registered in database!');
        }

        return !is_null(Holiday::where([
            [
                'holiday_type_id',
                '=',
                $companyVacationType->id,
            ],
            [
                'date_from',
                '<=',
                $date,
            ],
            [
                'date_to',
                '>=',
                $date,
            ],
        ])->first());
    }
}
