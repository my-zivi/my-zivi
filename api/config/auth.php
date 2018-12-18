<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Authentication Defaults
    |--------------------------------------------------------------------------
    |
    | This option controls the default authentication "guard" and password
    | reset options for your application. You may change these defaults
    | as required, but they're a perfect start for most applications.
    |
    */

    'defaults' => [
        'guard' => env('AUTH_GUARD', 'api'),
    ],

    /*
     * The driver name corresponds to the first argument given to viaRequest() in AuthServiceProvider
     */
    'guards' => [
        'api' => ['provider' => 'users', 'driver' => 'jwt-auth'],
    ],

    'providers' => [
        'users' => ['driver' => 'eloquent', 'model' => \App\User::class],
    ],

];
