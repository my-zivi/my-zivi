<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\Mission::class, function (Generator $faker) {
    return [
        'draft' => $faker->dateTimeBetween('-360 days', '-270 days'),
        'end' => $faker->dateTimeBetween('-60 days', '+90 days'),
        'eligible_holiday' => $faker->numberBetween(0, 10),
        'feedback_done' => $faker->boolean(),
        'feedback_mail_sent' => $faker->boolean(),
        'first_time' => $faker->boolean(),
        'long_mission' => $faker->boolean(),
        'mission_type' => $faker->numberBetween(0, 2),
        'probation_period' => $faker->numberBetween(0, 10),
        'specification' => factory(App\Specification::class)->create()->id,
        'start' => $faker->dateTimeBetween('-180 days', '-90 days'),
        'user' => factory(App\User::class)->create()->id
    ];
});
