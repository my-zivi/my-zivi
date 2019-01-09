<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\Holiday::class, function (Generator $faker) {
    return [
        'date_from' => $faker->dateTimeBetween('+0 days', '+2 years')->format('Y-m-d'),
        'date_to' => $faker->dateTimeBetween('+0 days', '+2 years')->format('Y-m-d'),
        'description' => $faker->sentence,
        'holiday_type_id' => function () {
            return factory(\App\HolidayType::class)->create()->id;
        },
    ];
});
