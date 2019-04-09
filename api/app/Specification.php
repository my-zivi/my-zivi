<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Specification extends Model
{
    public $timestamps = false;
    public $incrementing = false;

    protected $fillable = [
        'id',
        'name',
        'short_name',
        'working_clothes_payment',
        'working_clothes_expense',
        'working_breakfast_expenses',
        'working_lunch_expenses',
        'working_dinner_expenses',
        'sparetime_breakfast_expenses',
        'sparetime_lunch_expenses',
        'sparetime_dinner_expenses',
        'firstday_breakfast_expenses',
        'firstday_lunch_expenses',
        'firstday_dinner_expenses',
        'lastday_breakfast_expenses',
        'lastday_lunch_expenses',
        'lastday_dinner_expenses',
        'working_time_model',
        'working_time_weekly',
        'accommodation',
        'pocket',
        'manualfile',
        'active',
    ];

    protected $casts = [
        'active' => 'boolean',
    ];

    protected $attributes = [
        'manual_file'         => 'conditions.pdf',
        'working_time_model'  => false,
        'working_time_weekly' => '42h',
    ];

    public function getDailyFirstDayCostsAttribute()
    {
        return $this->pocket + $this->accommodation + $this->firstday_breakfast_expenses + $this->firstday_lunch_expenses + $this->firstday_dinner_expenses;
    }

    public function getDailyLastDayCostsAttribute()
    {
        return $this->pocket + $this->accommodation + $this->lastday_breakfast_expenses + $this->lastday_lunch_expenses + $this->lastday_dinner_expenses;
    }

    public function getDailySpareTimeCostsAttribute()
    {
        return $this->pocket + $this->accommodation + $this->sparetime_breakfast_expenses + $this->sparetime_lunch_expenses + $this->sparetime_dinner_expenses;
    }

    public function getDailyWorkTimeCostsAttribute()
    {
        return $this->pocket + $this->accommodation + $this->working_breakfast_expenses + $this->working_lunch_expenses + $this->working_dinner_expenses;
    }
}
