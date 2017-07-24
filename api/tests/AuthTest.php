<?php

use Laravel\Lumen\Testing\DatabaseMigrations;
use Laravel\Lumen\Testing\DatabaseTransactions;

class AuthTest extends TestCase
{
    use DatabaseMigrations;

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
}
