<?php

namespace App\Services\Calculator;

use Carbon\Carbon;

class MissionDaysCalculator
{
    public static function calculateEligibleDays(Carbon $start, Carbon $end): int
    {
        $diffInDays = $start->diffInDays($end->copy()->addDay());
        $companyHolidays = VacationCalculator::calculateCompanyVacations($start->copy(), $end->copy());

        if ($diffInDays < 26) {
            $allowedFreeDays = self::allowedFreeDays($diffInDays);

            $weekendDays = $start->diffInDaysFiltered(function (Carbon $date) {
                return $date->isWeekend();
            }, $end->copy()->addDay());

            $publicHolidays = VacationCalculator::calculatePublicHolidays($start->copy(), $end->copy());

            // if the allowed free days can't "compensate" the public holidays, weekends and company holidays
            // do subtract them from the count of days
            $diffInDays -= max(0, $weekendDays + $publicHolidays + $companyHolidays - $allowedFreeDays);
        } else {
            $ziviHolidays = VacationCalculator::calculateZiviHolidays($diffInDays);

            // if the amount of holidays of the zivi can't "compensate" the company holidays
            // or the zivi has no holidays
            // do subtract them
            if ($ziviHolidays > 0) {
                $calcDays = $companyHolidays - $ziviHolidays;
                $diffInDays -= $calcDays > 0 ? $calcDays : 0;
            } else {
                $diffInDays -= $companyHolidays;
            }
        }

        return $diffInDays;
    }

    public static function calculatePossibleEndDate(Carbon $start, int $days): Carbon
    {
        $potentialEnd = $start->copy()->addDays($days - 1);

        $weekendDays = $start->diffInDaysFiltered(function (Carbon $date) {
            return $date->isWeekend();
        }, $potentialEnd->copy()->addDay());

        $publicHolidays = VacationCalculator::calculatePublicHolidays($start, $potentialEnd);
        $freeDaysInRange = $weekendDays + $publicHolidays;

        if ($days < 26) {
            $additionalDaysToCompensate = max(0, $freeDaysInRange - self::allowedFreeDays($days));
        } else {
            $additionalDaysToCompensate = 0;
        }

        $companyVacations = VacationCalculator::calculateCompanyVacations($start, $potentialEnd);
        $ziviHolidays = VacationCalculator::calculateZiviHolidays($days);
        $additionalDaysToCompensate += max(0, $companyVacations - $ziviHolidays);

        $ziviHolidaysLeft = max(0, $ziviHolidays - $companyVacations);

        $addDayIfDayOnCompanyVacation = function (Carbon $date) use (&$ziviHolidaysLeft) {
            if (VacationCalculator::calculateCompanyVacations($date, $date) > 0) {
                if ($ziviHolidaysLeft > 0) {
                    $ziviHolidaysLeft--;
                    return false;
                } else {
                    return true;
                }
            } else {
                return false;
            }
        };

        $end = $potentialEnd->copy();

        for ($i = 0; $i < $additionalDaysToCompensate; $i++) {
            do {
                $end->addDay();
            } while ($end->isWeekend() || VacationCalculator::calculatePublicHolidays($end->copy(), $end->copy()) > 0 || $addDayIfDayOnCompanyVacation($end->copy()));
        }

        return $end;
    }

    private static function allowedFreeDays(int $days): int
    {
        if ($days === 25) {
            return 6;
        } elseif ($days >= 21 && $days <= 24) {
            return 5;
        } elseif ($days >= 18 && $days <= 20) {
            return 4;
        } elseif ($days >= 14 && $days <= 17) {
            return 3;
        } elseif ($days >= 11 && $days <= 13) {
            return 2;
        } elseif ($days >= 7 && $days <= 10) {
            return 1;
        } else {
            return 0;
        }
    }
}
