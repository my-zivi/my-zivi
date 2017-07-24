<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Specification extends Model
{
    protected $fillable = ['id',
                           'name ',
                           'short_name ',
                           'working_clothes_payment ',
                           'working_clothes_expense ',
                           'working_breakfast_expenses ',
                           'working_lunch_expenses ',
                           'working_dinner_expenses ',
                           'sparetime_breakfast_expenses ',
                           'sparetime_lunch_expenses ',
                           'sparetime_dinner_expenses ',
                           'firstday_breakfast_expenses ',
                           'firstday_lunch_expenses ',
                           'firstday_dinner_expenses ',
                           'lastday_breakfast_expenses ',
                           'lastday_lunch_expenses ',
                           'lastday_dinner_expenses ',
                           'working_time_model ',
                           'working_time_weekly ',
                           'accommodation ',
                           'pocket ',
                           'manualfile ',
                           'active'
                        ];
}
