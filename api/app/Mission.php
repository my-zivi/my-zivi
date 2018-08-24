<?php

namespace App;

use App\ReportSheet;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Mission extends Model
{
    use SoftDeletes;

    protected $fillable = ['id',
                           'user',
                           'specification', // "Pflichtenheft"
                           'start',
                           'end',
                           'draft', // "Aufgebot"
                           'eligible_holiday',
                           'mission_type',
                           'first_time',
                           'long_mission',
                           'probation_period',
                           'feedback_mail_sent',
                           'feedback_done'
                        ];

    protected $appends = ['calculated_mission_days'];

    public function usermodel()
    {
        return $this->belongsTo('App\User', 'user');
    }

    public function getFormattedDate($fieldName)
    {
        $field = $this[$fieldName];
        $date = date_create_from_format('Y-m-d', $field);
        return date_format($date, 'd.m.Y');
    }

    public function getCalculatedMissionDaysAttribute()
    {
        return ReportSheet::getDiensttageCount($this->start, $this->end, $this->long_mission);
    }
}
