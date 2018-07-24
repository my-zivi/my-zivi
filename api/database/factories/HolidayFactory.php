<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\Holiday::class, function (Generator $faker) {
    return [
        'date_from' => $faker->dateTimeBetween('+0 days', '+2 years'),
        'date_to' => $faker->dateTimeBetween('+0 days', '+2 years'),
        'holiday_type' => $faker->numberBetween(1, 2),
        'description' => $faker->sentence
    ];
});
