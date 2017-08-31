<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UserFeedbackQuestion extends Model
{
    public $timestamps = false;

    protected $fillable = [
                        'id',
                        'question',
                        'new_page',
                        'type',
                        'required',
                        'custom_info',
                        'opt1',
                        'opt2',
                        'opt3',
                        'pos',
                        'active'
        ];
}
