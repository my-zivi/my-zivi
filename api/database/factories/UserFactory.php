<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/*
|--------------------------------------------------------------------------
| Model Factories
|--------------------------------------------------------------------------
|
| Here you may define all of your model factories. Model factories give
| you a convenient way to create models for testing and seeding your
| database. Just tell the factory how a default model should look.
|
*/

/** @var Factory $factory */

$factory->define(App\User::class, function (Generator $faker) {
    return [
        'address' => $faker->streetAddress,
        'bank_bic' => $faker->swiftBicNumber,
        'bank_iban' => $faker->iban('CH'),
        'birthday' => $faker->date(),
        'city' => $faker->city,
        'email' => $faker->email,
        'first_name' => $faker->name,
        'ga_travelcard' => $faker->boolean,
        'half_fare_travelcard' => $faker->boolean,
        'health_insurance' => $faker->company,
        'hometown' => $faker->city,
        'internal_note' => $faker->sentence,
        'last_name' => $faker->name,
        'password' => app('hash')->make($faker->password),
        'phone_business' => $faker->phoneNumber,
        'phone_mobile' => $faker->phoneNumber,
        'phone_private' => $faker->phoneNumber,
        'regional_center' => 2,
        'remember_token' => str_random(10),
        'role' => 2,
        'work_experience' => $faker->sentence(),
        'zdp' => $faker->randomNumber(6),
        'zip' => $faker->numberBetween(1000, 9999),
    ];
});

$factory->defineAs(App\User::class, 'user_with_admin', function () use ($factory) {
    $user = $factory->raw(App\User::class);
    $user['role'] = 1;
    return $user;
});

$factory->defineAs(App\User::class, 'admin', function () use ($factory) {
    $user = $factory->raw(App\User::class);
    $user['email'] ='office@stiftungswo.ch';
    $user['password'] = app('hash')->make('GutesPasswort');
    $user['role'] = 1;
    return $user;
});
