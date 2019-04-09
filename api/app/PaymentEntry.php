<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PaymentEntry extends Model
{
    protected $fillable = [
        'amount',
        'iban',
        'id',
        'payment_id',
        'report_sheet_id',
        'user_id',
    ];

    public function report_sheet()
    {
        return $this->belongsTo(ReportSheet::class);
    }

    public function payment()
    {
        return $this->belongsTo(Payment::class);
    }

    // TODO drop relation with user
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
