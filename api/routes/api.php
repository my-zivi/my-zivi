<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$api = $app->make(Dingo\Api\Routing\Router::class);

$api->version('v1', function ($api) {
    $api->post('/auth/login', [
        'as' => 'api.auth.login',
        'uses' => 'App\Http\Controllers\Auth\AuthController@postLogin',
    ]);

    $api->group([
        'middleware' => 'api.auth',
    ], function ($api) {

        // Root
        $api->get('/', [
            'uses' => 'App\Http\Controllers\APIController@getIndex',
            'as' => 'api.index'
        ]);

        // Authentication
        $api->get('/auth/user', [
            'uses' => 'App\Http\Controllers\Auth\AuthController@getUser',
            'as' => 'api.auth.user'
        ]);
        $api->patch('/auth/refresh', [
            'uses' => 'App\Http\Controllers\Auth\AuthController@patchRefresh',
            'as' => 'api.auth.refresh'
        ]);
        $api->delete('/auth/invalidate', [
            'uses' => 'App\Http\Controllers\Auth\AuthController@deleteInvalidate',
            'as' => 'api.auth.invalidate'
        ]);

        // Canton
        $api->get('/canton', function () {
            return response()->json(App\Canton::all());
        });
        $api->get('/canton/{id}', function ($id) {
            return response()->json(App\Canton::find($id));
        });

        // User
        $api->get('/user', function () {
            return response()->json(App\User::all());
        });
        $api->get('/user/{id}', function ($id) {
            return response()->json(App\User::find($id));
        });
        $api->post('/user', function ($id) {
            return 'POST: '.$id;
        });

        // Specification (Pflichtenheft)
        $api->get('/specification', function () {
            return response()->json(App\Specification::all());
        });
        $api->get('/specification/{id}', function ($id) {
            return response()->json(App\Specification::find($id));
        });

        // Holiday Type
        $api->get('/holiday_type', function () {
            return response()->json(App\HolidayType::all());
        });
        $api->get('/holiday_type/{id}', function ($id) {
            return response()->json(App\HolidayType::find($id));
        });

        // Holiday
        $api->get('/holiday', function () {
            return response()->json(App\Holiday::all());
        });
        $api->get('/holiday/{id}', function ($id) {
            return response()->json(App\Holiday::find($id));
        });

        // Mission
        $api->get('/mission', function () {
            return response()->json(App\Mission::all());
        });
        $api->get('/mission/{id}', function ($id) {
            return response()->json(App\Mission::find($id));
        });

        // Role
        $api->get('/role', function () {
            return response()->json(App\Role::all());
        });
        $api->get('/role/{id}', function ($id) {
            return response()->json(App\Role::find($id));
        });

        // Log
        $api->get('/log', function () {
            return response()->json(App\Log::all());
        });
        $api->get('/log/{id}', function ($id) {
            return response()->json(App\Log::find($id));
        });

        // Regionalcenter
        $api->get('/regionalcenter', function () {
            return response()->json(App\RegionalCenter::all());
        });
        $api->get('/regionalcenter/{id}', function ($id) {
            return response()->json(App\RegionalCenter::find($id));
        });

        // Reportsheet
        $api->get('/reportsheet', function () {
            return response()->json(App\ReportSheet::all());
        });
        $api->get('/reportsheet/{id}', function ($id) {
            return response()->json(App\ReportSheet::find($id));
        });
    });
});
