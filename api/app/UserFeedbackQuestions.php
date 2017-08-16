<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UserFeedbackQuestions extends Model
{
    public $timestamps = false;

    protected $fillable = [
                        'id',
                        'question',
                        'type',
                        'opt1',
                        'opt2',
                        'opt3',
                        'pos',
                        'active'
        ];
}
