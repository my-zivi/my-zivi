<?php

namespace App;

use App\CompanyInfo;
use App\Http\Controllers\API\MissionController;
use App\Services\Calculator\ProposedReportSheetValuesCalculator;
use App\Services\PDF\PDF;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use \DateTime;

class ReportSheet extends Model
{
    use SoftDeletes;

    protected $appends = [
        'total_costs'
    ];

    protected $casts = [
        'end' => 'date',
        'ignore_first_last_day' => 'boolean',
        'start' => 'date'
    ];

    protected $fillable = ['additional_workfree', 'additional_workfree_comment', 'bank_account_number', 'clothes',
        'clothes_comment', 'company_holiday', 'company_holiday_comment', 'document_number', 'driving_charges',
        'driving_charges_comment', 'end', 'extraordinarily', 'extraordinarily_comment', 'holiday', 'holiday_comment', '
        ignore_first_last_day', 'ill', 'ill_comment', 'mission_id', 'national_holiday', 'start', 'state', 'user_id',
        'vacation', 'vacation_comment', 'work', 'work_comment', 'workfree', 'workfree_comment',
        ];

    public function mission()
    {
        return $this->belongsTo(Mission::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function getChargedDaysAttribute()
    {
        return $this->work + $this->workfree + $this->additional_workfree + $this->ill + $this->holiday + $this->company_holiday_holiday + $this->vacation + $this->company_holiday_vacation;
    }

    public function getClothesDaysAttribute()
    {
        return $this->work + $this->workfree + $this->holiday + $this->ill;
    }

    public function getDurationAttribute()
    {
        return $this->start->diffInDays($this->end->copy()->addDay());
    }

    public function getFirstDayAttribute()
    {
        return $this->start->eq($this->mission->start) && !$this->ignore_first_last_day ? 1 : 0;
    }

    public function getFirstDayCostsAttribute()
    {
        return $this->first_day * $this->mission->specification->daily_first_day_costs;
    }

    public function getHolidaysCostsAttribute()
    {
        return $this->mission->specification->daily_spare_time_costs * ($this->holiday + $this->company_holiday_holiday);
    }

    public function getIllDaysCostsAttribute()
    {
        return $this->mission->specification->daily_spare_time_costs * $this->ill;
    }

    public function getNormalWorkDaysAttribute()
    {
        $normalWorkDays = $this->work;

        if (!$this->ignore_first_last_day && $this->start->eq($this->mission->start)) {
            $normalWorkDays--;
        }

        if (!$this->ignore_first_last_day && $this->end->eq($this->mission->end)) {
            $normalWorkDays--;
        }

        return $normalWorkDays;
    }

    public function getLastDayAttribute()
    {
        return $this->end->eq($this->mission->end) && !$this->ignore_first_last_day ? 1 : 0;
    }

    public function getLastDayCostsAttribute()
    {
        return $this->last_day * $this->mission->specification->daily_last_day_costs;
    }

    public function getProposedValuesAttribute()
    {
        return ProposedReportSheetValuesCalculator::propose($this);
    }

    public function getTotalCostsAttribute()
    {
        if ($this->mission && $this->mission->specification) {
            return $this->ill_days_costs + $this->holidays_costs + $this->work_days_costs + $this->work_free_days_costs + $this->driving_charges + $this->clothes + $this->extraordinarily + $this->first_day_costs + $this->last_day_costs;
        } else {
            return 0;
        }
    }

    public function getWorkDaysCostsAttribute()
    {
        return $this->normal_work_days * $this->mission->specification->daily_work_time_costs;
    }

    public function getWorkFreeDaysCostsAttribute()
    {
        return $this->mission->specification->daily_spare_time_costs * ($this->workfree + $this->additional_workfree);
    }

    private static function countDaysBetween($start_TS, $end_TS)
    {
        if ($start_TS > $end_TS) {
            $tmp = $start_TS;
            $start_TS = $end_TS;
            $end_TS = $tmp;
        }
        $d = date("d", $start_TS);
        $m = date("m", $start_TS);
        $y = date("Y", $start_TS);
        $c = 0;
        $found = false;
        while (!$found) {
            if (mktime(0, 0, 0, $m, $d + $c, $y) == $end_TS) {
                $found = true;
                $c++;
            } else {
                $c++;
            }
            if ($c > 26000) {
                $c = 0;
                break;
            }
        }
        return $c;
    }

    private static function tomorrow($day_TS)
    {
        $d = date("j", $day_TS);
        $m = date("m", $day_TS);
        $y = date("Y", $day_TS);
        return mktime(0, 0, 0, $m, $d + 1, $y);
    }

    public static function getDiensttageCount($start, $end, $long_mission = false)
    {
        if (strtotime($end)>=strtotime($start)) {
            $dayCount = ReportSheet::countDaysBetween(strtotime($start), strtotime($end));
            return ReportSheet::subtractFreeDays($start, $end, $dayCount, $long_mission);
        } else {
            return 0;
        }
    }

    public static function getDiensttageEndDate($start, $days, $long_mission)
    {

        $end = $start;
        if (isset($days) && $days > 0) {
          // end date is usually start date + days
            $end = ReportSheet::addDaysToDate($start, $days-1);
            $lastEnd = $end;
            $chargedDays = -2;
            $hasHolidays = false;

          // the end date is increased until the charged days matches the selection (in case there are holidays)
            while ($chargedDays < $days && $chargedDays < 400) {
                $lastEnd = $end;
                $end = ReportSheet::addDaysToDate($end, 1);
                $chargedDays = ReportSheet::getDiensttageCount($start, $end, $long_mission);

                if ($chargedDays < $days+1) {
                    $hasHolidays = true;
                }
            }
        }

        // if there are holidays found, the date needs to be set to the next day
        if ($hasHolidays) {
            return $end;
        }

        return $lastEnd;
    }

    /**
    * Subtracts the number of days that are "Betriebsferien" and not "Feiertage"
    */
    private static function subtractFreeDays($start, $end, $dayCount, $long_mission)
    {
        $ziviHolidays = MissionController::calculateZiviHolidays($long_mission, $dayCount);

        $betriebsferien = Holiday::join('holiday_types', 'holidays.holiday_type_id', '=', 'holiday_types.id')
          ->whereDate('date_from', '<=', $end)
          ->whereDate('date_to', '>=', $start)
          ->where('holiday_types.name', '=', 'Betriebsferien')
          ->get();

        $feiertage = Holiday::join('holiday_types', 'holidays.holiday_type_id', '=', 'holiday_types.id')
          ->whereDate('date_from', '<=', $end)
          ->whereDate('date_to', '>=', $start)
          ->where('holiday_types.name', '=', 'Feiertag')
          ->get();

        foreach ($betriebsferien as $ferien) {
            for ($u = max(strtotime($start), strtotime($ferien['date_from'])); $u<=min(strtotime($end), strtotime($ferien['date_to'])); $u=ReportSheet::tomorrow($u)) {
                if (date('w', $u)==0 || date('w', $u)==6) {
                    //ingore saturday & sunday, because they count as Diensttag anyway
                } else {
                    $isInFeiertag = false;
                    foreach ($feiertage as $feiertag) {
                        if (strtotime($feiertag['date_from'])<=$u && $u<=strtotime($feiertag['date_to'])) {
                            $isInFeiertag = true;
                            break;
                        }
                    }
                    if (!$isInFeiertag) {
                        if ($ziviHolidays > 0) {
                            $ziviHolidays--;
                        } else {
                            $dayCount--;
                        }
                    }
                }
            }
        }

        return $dayCount;
    }

    /**
    * Returns the calculated date as a string
    */
    private static function addDaysToDate($dateString, $days)
    {
        $datetime = DateTime::createFromFormat('Y-m-d', $dateString);
        $datetime->modify('+'.$days.' day');
        return $datetime->format('Y-m-d');
    }

    public static function add($mission, $start, $end)
    {
        $sheet = new ReportSheet();
        $sheet->mission_id = $mission->id;
        $sheet->user_id = $mission->user_id;
        $sheet->start = $start;
        $sheet->end = $end;
        $sheet->bank_account_number = CompanyInfo::DEFAULT_ACCOUNT_NUMBER_REPORT_SHEETS;
        $sheet->additional_workfree = 0;
        $sheet->driving_charges = 0;
        $sheet->extraordinarily = 0;
        $sheet->ill = 0;
        $sheet->holiday = 0;
        $sheet->state = 0;
        $sheet->vacation = 0;
        $sheet->save();
    }

    // Delete all linked report sheets to a mission when a mission is soft deleted
    public static function deleteByMission($missionId)
    {
        // TODO remove this method and solve it through database cascade instead
        $reportSheets = ReportSheet::where('mission_id', '=', $missionId);
        $reportSheets->delete();
    }
}
