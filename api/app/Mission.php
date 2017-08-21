<?php

namespace App;

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
                           'probation_day',
                           'probation_day_comment',
                           'feedback_mail_sent'
                        ];

    public function usermodel()
    {
        return $this->belongsTo('App\User', 'user');
    }
}
