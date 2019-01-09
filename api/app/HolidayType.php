<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class HolidayType extends Model
{
    protected $fillable = ['id',
                           'name'
                        ];

    public function holiday()
    {
        return $this->hasMany('App\Holiday');
    }

    public $timestamps = false;
}
