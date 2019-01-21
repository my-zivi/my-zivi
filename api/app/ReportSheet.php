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

    // Delete all linked report sheets to a mission when a mission is soft deleted
    public static function deleteByMission($missionId)
    {
        // TODO remove this method and solve it through database cascade instead
        $reportSheets = ReportSheet::where('mission_id', '=', $missionId);
        $reportSheets->delete();
    }
}
