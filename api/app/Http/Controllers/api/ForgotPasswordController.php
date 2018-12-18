<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Mail\PasswordResetLink;
use App\PasswordReset;
use App\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Mail;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Input;

class ForgotPasswordController extends Controller
{

    public function sendResetLinkEmail(Request $request)
    {
        $this->validate($request, ['email' => 'required|email']);

        $email = $request->only('email')['email'];

        $errors = array();

        if (User::where('email', '=', $email)->first()==null) {
            $errors[] = "Für diese E-Mailadresse besteht kein Account.";
        } else {
            // We will send the password reset link to this user. Once we have attempted
            // to send the link, we will examine the response then see the message we
            // need to show to the user. Finally, we'll send out a proper response.
            $response = $this->sendResetLink($email);

            if (!$response) {
                $errors[] = "Es gab einen Fehler beim Verschicken der E-Mail. Bitte versuchen Sie es später erneut.";
            }
        }

        if (count($errors)>0) {
            return new JsonResponse($errors, Response::HTTP_NOT_ACCEPTABLE);
        } else {
            return response("sent");
        }
    }

    private function sendResetLink($email)
    {
        $resetPW = new PasswordReset();
        $resetPW->email = $email;
        $resetPW->token = bin2hex(openssl_random_pseudo_bytes(16));
        $resetPW->save();

        Mail::to($email)->send(new PasswordResetLink($resetPW->token));

        if (count(Mail::failures()) > 0) {
            return false;
        } else {
            return true;
        }
    }

    public function resetPassword(Request $request)
    {
        $errors = array();

        $password = Input::get("new_password");

        if ($password!=Input::get("new_password_2")) {
            $errors[] = "Passwörter stimmen nicht überein!";
        }

        $token = PasswordReset::where('token', '=', Input::get("code"))
            //->where('created_at', '>=', 'DATE_SUB(NOW(), INTERVAL 1 HOUR)')
            ->first();
        if ($token==null) {
            $errors[] = "Ungültiges Token";
        }

        if (count($errors)>0) {
            return new JsonResponse($errors, Response::HTTP_NOT_ACCEPTABLE);
        } else {
            $user = User::where('email', '=', $token->email)->first();
            $user->password = password_hash($password, PASSWORD_BCRYPT);
            $user->save();
            DB::delete("DELETE FROM password_resets WHERE token=?", [$token->token]);
            return response("success");
        }
    }
}
