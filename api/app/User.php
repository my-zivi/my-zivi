<?php

namespace App;

use Carbon\Carbon;
use Illuminate\Auth\Authenticatable;
use Illuminate\Contracts\Auth\Access\Authorizable as AuthorizableContract;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Laravel\Lumen\Auth\Authorizable;

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
        'address',
        'bank_bic',
        'bank_iban',
        'birthday',
        'chainsaw_workshop',
        'city',
        'driving_licence_b',
        'driving_licence_be',
        'email',
        'first_name',
        'internal_note',
        'hometown',
        'last_name',
        'phone',
        'regional_center_id',
        'role_id',
        'work_experience',
        'zdp',
        'zip',
    ];

    protected $appends = [
        'start',
        'end',
        'active',
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

    protected $casts = [
        'chainsaw_workshop'  => 'boolean',
        'driving_licence_b'  => 'boolean',
        'driving_licence_be' => 'boolean',
    ];

    // TODO Check phone number formatting in update hook

    public function missions()
    {
        return $this->hasMany(Mission::class);
    }

    public function regionalCenter()
    {
        return $this->belongsTo(RegionalCenter::class);
    }

    public function reportSheets()
    {
        return $this->hasMany(ReportSheet::class);
    }

    public function role()
    {
        return $this->belongsTo(Role::class);
    }

    /**
     * Get the start date of the latest mission
     *
     * @return null|string
     */
    public function getStartAttribute()
    {
        if (!$this->missions->isEmpty()) {
            return $this->missions->sortByDesc('start')->first()->start->toDateString();
        }
        return null;
    }

    /**
     * Get the end date of the latest mission
     *
     * @return null|string
     */
    public function getEndAttribute()
    {
        if (!$this->missions->isEmpty()) {
            return $this->missions->sortByDesc('end')->first()->end->toDateString();
        }
        return null;
    }

    /**
     * Does the user have a current mission
     *
     * @return boolean
     */
    public function getActiveAttribute()
    {
        if (!$this->missions->isEmpty()) {
            $lastMission = $this->missions->sortByDesc('end')->first();
            $today = Carbon::now();
            return $today->between($lastMission->end, $lastMission->start);
        }
        return false;
    }

    public function getCleanIbanAttribute()
    {
        return str_replace(' ', '', $this->bank_iban);
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
        return [
            'isAdmin' => $this->role_id == 1,
        ];
    }

    /**
     * Return whether the user is an administrator
     *
     * @return boolean
     */
    public function isAdmin()
    {
        $role_admin = Role::where('name', '=', 'admin')->first();
        if ($this->role_id === $role_admin['id']) {
            return true;
        } else {
            return false;
        }
    }
}
