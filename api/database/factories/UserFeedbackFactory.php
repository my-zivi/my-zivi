<?php

use Faker\Generator;
use Illuminate\Database\Eloquent\Factory;

/** @var Factory $factory */
$factory->define(App\UserFeedback::class, function (Generator $faker) {
    return [
        'answer' => $faker->sentence,
        'feedbackId' => \Faker\Provider\Uuid::uuid(),
        'questionId' => factory(\App\UserFeedbackQuestion::class, 'text_question_type')->create()->id,
        'user' => factory(\App\User::class)->create()->id,
        'year' => $faker->dateTimeBetween('-365 days', '-90 days')
    ];
});
