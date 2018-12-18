<?php

namespace App\Http\Controllers\API;

use App\CompanyInfo;
use App\Http\Controllers\Controller;
use App\Mail\NewsletterSignup;
use App\User;
use Firebase\JWT\JWT;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    const USER_ROLE_ZIVI = 2;
    const PW_MIN_LENGTH = 7;
    const PW_LENGTH_TEXT = 'Das Passwort muss aus mindestens '.AuthController::PW_MIN_LENGTH.' Zeichen bestehen!';

    // SOURCE: http://zeeshanu.info/blog/2017/09/05/jwt-authentication-for-Lumen-5.4/

    /**
     * Create a new token.
     *
     * @param  User $user
     * @return string
     */
    protected function jwt(User $user)
    {
        $payload = [
            'iss' => "izivi-api", // Issuer of the token
            'sub' => $user->id, // Subject of the token
            'isAdmin' => $user->role == 1,
            'iat' => time(), // Time when JWT was issued.
            'exp' => time() + 60*60*24, // Expiration time,
        ];

        // As you can see we are passing `JWT_SECRET` as the second parameter that will
        // be used to decode the token in the future.
        return JWT::encode($payload, env('JWT_SECRET'));
    }

    /**
     * Handle a login request to the application.
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function postLogin(Request $request)
    {
        try {
            $this->validate($request, [
                'email' => 'required|email|max:255',
                'password' => 'required',
            ]);
        } catch (ValidationException $e) {
            return $e->getResponse();
        }

        // Find the user by email
        $user = User::where('email', $request->input('email'))->first();

        if (!$user) {
            // You wil probably have some sort of helpers or whatever
            // to make sure that you have the same response format for
            // differents kind of responses. But let's return the
            // below response for now.
            return response()->json([
                'error' => 'Email does not exist.'
            ], 401);
        }

        // Verify the password and generate the token
        if (Hash::check($request->input('password'), $user->password)) {
            return new JsonResponse([
                'message' => 'token_generated',
                'data' => [
                    'token' => $this->jwt($user),
                ]
            ]);
        }

        // Bad Request response
        return response()->json([
            'error' => 'Email or password is wrong.'
        ], 401);
    }

    public function postRegister(Request $request)
    {
        // TODO rework this method to use the default laravel request validations
        $errors = array();

        if (empty($request->input("firstname"))) {
            $errors['Vorname'] = 'Vorname darf nicht leer sein!';
        }
        if (empty($request->input("lastname"))) {
            $errors['Nachname'] = 'Nachname darf nicht leer sein!';
        }
        if (empty($request->input("email"))) {
            $errors['E-Mail'] = 'E-Mail darf nicht leer sein!';
        }
        if (empty($request->input("zdp"))) {
            $errors['ZDP'] = 'ZDP darf nicht leer sein!';
        }
        if (empty($request->input("password"))) {
            $errors['Passwort1'] = 'Passwort darf nicht leer sein!';
        }
        if ($request->input("password")!=$request->input("password_confirm")) {
            $errors['Passwort2'] = 'Passwörter stimmen nicht überein!';
        }
        if (strlen($request->input("password")) < AuthController::PW_MIN_LENGTH) {
            $errors['Passwort'] = AuthController::PW_LENGTH_TEXT;
        }
        if ($request->input("community_pw") != "swoswo") {
            $errors['Community Passwort'] = 'Community PW stimmt nicht!';
        }
        if (User::where('email', '=', $request->input("email"))->first()!=null) {
            $errors['E-Mail'] = 'Ein Nutzer für diese E-Mail Adresse existiert bereits!';
        }

        if (count($errors)>0) {
            return new JsonResponse($errors, Response::HTTP_NOT_ACCEPTABLE);
        }

        $user = new User();

        $user->first_name = $request->input("firstname");
        $user->last_name = $request->input("lastname");
        $user->email = $request->input("email");
        $user->zdp = $request->input("zdp");
        $user->password = password_hash($request->input("password"), PASSWORD_BCRYPT);
        $user->regional_center = 1;
        $user->role = AuthController::USER_ROLE_ZIVI;
        $user->save();

        if ($request->input("newsletter", false)) {
            Mail::to(CompanyInfo::NEWSLETTER_INFO_MAIL)->send(new NewsletterSignup($user));
        }

        return $this->postLogin($request);
    }

    public function patchRefresh()
    {
        $user = Auth::user();

        return new JsonResponse([
            'message' => 'token_refreshed',
            'data' => [
                'token' => $this->jwt($user)
            ]
        ]);
    }
}
