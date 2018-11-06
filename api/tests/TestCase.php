<?php

use App\User;
use Tymon\JWTAuth\Facades\JWTAuth;

class TestCase extends Laravel\Lumen\Testing\TestCase
{

    /**
     *
     * @var Faker\Generator
     */
    protected $faker;


    public function setUp()
    {
        $this->faker = Faker\Factory::create();
        parent::setUp();
    }
    /**
     * Creates the application.
     *
     * @return \Laravel\Lumen\Application
     */
    public function createApplication()
    {
        return require __DIR__.'/../bootstrap/app.php';
    }

    /**
     * Visit the given URI with an authenticated JSON request.
     *
     * @param string      $method
     * @param string      $uri
     * @param User|string $user
     * @param array       $data
     * @param array       $headers
     *
     * @return TestCase
     */
    public function authJson($method, $uri, $user, array $data = [], array $headers = [])
    {
        if ($user === 'zivi') {
            $user = factory(\App\User::class)->create();
        } elseif ($user === 'admin') {
            $user = User::where('email', '=', 'office@stiftungswo.ch')->first();
            if (is_null($user)) {
                $user = factory(\App\User::class, 'admin')->create();
            }
        }
        return $this->json($method, $uri, $data, array_merge($headers, [
                'Authorization' => 'Bearer ' . JWTAuth::fromUser($user),
            ]));
    }

    /**
     * @return array
     */
    public function responseToArray()
    {
        return json_decode($this->response->getContent(), true);
    }
}
