<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\UserFeedbackQuestion::class, function (Generator $faker) {
    return [
        'active' => $faker->boolean,
        'custom_info' => $faker->word,
        'new_page' => $faker->boolean,
        'required' => $faker->boolean,
        'question' => $faker->sentence,
        'pos' => $faker->numberBetween(1, 250),
        'type' => $faker->numberBetween(1, 6)
    ];
});

$factory->defineAs(App\UserFeedbackQuestion::class, 'single_question_type', function () use ($factory) {
    $question = $factory->raw(App\UserFeedbackQuestion::class);
    $question['type'] = 1;
    return $question;
});

$factory->defineAs(App\UserFeedbackQuestion::class, 'group_title_question_type', function (Generator $faker) use ($factory) {
    $question = $factory->raw(App\UserFeedbackQuestion::class);
    $question['opt1'] = $faker->word;
    $question['opt2'] = $faker->word;
    $question['type'] = 2;
    return $question;
});

$factory->defineAs(App\UserFeedbackQuestion::class, 'group_question_type', function () use ($factory) {
    $question = $factory->raw(App\UserFeedbackQuestion::class);
    $question['type'] = 3;
    return $question;
});

$factory->defineAs(App\UserFeedbackQuestion::class, 'text_question_type', function () use ($factory) {
    $question = $factory->raw(App\UserFeedbackQuestion::class);
    $question['type'] = 4;
    return $question;
});

$factory->defineAs(App\UserFeedbackQuestion::class, 'single_question_type_2', function () use ($factory) {
    $question = $factory->raw(App\UserFeedbackQuestion::class);
    $question['opt1'] = "ja";
    $question['opt2'] = "nein";
    $question['type'] = 5;
    return $question;
});

$factory->defineAs(App\UserFeedbackQuestion::class, 'single_question_type_6', function () use ($factory) {
    $question = $factory->raw(App\UserFeedbackQuestion::class);
    $question['custom_info'] = '"choices":[{"value":"1","text":"Kollegen"},{"value":"2","text":"eZivi"},{"value":"3","text":"Website SWO"},{"value":"4","text":"Thomas Winter"},{"value":"5","text":"Früherer Einsatz"},{"value":"6","text":"Anderes"}]';
    $question['type'] = 6;
    return $question;
});
