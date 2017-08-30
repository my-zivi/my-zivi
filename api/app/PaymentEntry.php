<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PaymentEntry extends Model
{
    protected $fillable = ['id',
                           'user',
                           'report_sheet',
                            'amount',
                            'iban'
                        ];
}
