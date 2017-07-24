<?php

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
}
