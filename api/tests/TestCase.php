<?php

use App\User;

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

    public function asAdmin()
    {
        $user = factory(User::class)->create([
            'role' => 1
        ]);
        return $this->actingAs($user);
    }

    /**
     * @param User|null $user
     * @return TestCase
     */
    public function asUser($user = null)
    {
        if (!$user) {
            $user = factory(User::class)->create([
                'role' => 2
            ]);
        }
        return $this->actingAs($user);
    }

    /**
     * @return array
     */
    public function responseToArray()
    {
        return json_decode($this->response->getContent(), true);
    }
}
