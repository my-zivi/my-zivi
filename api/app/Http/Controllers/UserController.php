<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Routing\Controller;
//use Laravel\Lumen\Routing\Controller as BaseController;
use App;
use App\User;
use App\Http\Controllers\Auth\AuthController;
use App\Mission;
use App\Specification;
use Illuminate\Support\Facades\Input;
use Symfony\Component\Console\Output\ConsoleOutput;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;

class UserController extends Controller
{
    /**
     * Get authenticated user.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getZivis()
    {

        //$zivis = DB::table('users')->where('zdp', '>', 0)->get();
        $zivis = DB::table('users')
            ->leftJoin('missions', 'users.id', '=', 'missions.user')
            ->groupBy('users.id')
            ->join('roles', 'roles.id', '=', 'users.role')
            ->whereNull('users.deleted_at')
            ->select('users.id', 'users.zdp', 'users.first_name', 'users.last_name', 'users.work_experience', 'roles.name AS role', 'roles.id AS role_id')
            ->selectRaw('max(missions.start) AS start')
            ->selectRaw('max(missions.end) AS end')
            ->selectRaw('max(missions.long_mission) AS long_mission')
            ->orderBy('start', 'DESC')
            ->orderBy('end', 'DESC')
            ->orderBy('users.last_name')
            ->get();
        /*
        $zivis = DB::table('missions')->get();
        $zivis = DB::table('specifications')->get();
        */

        return new JsonResponse($zivis);
    }

    public function changePassword(Request $request)
    {

        /*$output = new ConsoleOutput();
        $output->writeln("some log to console");*/

        $errors = array();

        $user = JWTAuth::parseToken()->authenticate();

        $pw_old = $request->input("old_password");
        $pw_new = $request->input("new_password");
        $pw_new_2 = $request->input("new_password_2");
        $errors = [];

        if (empty($pw_old)) {
            array_push($errors, 'Altes Passwort darf nicht leer sein!');
        }

        if (!$this->isPasswordCorrect($user['email'], $pw_old)) {
            array_push($errors, 'Altes Passwort stimmt nicht!');
        }

        if ($pw_new != $pw_new_2) {
            array_push($errors, 'Die neuen Passwörter stimmen nicht überein!');
        }

        if (strlen($pw_new) < AuthController::PW_MIN_LENGTH) {
            array_push($errors, AuthController::PW_LENGTH_TEXT);
        }

        if (count($errors)>0) {
            return new JsonResponse($errors, Response::HTTP_NOT_ACCEPTABLE);
        }

        $user->password = password_hash($pw_new, PASSWORD_BCRYPT);
        $user->save();

        return new JsonResponse("Ihr Passwort wurde angepasst.");
    }

    private function isPasswordCorrect($email, $password)
    {

        $credentials = array (
            'email' => $email,
            'password' => $password,
        );

        return (JWTAuth::attempt(
            $credentials,
            ['isAdmin' => false]
        ));
    }

    public static function updateUser(User $user)
    {
        $user->first_name = Input::get("first_name", "");
        $user->last_name = Input::get("last_name", "");
        $user->address = Input::get("address", "");
        $user->city = Input::get("city", "");
        $user->zip = Input::get("zip", "");
        $user->hometown = Input::get("hometown", "");
        $user->birthday = Input::get("birthday", "");
        $user->phone_mobile = Input::get("phone_mobile", "");
        $user->phone_private = Input::get("phone_private", "");
        $user->phone_business = Input::get("phone_business", "");
        $user->bank_iban = Input::get("bank_iban", "");
        $user->bank_bic = Input::get("bank_bic", "");
        $user->work_experience = Input::get("work_experience", "");
        $user->driving_licence = Input::get("driving_licence", 0);
        $user->ga_travelcard = Input::get("ga_travelcard", 0);
        $user->half_fare_travelcard = Input::get("half_fare_travelcard", 0);
        $user->other_fare_network = Input::get("other_fare_network", "");
        $user->regional_center = Input::get("regional_center", "");
        $user->health_insurance = Input::get("health_insurance", "");
        $user->save();
    }
}
