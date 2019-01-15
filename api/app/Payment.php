<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = ['amount', 'xml'];

    public function payment_entries()
    {
        return $this->hasMany(PaymentEntry::class);
    }
}
