<?php

namespace App;

use Illuminate\Auth\Authenticatable;
use Laravel\Lumen\Auth\Authorizable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Contracts\Auth\Access\Authorizable as AuthorizableContract;

class User extends Model implements
    AuthenticatableContract,
    AuthorizableContract
{
    use Authenticatable, Authorizable, SoftDeletes;

    protected $dates = ['deleted_at'];

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'email',
        'zdp',
        'first_name',
        'last_name',
        'email',
        'role',
        'address',
        'zip',
        'city',
        'canton',
        'birthday',
        'hometown',
        'phone_mobile',
        'phone_private',
        'phone_business',
        'bank_iban',
        'work_experience',
        'driving_licence',
        'ga_travelcard',
        'half_fare_travelcard',
        'other_fare_network',
        'regional_center',
        'internal_note'
    ];

    /**
     * The attributes excluded from the model's JSON form.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    public function missions()
    {
        return $this->hasMany('App\Mission', 'user');
    }

    public function report_sheets()
    {
        return $this->hasMany('App\ReportSheet', 'user');
    }

    public function canton()
    {
        return $this->belongsTo('App\Canton', 'canton');
    }

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

    /**
     * Return whether the user is an administrator
     *
     * @return boolean
     */
    public function isAdmin()
    {
        $role_admin = Role::where('name', '=', 'admin')->first();
        if ($this->role === $role_admin['id']) {
            return true;
        } else {
            return false;
        }
    }
}
