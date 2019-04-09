<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Mission extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'id',
        'user_id',
        'specification_id', // "Pflichtenheft"
        'start',
        'end',
        'draft', // "Aufgebot"
        'eligible_holiday',
        'mission_type',
        'first_time',
        'long_mission',
        'probation_period',
        'feedback_mail_sent',
        'feedback_done',
        'days',
    ];

    protected $casts = [
        'end'        => 'date',
        'first_time' => 'boolean',
        'start'      => 'date',
    ];

    public function report_sheets()
    {
        return $this->hasMany(ReportSheet::class);
    }

    public function specification()
    {
        return $this->belongsTo(Specification::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function getFormattedDate($fieldName)
    {
        $field = $this[$fieldName];
        $date = date_create_from_format('Y-m-d', $field);
        return date_format($date, 'd.m.Y');
    }

    public function getIllnessDaysLeftAttribute()
    {
        $availableIlnnessDays = floor($this->days / 30) * 6;
        $resttage_einsatz = $this->days % 30;
        if ($resttage_einsatz>= 1 && $resttage_einsatz<=3) {
            $availableIlnnessDays+=1;
        } elseif ($resttage_einsatz>= 4 && $resttage_einsatz<=8) {
            $availableIlnnessDays+=2;
        } elseif ($resttage_einsatz>= 9 && $resttage_einsatz<=14) {
            $availableIlnnessDays+=3;
        } elseif ($resttage_einsatz>= 15 && $resttage_einsatz<=21) {
            $availableIlnnessDays+=4;
        } elseif ($resttage_einsatz>= 22 && $resttage_einsatz<=29) {
            $availableIlnnessDays+=5;
        }

        return $availableIlnnessDays - $this->taken_illness_days;
    }

    public function getPaidClothesExpensesAttribute()
    {
        return $this->report_sheets->map(function ($reportSheet) {
            return $reportSheet->clothes;
        })->sum();
    }

    public function getTakenIllnessDaysAttribute()
    {
        return $this->report_sheets->map(function ($reportSheet) {
            return $reportSheet->ill;
        })->sum();
    }

    public function getTakenHolidaysAttribute()
    {
        if ($this->days >= 180) {
            return $this->report_sheets->map(function ($reportSheet) {
                return $reportSheet->holiday;
            })->sum();
        } else {
            return 0;
        }
    }
}
