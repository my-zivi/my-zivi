<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Holiday extends Model
{
    protected $fillable = [
        'date_from',
        'date_to',
        'description',
        'holiday_type_id',
    ];

    public function holiday_type()
    {
        return $this->belongsTo(HolidayType::class);
    }
}
