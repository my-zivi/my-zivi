<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\ReportSheet::class, function (Generator $faker) {
    return [
        'additional_workfree' => $faker->numberBetween(0, 5),
        'additional_workfree_comment' => $faker->sentence(),
        'bank_account_number' => '4470 (200)',
        'clothes' => $faker->numberBetween(0, 250),
        'clothes_comment' => $faker->sentence(),
        'driving_charges' => $faker->numberBetween(100, 400),
        'driving_charges_comment' => $faker->sentence(),
        'extraordinarily' => $faker->numberBetween(0, 150),
        'extraordinarily_comment' => $faker->sentence(),
        'end' => $faker->dateTimeBetween('-60 days', '+0 days')->format('Y-m-d'),
        'holiday' => $faker->numberBetween(0, 2),
        'holiday_comment' => $faker->sentence(),
        'ignore_first_last_day' => $faker->boolean,
        'ill' => $faker->numberBetween(0, 5),
        'ill_comment' => $faker->sentence(),
        'mission' => function () {
            return factory(App\Mission::class)->create()->id;
        },
        'start' => $faker->dateTimeBetween('-180 days', '-90 days')->format('Y-m-d'),
        'state' => 3,
        'user' => function () {
            return factory(App\User::class)->create()->id;
        },
        'vacation' => $faker->numberBetween(0, 2),
        'vacation_comment' => $faker->sentence(),
        'work' => $faker->numberBetween(5, 25),
        'work_comment' => $faker->sentence(),
        'workfree' => $faker->numberBetween(0, 5),
        'workfree_comment' => $faker->sentence(),
    ];
});
