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

use Illuminate\Support\Facades\Input;
use Tymon\JWTAuth\Facades\JWTAuth;

$api = $app->make(Dingo\Api\Routing\Router::class);

$api->version('v1', function ($api) {
    $api->post('/auth/login', [
        'as' => 'api.auth.login',
        'uses' => 'App\Http\Controllers\Auth\AuthController@postLogin',
    ]);

    $api->post('/auth/register', [
        'as' => 'api.auth.register',
        'uses' => 'App\Http\Controllers\Auth\AuthController@postRegister'
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
            return response()->json(JWTAuth::parseToken()->authenticate());
        });
        $api->get('/user/zivi', [
            'uses' => 'App\Http\Controllers\UserController@getZivis',
            'as' => 'api.user.getZivis'
        ]);
        $api->get('/user/{id}', function ($id) {
            return response()->json(App\User::find($id));
        });
        $api->delete('/user/{id}', function ($id) {
            App\User::destroy($id);
            return response("deleted");
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
        $api->post('/specification/{id}', function ($id) {
            $spec = App\Specification::find($id);
            $spec->accommodation = Input::get("accommodation", "");
            $spec->active = Input::get("active", "");
            $spec->firstday_breakfast_expenses = Input::get("firstday_breakfast_expenses", "");
            $spec->firstday_dinner_expenses = Input::get("firstday_dinner_expenses", "");
            $spec->firstday_lunch_expenses = Input::get("firstday_lunch_expenses", "");
            $spec->lastday_breakfast_expenses = Input::get("lastday_breakfast_expenses", "");
            $spec->lastday_dinner_expenses = Input::get("lastday_dinner_expenses", "");
            $spec->lastday_lunch_expenses = Input::get("lastday_lunch_expenses", "");
            $spec->name = Input::get("name", "");
            $spec->pocket = Input::get("pocket", "");
            $spec->short_name = Input::get("short_name", "");
            $spec->sparetime_breakfast_expenses = Input::get("sparetime_breakfast_expenses", "");
            $spec->sparetime_dinner_expenses = Input::get("sparetime_dinner_expenses", "");
            $spec->sparetime_lunch_expenses = Input::get("sparetime_lunch_expenses", "");
            $spec->working_breakfast_expenses = Input::get("working_breakfast_expenses", "");
            $spec->working_clothes_expense = Input::get("working_clothes_expense", "");
            $spec->working_clothes_payment = Input::get("working_clothes_payment", "");
            $spec->working_dinner_expenses = Input::get("working_dinner_expenses", "");
            $spec->working_lunch_expenses = Input::get("working_lunch_expenses", "");
            $spec->working_time_model = Input::get("working_time_model", "");
            $spec->working_time_weekly = Input::get("working_time_weekly", "");
            $spec->save();
            return response("updated");
        });

        $api->put('/specification/{id}', function ($id) {
            $spec = new App\Specification();
            $spec->id = $id;
            $spec->accommodation = Input::get("accommodation", "");
            $spec->active = Input::get("active", "");
            $spec->firstday_breakfast_expenses = Input::get("firstday_breakfast_expenses", "");
            $spec->firstday_dinner_expenses = Input::get("firstday_dinner_expenses", "");
            $spec->firstday_lunch_expenses = Input::get("firstday_lunch_expenses", "");
            $spec->lastday_breakfast_expenses = Input::get("lastday_breakfast_expenses", "");
            $spec->lastday_dinner_expenses = Input::get("lastday_dinner_expenses", "");
            $spec->lastday_lunch_expenses = Input::get("lastday_lunch_expenses", "");
            $spec->name = Input::get("name", "");
            $spec->pocket = Input::get("pocket", "");
            $spec->short_name = Input::get("short_name", "");
            $spec->sparetime_breakfast_expenses = Input::get("sparetime_breakfast_expenses", "");
            $spec->sparetime_dinner_expenses = Input::get("sparetime_dinner_expenses", "");
            $spec->sparetime_lunch_expenses = Input::get("sparetime_lunch_expenses", "");
            $spec->working_breakfast_expenses = Input::get("working_breakfast_expenses", "");
            $spec->working_clothes_expense = Input::get("working_clothes_expense", "");
            $spec->working_clothes_payment = Input::get("working_clothes_payment", "");
            $spec->working_dinner_expenses = Input::get("working_dinner_expenses", "");
            $spec->working_lunch_expenses = Input::get("working_lunch_expenses", "");
            $spec->working_time_model = Input::get("working_time_model", "");
            $spec->working_time_weekly = Input::get("working_time_weekly", "");
            $spec->save();
            return response("inserted");
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
            return response()->json(App\Holiday::orderBy('date_from', 'DESC')->get());
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
            return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'report_sheets.id AS id')
                ->orderBy('start')
                ->orderBy('end')
                ->orderBy('zdp')
                ->get());
        });

        $api->get('/reportsheet/pending', function () {
            return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'report_sheets.id AS id')
                ->where('done', '=', '0')
                ->orderBy('start')
                ->orderBy('end')
                ->orderBy('zdp')
                ->get());
        });

        $api->get('/reportsheet/current', function () {
            return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'report_sheets.id AS id')
                ->whereDate('start', '>=', date('Y-m-01'))
                ->whereDate('end', '<', date('Y-m-d', strtotime('first day of next month')))
                ->orderBy('start')
                ->orderBy('end')
                ->orderBy('zdp')
                ->get());
        });

        $api->get('/reportsheet/{id}', function ($id) {
            return response()->json(App\ReportSheet::getSpesen($id));
        });


        // PDF
        $api->get('/pdf/phoneList', [
            'as' => 'api.pdf',
            'uses' => 'App\Http\Controllers\PDF\PDFController@getPhoneList'
        ]);
        $api->get('/pdf/zivireportsheet', [
            'as' => 'api.pdf',
            'uses' => 'App\Http\Controllers\PDF\PDFController@getZiviReportSheet'
        ]);
    });
});
