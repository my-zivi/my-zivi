<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\Payment::class, function (Generator $faker) {
    return [
//        'amount' => $faker->numberBetween(800000, 1500000),
//        'xml' => $faker->sentence,
    ];
});
