<?php

namespace App\Http\Controllers\Auth;

use App\CompanyInfo;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\App;
use Tymon\JWTAuth\Facades\JWTAuth;
use App\Http\Controllers\Controller;
use Tymon\JWTAuth\Exceptions\JWTException;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Input;

class AuthController extends Controller
{
    const USER_ROLE_ZIVI = 2;
    const PW_MIN_LENGTH = 7;
    const PW_LENGTH_TEXT = 'Das Passwort muss aus mindestens '.AuthController::PW_MIN_LENGTH.' Zeichen bestehen!';

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

        try {
            // Attempt to verify the credentials and create a token for the user
            $isAuthorized = false;
            $userPasswordInput = $this->getCredentials($request)['password'];
            $user = User::where('email', '=', Input::get("email", ""))->first();

            if ($userPasswordInput === '' or $user['password'] === '') {
                return $this->onUnauthorized();
            }

            // Simple MD5 fallback with double hashing (MD5 + bcrypt) - converts MD5 to bcrypt
            if (password_verify(md5($userPasswordInput), $user['password'])) {
                // double hashed: MD5 + bcrypt
                $isAuthorized = true;
                $token = JWTAuth::fromUser($user);
                $user->password = password_hash($userPasswordInput, PASSWORD_BCRYPT);
                $user->save();
            } else {
                // single hashed: bcrypt
                if ($token = JWTAuth::attempt($this->getCredentials($request))) {
                    $isAuthorized = true;
                }
            }

            if (!$isAuthorized) {
                return $this->onUnauthorized();
            }
        } catch (JWTException $e) {
            // Something went wrong whilst attempting to encode the token
            return $this->onJwtGenerationError();
        }

        // All good so return the token
        return $this->onAuthorized($token);
    }

    public function postRegister(Request $request)
    {
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
            $errors['Passwort'] = 'Passwort darf nicht leer sein!';
        }
        if ($request->input("password")!=$request->input("password_confirm")) {
            $errors['Passwort'] = 'Passwörter stimmen nicht überein!';
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

        //mail($user->email, "iZivi Registration", "Hallo und danke für die Registration");

        $user->save();

        if ($request->input("newsletter", false)) {
            $message = sprintf(
                "Ein Zivi hat sich im iZivi registriert und sich für den Newsletter angemeldet:\nVorname:%s\nNachname:%s\nZDP:%s\nEmail:%s",
                $user->first_name,
                $user->last_name,
                $user->zdp,
                $user->email
            );
            if (App::environment('production')) {
                mail(CompanyInfo::NEWSLETTER_INFO_MAIL, "iZivi Registration Newsletter anmeldung", utf8_decode($message));
            } else {
                \Log::debug("New signup: $message");
            }
        }

        return $this->postLogin($request);
    }

    /**
     * What response should be returned on invalid credentials.
     *
     * @return JsonResponse
     */
    protected function onUnauthorized()
    {
        return new JsonResponse([
            'message' => 'invalid_credentials'
        ], Response::HTTP_UNAUTHORIZED);
    }

    /**
     * What response should be returned on error while generate JWT.
     *
     * @return JsonResponse
     */
    protected function onJwtGenerationError()
    {
        return new JsonResponse([
            'message' => 'could_not_create_token'
        ], Response::HTTP_INTERNAL_SERVER_ERROR);
    }

    /**
     * What response should be returned on authorized.
     *
     * @return JsonResponse
     */
    protected function onAuthorized($token)
    {
        return new JsonResponse([
            'message' => 'token_generated',
            'data' => [
                'token' => $token,
            ]
        ]);
    }

    /**
     * Get the needed authorization credentials from the request.
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return array
     */
    protected function getCredentials(Request $request)
    {
        return $request->only('email', 'password');
    }

    /**
     * Invalidate a token.
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function deleteInvalidate()
    {
        $token = JWTAuth::parseToken();

        $token->invalidate();

        return new JsonResponse(['message' => 'token_invalidated']);
    }

    /**
     * Refresh a token.
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function patchRefresh()
    {
        $token = JWTAuth::parseToken();

        $newToken = $token->refresh();

        return new JsonResponse([
            'message' => 'token_refreshed',
            'data' => [
                'token' => $newToken
            ]
        ]);
    }
}
