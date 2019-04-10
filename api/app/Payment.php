<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = [
        'amount',
        'xml',
    ];

    protected $hidden = [
        'xml',
        'xml_id',
    ];

    protected $appends = ['amount'];

    public function paymentEntries()
    {
        return $this->hasMany(PaymentEntry::class);
    }

    public function getAmountAttribute()
    {
        if ($this->paymentEntries->isEmpty()) {
            return 0;
        }

        return $this->paymentEntries->sum('reportSheet.total_costs');
    }
}
