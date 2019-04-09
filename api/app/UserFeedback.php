<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UserFeedback extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'answer',
        'questionId',
        'user_id',
        'year',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
