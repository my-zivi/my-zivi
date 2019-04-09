<?php

namespace App\Http\Controllers\API;

use App;
use App\Http\Controllers\Controller;
use App\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Input;

class UserController extends Controller
{
    public function changePassword(Request $request)
    {
        $errors = [];

        $user = Auth::user();

        $pw_old = $request->input("old_password");
        $pw_new = $request->input("new_password");
        $pw_new_2 = $request->input("new_password_2");
        $errors = [];

        if (empty($pw_old)) {
            array_push($errors, 'Altes Passwort darf nicht leer sein!');
        }

        if (!Hash::check($request->input('old_password'), $user->password)) {
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

    public function delete($id)
    {
        User::findOrFail($id)->delete();
        return 'Entity deleted';
    }

    public function get($id)
    {
        $user = User::with(['missions', 'reportSheets'])->find($id);

        if (Auth::user()->isAdmin() || $user->id == Auth::id()) {
            if (!Auth::user()->isAdmin()) {
                unset($user->internal_note);
            }

            return $user;
        } else {
            return $this->respondWithUnauthorized();
        }
    }

    public function index()
    {
        return User::with(['role', 'missions'])->get();
    }

    public function put($id, Request $request)
    {
        if (Auth::user()->isAdmin()) {
            $validatedData = $this->validate($request, array_merge($this->basicUserValidationRules(), $this->extendedUserValidationRules()));
        } elseif (Auth::id() == $id) {
            $validatedData = $this->validate($request, $this->basicUserValidationRules());
        } else {
            return $this->respondWithUnauthorized();
        }

        User::find($id)->update($validatedData);
        return self::get($id);
    }

    private function basicUserValidationRules()
    {
        // SOURCE FOR BIC REGEX: https://www.regextester.com/98275
        return [
            'address'            => 'required|string',
            'bank_bic'           => [
                'required',
                'string',
                'regex:/([a-zA-Z]{4})([a-zA-Z]{2})(([2-9a-zA-Z]{1})([0-9a-np-zA-NP-Z]{1}))((([0-9a-wy-zA-WY-Z]{1})([0-9a-zA-Z]{2}))|([xX]{3})|)/',
            ],
            'bank_iban'          => 'required|string|regex:/^CH\d{2,2}\s{0,1}(\w{4,4}\s{0,1}){4,7}\w{0,2}$/',
            'birthday'           => 'required|date',
            'chainsaw_workshop'  => 'required|boolean',
            'city'               => 'required|string',
            'driving_licence_b'  => 'required|boolean',
            'driving_licence_be' => 'required|boolean',
            'first_name'         => 'required|string',
            'health_insurance'   => 'required|string',
            'hometown'           => 'required|string',
            'last_name'          => 'required|string',
            'phone'              => 'required|string',
            'regional_center_id' => 'required|integer',
            'work_experience'    => 'required|string',
            'zip'                => 'required|integer',
        ];
    }

    private function extendedUserValidationRules()
    {
        return [
            'internal_note' => 'string',
            'role_id'       => 'required|integer',
        ];
    }
}
