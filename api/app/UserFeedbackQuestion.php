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
        'active',
    ];

    protected $casts = [
        'new_page' => 'boolean',
        'required' => 'boolean',
    ];

    public function user_feedbacks()
    {
        return $this->hasMany(UserFeedbackQuestion::class, 'questionId');
    }
}
