<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UserFeedbackQuestion extends Model
{
    public $timestamps = false;

    protected $fillable = [
                        'id',
                        'question',
                        'json',
                        'new_page',
                        'type',
                        'opt1',
                        'opt2',
                        'opt3',
                        'pos',
                        'active'
        ];
}
