<?php

namespace App\Providers;

use App\User;
use Exception;
use Firebase\JWT\JWT;
use Illuminate\Http\Request;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Log;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Boot the authentication services for the application.
     *
     * @return void
     */
    public function boot()
    {
        // Here you may define how you wish users to be authenticated for your Lumen
        // application. The callback which receives the incoming request instance
        // should return either a User instance or null. You're free to obtain
        // the User instance via an API token or any other method necessary.

        $this->app['auth']->viaRequest('jwt-auth', function (Request $request) {
            if ($request->header('Authorization')) {
                $split = explode(' ', app('request')->header('Authorization'), 2);
                if (sizeof($split) > 1) {
                    $token = $split[1];
                } else {
                    return null;
                }
            } elseif ($request->query('token')) {
                $token = $request->query('token');
            } else {
                // Unauthorized response if token not there
                return null;
            }

            try {
                $credentials = JWT::decode($token, env('JWT_SECRET'), ['HS256']);
                $user = User::findOrFail($credentials->sub);
            } catch (Exception $e) {
                return null;
            }

            // handle case if somebody's access to Dime got blocked recently and its token is still valid
            if (app()->bound('sentry')) {
                /** @var \Raven_Client $sentry */
                $sentry = app('sentry');
                $sentry->user_context([
                    'id' => $user->id,
                    'email' => $user->email
                ]);
            }

            return $user;
        });
    }
}
