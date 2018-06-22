<?php

use Laravel\Lumen\Testing\DatabaseTransactions;

class AuthTest extends TestCase
{
    use DatabaseTransactions;

    /**
     * A basic test example.
     *
     * @return void
     */
    public function testLoginWithWrongValidation()
    {
        $this->artisan('db:seed');

        $this->json('post', 'api/auth/login', [
            'email'     => $this->faker->email,
            'password'  => 'asdasd'
        ])->seeJson([
            'message'   => 'invalid_credentials'
        ])->assertResponseStatus(401);
    }

    /**
     *
     */
    public function testCorrectLogin()
    {
        $email = $this->faker->email;
        $password = str_random(8);

        factory(\App\User::class)->create([
            'email' => $email,
            'password' => app('hash')->make($password)
        ]);

        $this->json('post', 'api/auth/login', [
            'email'     => $email,
            'password'  => $password
        ])
            ->assertResponseOk();
    }

    public function testRegister()
    {
        $formData = [
            'zdp'              => '123456',
            'firstname'        => 'Max',
            'lastname'         => 'Mustermann',
            'email'            => 'foo@example.com',
            'password'         => 'test1234',
            'password_confirm' => 'test1234',
            'community_pw'     => 'swoswo',
        ];

        $response = $this->json('post', 'api/auth/register', $formData);

        $response->seeJson([
            'message' => 'token_generated',
        ])->assertResponseOk();

        $this->json('post', 'api/auth/login', [
            'email'    => $formData['email'],
            'password' => $formData['password'],
        ])->assertResponseOk();
    }

    public function testTokenRefreshFails()
    {
        $response = $this->json('patch', 'api/auth/refresh');

        $response->assertResponseStatus(401);

        // todo: test successfull refresh
    }
}
