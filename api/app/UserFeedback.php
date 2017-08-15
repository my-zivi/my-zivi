<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UserFeedback extends Model
{
    public $timestamps = false;

    protected $fillable = [
                            'id',
                            'user',
                            'year',
                            'questionId',
                            'answer'

        ];

    /**
     * Get the identifier that will be stored in the subject claim of the JWT.
     *
     * @return mixed
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }
}
