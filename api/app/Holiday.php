<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Holiday extends Model
{
    protected $fillable = ['id',
                           'date_from',
                           'date_to',
                           'holiday_type',
                           'description'
                        ];
}
