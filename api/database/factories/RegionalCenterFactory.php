<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\RegionalCenter::class, function (Generator $faker) {
    return [
        'address' => $faker->address,
        'name' => $faker->word,
        'short_name' => $faker->word
    ];
});
