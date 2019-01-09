<?php

namespace App\Services\Calculator;

use App\Holiday;
use App\HolidayType;
use Carbon\Carbon;

class VacationCalculator
{
    // this class is responsible to calculate all kinds of vacations
    public static function calculateCompanyVacations(Carbon $start, Carbon $end): int
    {
        $companyVacationType = HolidayType::where('name', '=', 'Betriebsferien')->first();

        if (is_null($companyVacationType)) {
            throw new \Exception('No type for company vacation registered in database!');
        }

        $realStart = $start->copy()->subDay();
        $realEnd = $end->copy()->addDay();

        $vacationsInTimespan = Holiday::where('date_from', '<=', $realEnd)
            ->where('date_to', '>=', $realStart)
            ->get();

        $companyVacations = $vacationsInTimespan->where('holiday_type_id', $companyVacationType->id);
        $publicHolidays = $vacationsInTimespan->whereNotIn('holiday_type_id', [$companyVacationType->id]);

        $countableCompanyVacationDays = 0;

        foreach ($companyVacations as $companyVacation) {
            $startOfCompanyVacation = Carbon::parse($companyVacation->date_from);
            $endOfCompanyVacation = Carbon::parse($companyVacation->date_to)->addDay();

            if ($startOfCompanyVacation < $start) {
                $startOfCompanyVacation = $realStart;
            }

            if ($endOfCompanyVacation > $end) {
                $endOfCompanyVacation = $realEnd;
            }

            for ($dayInCompanyVacation = $startOfCompanyVacation; $dayInCompanyVacation < $endOfCompanyVacation; $dayInCompanyVacation->addDay(
            )) {
                if (!$dayInCompanyVacation->isWeekend()) {
                    $isPublicHoliday = false;

                    foreach ($publicHolidays as $publicHoliday) {
                        if ($dayInCompanyVacation->between(Carbon::parse($publicHoliday->date_from), Carbon::parse($publicHoliday->date_to))) {
                            $isPublicHoliday = true;
                            break;
                        }
                    }

                    if (!$isPublicHoliday) {
                        $countableCompanyVacationDays++;
                    }
                }
            }
        }

        return $countableCompanyVacationDays;
    }

    public static function calculatePublicHolidays(Carbon $start, Carbon $end)
    {
        $companyVacationType = HolidayType::where('name', '=', 'Betriebsferien')->first();

        if (is_null($companyVacationType)) {
            throw new \Exception('No type for company vacation registered in database!');
        }

        $realStart = $start->copy()->subDay();
        $realEnd = $end->copy()->addDay();

        $publicHolidays = Holiday::where('date_from', '<=', $realEnd)
            ->where('date_to', '>=', $realStart)
            ->where('holiday_type_id', '!=', $companyVacationType->id)
            ->get();

        $publicHolidaysCount = 0;
        $alreadyUsedHolidays = [];

        foreach ($publicHolidays as $publicHoliday) {
            $parsedHolidayStart = Carbon::parse($publicHoliday['date_from']);
            $parsedHolidayEnd = Carbon::parse($publicHoliday['date_to'])->addDay();

            $publicHolidayStart = $parsedHolidayStart->gt($start) ? $parsedHolidayStart : $start;
            $publicHolidayEnd = $parsedHolidayEnd->gt($realEnd) ? $realEnd : $parsedHolidayEnd;

            $publicHolidaysCount += $publicHolidayStart->diffInDaysFiltered(function (Carbon $date) use (&$alreadyUsedHolidays) {
                return !$date->isWeekend() && !in_array($date->format('Y-m-d'), $alreadyUsedHolidays);
            }, $publicHolidayEnd);

            for ($date = $publicHolidayStart; $date <= $publicHolidayEnd; $date->addDay()) {
                $alreadyUsedHolidays[] = $date->format('Y-m-d');
            }
        }

        return $publicHolidaysCount;
    }

    public static function calculateZiviHolidays(int $dayCount)
    {
        $minDayCountForHolidays = 180;
        $baseHolidays = 8;
        $additionalHolidayDaysPer30Days = 2;

        if ($dayCount < $minDayCountForHolidays) {
            return 0;
        } else {
            return $baseHolidays + (floor(($dayCount - $minDayCountForHolidays) / 30) * $additionalHolidayDaysPer30Days);
        }
    }
}
