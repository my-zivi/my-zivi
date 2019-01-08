<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\Specification::class, function (Generator $faker) {
    return [
        'accommodation' => $faker->numberBetween(500, 1200),
        'active' => true,
        'firstday_breakfast_expenses' => $faker->numberBetween(0, 9),
        'firstday_dinner_expenses' => $faker->numberBetween(0, 10),
        'firstday_lunch_expenses' => $faker->numberBetween(0, 10),
        'id' => strval($faker->unique()->numberBetween(10000, 50000)),
        'lastday_breakfast_expenses' => $faker->numberBetween(0, 9),
        'lastday_dinner_expenses' => $faker->numberBetween(0, 10),
        'lastday_lunch_expenses' => $faker->numberBetween(0, 10),
        'name' => $faker->word,
        'pocket' => $faker->numberBetween(400, 500),
        'short_name' => $faker->word,
        'sparetime_breakfast_expenses' => $faker->numberBetween(0, 9),
        'sparetime_dinner_expenses' => $faker->numberBetween(0, 10),
        'sparetime_lunch_expenses' => $faker->numberBetween(0, 10),
        'working_breakfast_expenses' => $faker->numberBetween(0, 9),
        'working_clothes_expense' => $faker->numberBetween(0, 5),
        'working_clothes_payment' => $faker->numberBetween(0, 250),
        'working_dinner_expenses' => $faker->numberBetween(0, 10),
        'working_lunch_expenses' => $faker->numberBetween(0, 10),
    ];
});
