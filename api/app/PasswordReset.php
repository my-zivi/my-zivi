<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 8/9/17
 * Time: 9:10 AM
 */

namespace App;

use Illuminate\Database\Eloquent\Model;

class PasswordReset extends Model
{
    public $timestamps = false;

    protected $fillable = ['email',
        'token'
    ];
}
