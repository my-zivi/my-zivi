<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class RegionalCenter extends Model
{
    protected $fillable = [
        'id',
        'name',
        'address',
        'short_name',
    ];

    public $timestamps = false;
}
