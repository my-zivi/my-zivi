<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Mission extends Model
{
    use SoftDeletes;

    protected $fillable = ['id',
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
        'days'
    ];

    protected $casts = [
        'first_time' => 'boolean'
    ];

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
}
