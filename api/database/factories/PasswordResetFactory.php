<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\PasswordReset::class, function (Generator $faker) {
    return [
        'email' => $faker->email,
        'token' => $faker->uuid
    ];
});
