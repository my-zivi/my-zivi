<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\HolidayType::class, function (Generator $faker) {
    return [
        'name' => $faker->word
    ];
});
