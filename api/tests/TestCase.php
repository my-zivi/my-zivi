<?php

use Tymon\JWTAuth\JWTAuth;

class TestCase extends Laravel\Lumen\Testing\TestCase
{

    /**
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

    // taken from
    public function signIn($data=['email'=>'johndoe@example.com', 'password'=>'johndoe'])
    {
        $this->post('api/auth/login', $data);
        $content = json_decode($this->response->getContent());

        $this->assertObjectHasAttribute('token', $content->data, 'Token does not exists');
        $this->token = $content->data->token;

        return $this;
    }

    protected function headers($user = null)
    {
        $headers = ['Accept' => 'application/json'];

        if (!is_null($user)) {
            $token = JWTAuth::fromUser($user);
            JWTAuth::setToken($token);
            $headers['Authorization'] = 'Bearer '.$token;
        }

        return $headers;
    }
}
