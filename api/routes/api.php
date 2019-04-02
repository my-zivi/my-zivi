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
        $router->group(['prefix' => 'missions'], function () use ($router) {
            $router->get('/{id}/draft', ['uses' => 'PDFController@getAufgebot']);
            $router->put('/{id}', ['uses' => 'MissionController@put']);
            $router->post('/', ['uses' => 'MissionController@post']);
        });

        $router->group(['prefix' => 'mission_days'], function () use ($router) {
            $router->get('/eligible_days', ['uses' => 'MissionDayController@eligibleDays']);
            $router->get('/possible_end_date', ['uses' => 'MissionDayController@possibleEndDate']);
        });

        $router->group(['prefix' => 'regional_centers'], function () use ($router) {
            $router->get('/', ['uses' => 'RegionalCenterController@index']);
        });

        $router->group(['prefix' => 'report_sheets'], function () use ($router) {
            $router->get('/{id}/download', ['uses' => 'PDFController@getZiviReportSheet']);
            $router->get('/', ['uses' => 'ReportSheetController@index']);
        });

        $router->group(['prefix' => 'specifications'], function () use ($router) {
            $router->get('/', ['uses' => 'SpecificationController@index']);
        });

        $router->group(['prefix' => 'users'], function () use ($router) {
            $router->post('/change_password', ['uses' => 'UserController@changePassword']);
            $router->get('/{id}', ['uses' => 'UserController@get']);
            $router->put('/{id}', ['uses' => 'UserController@put']);
        });

        $router->group(['prefix' => 'user_feedbacks'], function () use ($router) {
            $router->post('/', ['uses' => 'FeedbackController@postFeedback']);
        });

        $router->group(['prefix' => 'user_feedback_questions'], function () use ($router) {
            $router->get('/', ['uses' => 'FeedbackController@index']);
        });

        // Admins only
        $router->group(['middleware' => 'role'], function ($router) {
            /** @var Router $router */
            // Root - Admins
            $router->get('/api', ['uses' => 'APIController@getIndex']);

            // User - Admins
            $router->group(['prefix' => 'documents'], function () use ($router) {
                $router->get('/phone_list', ['uses' => 'PDFController@getPhoneList']);
                $router->get('/expenses_overview', ['uses' => 'PDFController@getSpesenStatistik']);
            });

            $router->group(['prefix' => 'holidays'], function () use ($router) {
                $router->delete('/{id}', ['uses' => 'HolidayController@delete']);
                $router->get('/', ['uses' => 'HolidayController@index']);
                $router->post('/', ['uses' => 'HolidayController@post']);
                $router->put('/{id}', ['uses' => 'HolidayController@put']);
            });

            $router->group(['prefix' => 'missions'], function () use ($router) {
                $router->delete('/{id}', ['uses' => 'MissionController@delete']);
                $router->get('/{year}', ['uses' => 'MissionController@indexByYear']);
                $router->put('/{id}/received_draft', ['uses' => 'MissionController@receivedDraft']);
            });

            $router->group(['prefix' => 'payments'], function () use ($router) {
                $router->get('/{id}/xml', ['uses' => 'PaymentController@getArchivedXml']);
                $router->get('/{id}', ['uses' => 'PaymentController@get']);
                $router->post('/execute', ['uses' => 'PaymentController@getIsoPaymentXml']);
                $router->get('/', ['uses' => 'PaymentController@index']);
            });

            $router->group(['prefix' => 'report_sheets'], function () use ($router) {
                $router->get('/{id}', ['uses' => 'ReportSheetController@get']);
                $router->put('/{id}', ['uses' => 'ReportSheetController@put']);
                $router->put('/{id}/state', ['uses' => 'ReportSheetController@putState']);
                $router->delete('/{id}', ['uses' => 'ReportSheetController@delete']);
            });

            $router->group(['prefix' => 'specifications'], function () use ($router) {
                $router->post('/', ['uses' => 'SpecificationController@post']);
                $router->put('/{id}', ['uses' => 'SpecificationController@put']);
                $router->delete('/{id}', ['uses' => 'SpecificationController@delete']);
            });

            $router->group(['prefix' => 'users'], function () use ($router) {
                $router->delete('/{id}', ['uses' => 'UserController@delete']);
                $router->get('/', ['uses' => 'UserController@index']);
            });

            $router->group(['prefix' => 'user_feedbacks'], function () use ($router) {
                $router->get('/{id}', ['uses' => 'FeedbackController@getFeedback']);
                $router->get('/', ['uses' => 'FeedbackController@getFeedbacks']);
            });
        });
    });
});
