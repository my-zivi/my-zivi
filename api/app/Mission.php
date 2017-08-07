<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Mission extends Model
{
    protected $fillable = ['id',
                           'user',
                           'specification', // "Pflichtenheft"
                           'start',
                           'end',
                           'draft', // "Aufgebot"
                           'eligible_holiday',
                           'role',
                           'first_time',
                           'long_mission',
                           'probation_period'
                        ];

    public function user()
    {
        return $this->belongsTo('App\User');
    }
}
