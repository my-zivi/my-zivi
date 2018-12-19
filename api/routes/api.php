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

use App\CompanyInfo;
use App\Http\Controllers\API\UserController;
use App\ReportSheet;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Input;
use Laravel\Lumen\Routing\Router;

/** @var Router $router */
$router->group(['namespace' => 'api', 'prefix' => 'api'], function () use ($router) {
    /** @var Router $router */
    // Auth - Public
    $router->post('/auth/login', ['uses' => 'AuthController@postLogin']);
    $router->post('/auth/register', ['uses' => 'AuthController@postRegister']);
    $router->post('/auth/forgotPassword', ['uses' => 'ForgotPasswordController@sendResetLinkEmail']);
    $router->post('/auth/resetPassword', ['uses' => 'ForgotPasswordController@resetPassword']);

    $router->group(['middleware' => 'auth'], function ($router) {
        /** @var Router $router */
        // Authentication - Authenticated
        $router->patch('/auth/refresh', ['uses' => 'AuthController@patchRefresh',]);

        // User - Authenticated
        $router->get('/user', function () {
            $user = Auth::user();
            unset($user->internal_note);
            return response()->json($user);
        });
        $router->post('/user/me', function () {
            $user = Auth::user();
            UserController::updateUser($user);
        });
        $router->post('/postChangePassword', ['uses' => 'UserController@changePassword']);

        // Specification (Pflichtenheft) - Authenticated
        $router->get('/specification/me', function () {
            return response()->json(
                App\Specification::
                select('id', 'name', 'active')
                    ->get()
            );
        });

        // Regionalcenter - Authenticated
        $router->get('/regionalcenter', function () {
            return response()->json(App\RegionalCenter::all());
        });
        $router->get('/regionalcenter/{id}', function ($id) {
            return response()->json(App\RegionalCenter::find($id));
        });

        // Mission - Authenticated
        $router->get('/user/missions', function () {
            $user = Auth::user();
            return response()->json($user->missions);
        });

        $router->get('/mission/{id}/draft', ['uses' => 'PDFController@getAufgebot']);

        // Reportsheet - Authenticated
        $router->get('/reportsheet/user/me', function () {
            $user = Auth::user();
            $reportSheets = App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                ->select('report_sheets.id AS id', 'start', 'end', 'state')
                ->where('users.id', '=', $user->id)
                ->where('state', '>', '0')
                ->orderBy('start')
                ->orderBy('end')
                ->orderBy('zdp')
                ->get();

            // Add calculated column days
            foreach ($reportSheets as $reportSheet) {
                $reportSheet['days'] = App\ReportSheet::getDiensttageCount($reportSheet->start, $reportSheet->end);
            }
            return response()->json($reportSheets);
        });

        // Service days - Authenticated
        $router->get('/diensttage', function () {
            $start = Input::get("start", "");
            $end = Input::get("end", "");
            $long_mission = Input::get("long_mission", false);

            return response()->json(ReportSheet::getDiensttageCount($start, $end, $long_mission));
        });

        $router->get('/diensttageEndDate', function () {
            $start = Input::get("start", "");
            $days = Input::get("days", "0");
            $long_mission = Input::get("long_mission", false);

            return response()->json(ReportSheet::getDiensttageEndDate($start, $days, $long_mission));
        });

        $router->post('/mission', [
            'uses' => 'MissionController@postMission'
        ]);

        $router->put('/mission/{id}', [
            'uses' => 'MissionController@putMission'
        ]);

        // PDF
        $router->get('/pdf/zivireportsheet', ['uses' => 'PDFController@getZiviReportSheet']);

        $router->get('/user_feedback_questions', [
            'uses' => 'FeedbackController@index'
        ]);

        $router->post('/user/feedback', [
            'uses' => 'FeedbackController@postFeedback'
        ]);

        $router->post('/phonenumber/validate', ['uses' => 'PhonenumberController@validatePhonenumber']);

        // Admins only
        $router->group(['middleware' => 'role'], function ($router) {
            /** @var Router $router */
            // Root - Admins
            $router->get('/', ['uses' => 'APIController@getIndex']);

            // User - Admins
            $router->get('/user/zivi', ['uses' => 'UserController@getZivis']);

            $router->get('/user/feedback', ['uses' => 'FeedbackController@getFeedbacks']);

            $router->get('/user/feedback/question', function () {
                $user_feedback_question = App\UserFeedbackQuestion::all();
                return response()->json($user_feedback_question);
            });
            $router->get('/user/feedback/{id}', ['uses' => 'FeedbackController@getFeedback']);

            $router->get('/user/feedback/question/{id}', function ($id) {
                $user_feedback_question = App\UserFeedbackQuestion::find($id);
                return response()->json($user_feedback_question);
            });

            $router->get('/user/{id}', function ($id) {
                $user = App\User::find($id);
                return response()->json($user);
            });

            $router->get('/user/{id}/missions', function ($id) {
                $user = App\User::find($id);
                return response()->json($user->missions);
            });

            $router->delete('/user/{id}', function ($id) {
                App\User::destroy($id);
                return response("deleted");
            });
            $router->post('/user/{id}', function ($id) {
                $user = App\User::find($id);
                $user->role = Input::get("role", "");
                $user->internal_note = Input::get("internal_note", "");
                UserController::updateUser($user);
                return response("updated");
            });


            // Mission - Admins
            $router->post('/mission/{id}/receivedDraft', function ($id) {
                $mission = App\Mission::find($id);
                $mission->draft = date("Y-m-d");
                $mission->save();

                //Add new ReportSheets
                $start = new DateTime($mission->start);
                $end = new DateTime($mission->end);
                $reportSheetEnd = clone $start;
                $reportSheetEnd->modify('last day of this month');
                while ($reportSheetEnd < $end) {
                    ReportSheet::add($mission, $start, $reportSheetEnd);
                    $start->modify('first day of next month');
                    $reportSheetEnd->modify('last day of next month');
                }
                ReportSheet::add($mission, $start, $end);

                return response("updated");
            });

            // Specification (Pflichtenheft) - Admins
            $router->get('/specification', function () {
                return response()->json(DB::table('specifications')->select('*')->get());
            });
            $router->get('/specification/{id}', function ($id) {
                return response()->json(App\Specification::find($id));
            });
            $router->post('/specification/{id}', function ($id) {
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
            $router->put('/specification/{id}', function ($id) {

                if (!preg_match('/^[0-9\d_]*$/', $id)) {
                    return response()->json('Die ID enthält ungültige Zeichen!', 400);
                }

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

            // Mission - Admins
            $router->get('/missions/{year}', function ($year) {
                $data = App\Mission::join('users', 'users.id', '=', 'missions.user')
                    ->join('specifications', 'specifications.id', '=', 'missions.specification')
                    ->select('*', 'users.id AS userid')
                    ->whereNull('missions.deleted_at')
                    ->whereDate('end', '>=', $year . '-01-01')
                    ->whereDate('start', '<=', $year . '-12-31')
                    ->orderBy('start')
                    ->get();
                $intermediateResult = array();
                foreach ($data as $m) {
                    if (!isset($intermediateResult[$m->userid])) {
                        $intermediateResult[$m->userid] = array();
                    }
                    $intermediateResult[$m->userid][] = $m;
                }

                $result = array();
                foreach ($intermediateResult as $m) {
                    $result[] = $m;
                }

                return response()->json($result);
            });
            $router->delete('/mission/{id}', function ($id) {
                App\Mission::find($id)->delete();
                App\ReportSheet::deleteByMission($id);
                return response("deleted");
            });

            // Holiday Type - Admins
            $router->get('/holiday_type', function () {
                return response()->json(App\HolidayType::all());
            });
            $router->get('/holiday_type/{id}', function ($id) {
                return response()->json(App\HolidayType::find($id));
            });

            // Holiday - Admins
            $router->get('/holiday', function () {
                $start = new DateTime();
                $end = new DateTime();
                $start->modify('first day of january last year');
                $end->modify('last day of december next year');

                return response()->json(App\Holiday::orderBy('date_from', 'DESC')
                    ->whereDate('date_from', '>=', $start)
                    ->whereDate('date_from', '<=', $end)
                    ->get());
            });
            $router->post('/holiday/{id}', function ($id) {
                $holiday = App\Holiday::find($id);
                $holiday->date_from = Input::get("date_from");
                $holiday->date_to = Input::get("date_to");
                $holiday->holiday_type = Input::get("holiday_type");
                $holiday->description = Input::get("description");
                $holiday->save();
                return response("updated");
            });
            $router->put('/holiday', function () {
                $holiday = new App\Holiday();
                $holiday->date_from = Input::get("date_from");
                $holiday->date_to = Input::get("date_to");
                $holiday->holiday_type = Input::get("holiday_type");
                $holiday->description = Input::get("description");
                $holiday->save();
                return response("inserted");
            });
            $router->delete('/holiday/{id}', function ($id) {
                $holiday = App\Holiday::find($id);
                $holiday->delete();
                return response("deleted");
            });

            // Role - Admins
            $router->get('/role', function () {
                return response()->json(App\Role::all());
            });
            $router->get('/role/{id}', function ($id) {
                return response()->json(App\Role::find($id));
            });

            // Log - Admins
            $router->get('/log', function () {
                return response()->json(App\Log::all());
            });
            $router->get('/log/{id}', function ($id) {
                return response()->json(App\Log::find($id));
            });

            // Reportsheet - Admins
            $router->get('/reportsheet', function () {
                return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                    ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'state', 'report_sheets.id AS id')
                    ->orderBy('start')
                    ->orderBy('end')
                    ->orderBy('zdp')
                    ->get());
            });
            $router->get('/reportsheet/pending', function () {
                return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                    ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'state', 'report_sheets.id AS id')
                    ->where('state', '!=', '3')
                    ->orderBy('start')
                    ->orderBy('end')
                    ->orderBy('zdp')
                    ->get());
            });
            $router->get('/reportsheet/current', function () {
                return response()->json(App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                    ->select('zdp', 'users.id AS userid', 'first_name', 'last_name', 'start', 'end', 'state', 'report_sheets.id AS id')
                    ->whereDate('start', '>=', date('Y-m-d', strtotime('first day of last month')))
                    ->whereDate('end', '<', date('Y-m-d', strtotime('first day of next month')))
                    ->where('state', '=', '0')
                    ->orderBy('start')
                    ->orderBy('end')
                    ->orderBy('zdp')
                    ->get());
            });
            $router->get('/reportsheet/payments', ['uses' => 'PaymentController@getPaymentOverview']);

            $router->post('/reportsheet/payments/execute', ['uses' => 'PaymentController@getIsoPaymentXml']);

            $router->get('/reportsheet/payments/{id}', ['uses' => 'PaymentController@getArchivedPayment']);

            $router->get('/reportsheet/payments/xml/{id}', ['uses' => 'PaymentController@getArchivedXml']);

            $router->get('/reportsheet/{id}', function ($id) {
                return response()->json(App\ReportSheet::getSpesen($id));
            });
            $router->post('/reportsheet/{id}', function ($id) {
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
                $sheet->clothes = Input::get("meldeblaetter_kleider", "") * 100;
                $sheet->clothes_comment = Input::get("meldeblaetter_kleider_comment", "");
                $sheet->driving_charges = Input::get("meldeblaetter_fahrspesen", "") * 100;
                $sheet->driving_charges_comment = Input::get("meldeblaetter_fahrspesen_comment", "");
                $sheet->extraordinarily = Input::get("meldeblaetter_ausserordentlich", "") * 100;
                $sheet->extraordinarily_comment = Input::get("meldeblaetter_ausserordentlich_comment", "");
                $sheet->bank_account_number = Input::get("bank_account_number", "");
                $sheet->document_number = Input::get("document_number", "");
                $sheet->state = Input::get("state", "");
                $sheet->start = Input::get("meldeblaetter_start", "");
                $sheet->end = Input::get("meldeblaetter_end", "");
                $sheet->ignore_first_last_day = !!Input::get("ignore_first_last_day", false);
                $sheet->save();
                return response("updated");
            });
            $router->put('/reportsheet/{id}/state', function ($id) {
                $sheet = App\ReportSheet::find($id);
                $state = Input::get("state", null);
                if ($state === null) {
                    throw new Exception("Missing 'state'");
                }
                $sheet->state = $state;
                $sheet->save();
                return response("updated");
            });
            $router->get('/reportsheet/user/{id}', function ($id) {
                $reportSheets = App\ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                    ->select('report_sheets.id AS id', 'start', 'end', 'state')
                    ->where('users.id', '=', $id)
                    ->orderBy('start')
                    ->orderBy('end')
                    ->orderBy('zdp')
                    ->get();
                // Add calculated column days
                foreach ($reportSheets as $reportSheet) {
                    $reportSheet['days'] = App\ReportSheet::getDiensttageCount($reportSheet->start, $reportSheet->end);
                }
                return response()->json($reportSheets);
            });

            $router->delete('/reportsheet/{id}', function ($id) {
                App\ReportSheet::destroy($id);
                return response("deleted");
            });

            $router->put('/reportsheet', function () {
                $userId = Input::get("user", "");
                if ($userId == null) {
                    $userId = $user = Auth::id();
                }

                $mission = App\Mission::find(Input::get("mission", ""));

                $report = new App\ReportSheet();
                $report->user = $userId;
                $report->mission = $mission->id;
                $report->start = $mission->start;
                $report->end = $mission->end;
                $report->bank_account_number = CompanyInfo::DEFAULT_ACCOUNT_NUMBER_REPORT_SHEETS;
                $report->save();

                return response("inserted");
            });

            // PDF - Admins
            $router->get('/pdf/phoneList', ['uses' => 'PDFController@getPhoneList']);

            $router->get('/pdf/statistik', ['uses' => 'PDFController@getSpesenStatistik']);
        });

        $router->get('/', function () use ($router) {
            return $router->app->version();
        });
    });
});
