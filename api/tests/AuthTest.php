<?php

use Laravel\Lumen\Testing\DatabaseTransactions;
use Tymon\JWTAuth\Facades\JWTAuth;

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

    public function testTokenRefresh()
    {
        $response = $this->json('patch', 'api/auth/refresh');

        $response->assertResponseStatus(401);

        $response = $this->authJson('patch', "api/auth/refresh", 'zivi');

        $response->seeJson([
            'message' => 'token_refreshed',
        ])->assertResponseOk();
    }

    public function testAlternateTokenParameter()
    {
        $user = factory(\App\User::class, 'admin')->create();
        $token = JWTAuth::fromUser($user);

        $this->json('get', 'api')->assertResponseStatus(401);
        $this->json('get', 'api?token=' . $token)->assertResponseOk();
    }

    public function testAdminAuth()
    {
        $response = $this->authJson('GET', "api/", 'zivi');
        $response->assertResponseStatus(401);
        $admin = factory(\App\User::class, 'admin')->create();

        $response = $this->authJson('GET', "api/", $admin);
        $response
            ->seeJson(['message' => 'Lumen (5.6.3) (Laravel Components 5.6.*)'])
            ->assertResponseOk();
    }
}
