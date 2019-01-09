<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\PaymentEntry::class, function (Generator $faker) {
    return [
        'amount' => $faker->numberBetween(1000, 100000),
        'iban' => $faker->iban('CH'),
        'payment_id' => function () {
            return factory(\App\Payment::class)->create()->id;
        },
        'report_sheet_id' => function () {
            return factory(\App\ReportSheet::class)->create()->id;
        },
        'user_id' => function () {
            return factory(\App\User::class)->create()->id;
        }
    ];
});
