<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTableUserFeedbackQuestions extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('user_feedback_questions', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();
            $table->softDeletes();
            $table->string('question');
            $table->string('json');
            $table->boolean('new_page');
            $table->integer('type');
            $table->string('opt1')->nullable();
            $table->string('opt2')->nullable();
            $table->string('opt3')->nullable();
            $table->integer('pos');
            $table->integer('active');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('user_feedback_questions');
    }
}
