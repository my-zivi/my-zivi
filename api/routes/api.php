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


        $api->get('/user/zivi', [
            'uses' => 'App\Http\Controllers\UserController@getZivis',
            'as' => 'api.user.getZivis'
        ]);

        // User
        $api->get('/user', function () {
            $user = JWTAuth::parseToken()->authenticate();
            $user->missions = $user->missions;
            return response()->json($user);
        });

        $api->get('/user/{id}', function ($id) {
            $user = App\User::find($id);
            $user->missions = $user->missions;
            return response()->json($user);
        });

        $api->delete('/user/{id}', function ($id) {
            App\User::destroy($id);
            return response("deleted");
        });
        $api->post('/user/{id}', function ($id) {
            $user = App\User::find($id);
            $user->created_at = Input::get("created_at", "");
            $user->updated_at = Input::get("updated_at", "");
            $user->deleted_at = Input::get("deleted_at", "");
            $user->email = Input::get("email", "");
            $user->role = Input::get("role", "");
            $user->zdp = Input::get("zdp", "");
            $user->first_name = Input::get("first_name", "");
            $user->last_name = Input::get("last_name", "");
            $user->address = Input::get("address", "");
            $user->city = Input::get("city", "");
            $user->zip = Input::get("zip", "");
            $user->hometown = Input::get("hometown", "");
            $user->hometown_canton = Input::get("hometown_canton", "");
            $user->canton = Input::get("canton", "");
            $user->birthday = Input::get("birthday", "");
            $user->phone_mobile = Input::get("phone_mobile", "");
            $user->phone_private = Input::get("phone_private", "");
            $user->phone_business = Input::get("phone_business", "");
            $user->bank_iban = Input::get("bank_iban", "");
            $user->post_account = Input::get("post_account", "");
            $user->work_experience = Input::get("work_experience", "");
            $user->driving_licence = Input::get("driving_licence", "");
            $user->travel_card = Input::get("travel_card", "");
            $user->regional_center = Input::get("regional_center", "");
            $user->internal_note = Input::get("internal_note", "");
            $user->save();
            return response("updated");
        });

        $api->post('/postChangePassword', [
            'as' => 'api.user.postChangePassword',
            'uses' => 'App\Http\Controllers\UserController@changePassword'
        ]);

        // Specification (Pflichtenheft)
        $api->get('/specification', function () {
            return response()->json(App\Specification::select('*', 'id AS fullId')->get());
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
        $api->post('/holiday/{id}', function ($id) {
            $holiday = App\Holiday::find($id);
            $holiday->date_from = Input::get("date_from");
            $holiday->date_to = Input::get("date_to");
            $holiday->holiday_type = Input::get("holiday_type");
            $holiday->description = Input::get("description");
            $holiday->save();
            return response("updated");
        });

        $api->put('/holiday', function () {
            $holiday = new App\Holiday();
            $holiday->date_from = Input::get("date_from");
            $holiday->date_to = Input::get("date_to");
            $holiday->holiday_type = Input::get("holiday_type");
            $holiday->description = Input::get("description");
            $holiday->save();
            return response("inserted");
        });

        $api->delete('/holiday/{id}', function ($id) {
            $holiday = App\Holiday::find($id);
            $holiday->delete();
            return response("deleted");
        });

        // Mission
        $api->get('/missions/{year}', function ($year) {
            return response()->json(App\Mission::join('users', 'users.id', '=', 'missions.user')
                                    ->join('specifications', 'specifications.id', '=', 'missions.specification')
                                    ->select('*', 'users.id AS userid')
                                    ->whereDate('end', '>=', $year.'-01-01')
                                    ->whereDate('start', '<=', $year.'-12-31')
                                    ->orderBy('start')
                                    ->get());
        });

        $api->put('/mission', function () {
            $mission = new App\Mission();
            $mission->user = Input::get("user", "");
            $mission->specification = Input::get("specification", "");
            $mission->start = Input::get("start", "");
            $mission->end = Input::get("end", "");
            $mission->eligible_holiday = 0;//TODO:??
            $mission->role = 3; //TODO: needed??
            $mission->first_time = Input::get("first_time", false);
            $mission->long_mission = Input::get("long_mission", false);
            $mission->probation_period = Input::get("probation_period", false);
            $mission->save();
            return response("inserted");
        });

        $api->delete('/mission/{id}', function ($id) {
            App\Mission::find($id)->delete();
            return response("deleted");
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
                ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'done', 'report_sheets.id AS id')
                ->orderBy('start')
                ->orderBy('end')
                ->orderBy('zdp')
                ->get());
        });

        $api->get('/reportsheet/pending', function () {
            return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'done', 'report_sheets.id AS id')
                ->where('done', '=', '0')
                ->orderBy('start')
                ->orderBy('end')
                ->orderBy('zdp')
                ->get());
        });

        $api->get('/reportsheet/current', function () {
            return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'done', 'report_sheets.id AS id')
                ->whereDate('start', '>=', date('Y-m-01'))
                ->whereDate('end', '<', date('Y-m-d', strtotime('first day of next month')))
                ->orderBy('start')
                ->orderBy('end')
                ->orderBy('zdp')
                ->get());
        });

        $api->get('/reportsheet/me', function () {
            $user = JWTAuth::parseToken()->authenticate();
            return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                ->select('report_sheets.id AS id', 'start', 'end', 'done')
                ->where('users.id', '=', $user->id)
                ->orderBy('start')
                ->orderBy('end')
                ->orderBy('zdp')
                ->get());
        });

        $api->get('/reportsheet/{id}', function ($id) {
            return response()->json(App\ReportSheet::getSpesen($id));
        });

        $api->post('/reportsheet/{id}', function ($id) {
            $sheet = App\ReportSheet::find($id);
            $sheet->work = Input::get("meldeblaetter_workdays", "");
            $sheet->work_comment = Input::get("meldeblaetter_work_comment", "");
            $sheet->workfree = Input::get("meldeblaetter_workfreedays", "");
            $sheet->workfree_comment = Input::get("meldeblaetter_workfree_comment", "");
            $sheet->company_holiday_vacation = Input::get("meldeblaetter_companyurlaub", "");
            $sheet->company_holiday_comment = Input::get("meldeblaetter_compholiday_comment", "");
            $sheet->company_holiday_holiday = Input::get("meldeblaetter_ferien_wegen_urlaub", "");
            $sheet->additional_workfree_comment = Input::get("meldeblaetter_add_workfree_comment", "");
            $sheet->ill = Input::get("meldeblaetter_ill", "");
            $sheet->ill_comment = Input::get("meldeblaetter_ill_comment", "");
            $sheet->holiday = Input::get("meldeblaetter_holiday", "");
            $sheet->holiday_comment = Input::get("meldeblaetter_holiday_comment", "");
            $sheet->vacation = Input::get("meldeblaetter_urlaub", "");
            $sheet->vacation_comment = Input::get("meldeblaetter_urlaub_comment", "");
            $sheet->clothes = Input::get("meldeblaetter_kleider", "")*100;
            $sheet->clothes_comment = Input::get("meldeblaetter_kleider_comment", "");
            $sheet->driving_charges = Input::get("meldeblaetter_fahrspesen", "")*100;
            $sheet->driving_charges_comment = Input::get("meldeblaetter_fahrspesen_comment", "");
            $sheet->extraordinarily = Input::get("meldeblaetter_ausserordentlich", "")*100;
            $sheet->extraordinarily_comment = Input::get("meldeblaetter_ausserordentlich_comment", "");
            $sheet->bank_account_number = Input::get("bank_account_number", "");
            $sheet->document_number = Input::get("document_number", "");
            $sheet->booked_date = Input::get("booked_date", "");
            $sheet->paid_date = Input::get("paid_date", "");
            $sheet->done = Input::get("done", "");
            $sheet->save();
            return response("updated");
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

        $api->get('/pdf/statistik', [
            'as' => 'api.pdf',
            'uses' => 'App\Http\Controllers\PDF\PDFController@getSpesenStatistik'
        ]);
    });
});
