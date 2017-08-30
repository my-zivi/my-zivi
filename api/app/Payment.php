<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = ['id',
                           'xml',
                            'amount'
                        ];
}
