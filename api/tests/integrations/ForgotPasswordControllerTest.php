<?php

namespace Tests\Integrations;

use Laravel\Lumen\Testing\DatabaseTransactions;

class ForgotPasswordControllerTest extends \TestCase
{
    use DatabaseTransactions;

    public function testInvalidMailForReset()
    {
        $this->json('POST', 'api/auth/forgotPassword', [
            'email' => 'is@this.sparta'
        ])->assertResponseStatus(406);
        $this->assertContains('Für diese E-Mailadresse besteht kein Account.', $this->responseToArray());
    }

    public function testValidReset()
    {
        $userEmail = factory(\App\User::class)->create()->email;
        $this->json('POST', 'api/auth/forgotPassword', [
            'email' => $userEmail
        ])->assertResponseOk();
        $this->assertContains('sent', $this->response->getContent());
    }

    public function testResetPasswordWrongPasswords()
    {
        $this->json('POST', 'api/auth/resetPassword', [
            'new_password' => 'Welcome01',
            'new_password_2' => 'Welcome02'
        ])->assertResponseStatus(406);
        $this->assertContains('Passwörter stimmen nicht überein!', $this->responseToArray());
    }

    public function testResetPasswordInvalidToken()
    {
        $this->json('POST', 'api/auth/resetPassword', [
            'new_password' => 'Welcome01',
            'new_password_2' => 'Welcome01'
        ])->assertResponseStatus(406);
        $this->assertContains('Ungültiges Token', $this->responseToArray());
    }

    public function testValidPasswordReset()
    {
        $user = factory(\App\User::class)->create();
        $passwordReset = factory(\App\PasswordReset::class)->create([
            'email' => $user->email,
        ]);

        $this->json('POST', 'api/auth/resetPassword', [
            'new_password' => 'Welcome01',
            'new_password_2' => 'Welcome01',
            'code' => $passwordReset->token,
        ])->assertResponseOk();

        // check that the login works with the new password
        $this->json('post', 'api/auth/login', [
            'email' => $user->email,
            'password' => 'Welcome01'
        ])->assertResponseOk();
    }
}
