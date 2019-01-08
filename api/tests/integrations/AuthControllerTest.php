<?php

namespace tests\integrations;

use Firebase\JWT\JWT;
use Laravel\Lumen\Testing\DatabaseTransactions;
use TestCase;

class AuthControllerTest extends TestCase
{
    use DatabaseTransactions;

    /**
     * A basic test example.
     *
     * @return void
     */
    public function testLoginWithWrongValidation()
    {
        $this->json('post', 'api/auth/login', [
            'email' => $this->faker->email,
            'password' => 'asdasd'
        ])->assertResponseStatus(400);
    }

    public function testCorrectLogin()
    {
        $email = $this->faker->email;
        $password = str_random(8);

        factory(\App\User::class)->create([
            'email' => $email,
            'password' => app('hash')->make($password)
        ]);

        $this->json('post', 'api/auth/login', [
            'email' => $email,
            'password' => $password
        ])->assertResponseOk();
    }

    public function testInvalidParamsLogin()
    {
        $this->json('post', 'api/auth/login', [])->assertResponseStatus(422);
    }

    public function testInvalidEmailLogin()
    {
        $this->json('post', 'api/auth/login', [
            'email' => 'welcometo@jurassic.park',
            'password' => 'Welcome01'
        ])->assertResponseStatus(400);
    }

    public function testInvalidPasswordLogin()
    {
        $user = factory(\App\User::class)->create();

        $this->json('post', 'api/auth/login', [
            'email' => $user->email,
            'password' => 'Welcome01'
        ])->assertResponseStatus(400);
    }

    public function testRegister()
    {
        $formData = [
            'zdp' => '123456',
            'firstname' => 'Max',
            'lastname' => 'Mustermann',
            'email' => 'foo@example.com',
            'password' => 'test1234',
            'password_confirm' => 'test1234',
            'community_pw' => 'swoswo',
            'newsletter' => true
        ];

        $response = $this->json('post', 'api/auth/register', $formData);

        $response->seeJson([
            'message' => 'token_generated',
        ])->assertResponseOk();

        $this->json('post', 'api/auth/login', [
            'email' => $formData['email'],
            'password' => $formData['password'],
        ])->assertResponseOk();
    }

    public function testInvalidRegister()
    {
        $this->json('post', 'api/auth/register', [
            'password_confirm' => 'Welcome01'
        ])->assertResponseStatus(406);
        $response = $this->responseToArray();

        $this->assertContains('Vorname darf nicht leer sein!', $response);
        $this->assertContains('Nachname darf nicht leer sein!', $response);
        $this->assertContains('E-Mail darf nicht leer sein!', $response);
        $this->assertContains('ZDP darf nicht leer sein!', $response);
        $this->assertContains('Passwort darf nicht leer sein!', $response);
        $this->assertContains('Passwörter stimmen nicht überein!', $response);
        $this->assertContains('Das Passwort muss aus mindestens 7 Zeichen bestehen!', $response);
        $this->assertContains('Community PW stimmt nicht!', $response);
    }

    public function testRegisterWithSameEmail()
    {
        $userEmail = factory(\App\User::class)->create()->email;
        $this->json('post', 'api/auth/register', [
            'email' => $userEmail
        ])->assertResponseStatus(406);

        $this->assertContains('Ein Nutzer für diese E-Mail Adresse existiert bereits!', $this->responseToArray());
    }

    public function testTokenRefresh()
    {
        $response = $this->json('patch', 'api/auth/refresh');

        $response->assertResponseStatus(401);

        $response = $this->asUser()->json('patch', "api/auth/refresh");

        $response->seeJson([
            'message' => 'token_refreshed',
        ])->assertResponseOk();
    }

    public function testAlternateTokenParameter()
    {
        $user = factory(\App\User::class, 'user_with_admin')->create();
        $payload = [
            'iss' => "izivi-api", // Issuer of the token
            'sub' => $user->id, // Subject of the token
            'isAdmin' => $user->role == 1,
            'iat' => time(), // Time when JWT was issued.
            'exp' => time() + 60*60*24, // Expiration time,
        ];

        // As you can see we are passing `JWT_SECRET` as the second parameter that will
        // be used to decode the token in the future.
        $token = JWT::encode($payload, env('JWT_SECRET'));

        $this->json('get', 'api/api')->assertResponseStatus(401);
        $this->json('get', 'api/api?token=' . $token)->assertResponseOk();
    }
}
