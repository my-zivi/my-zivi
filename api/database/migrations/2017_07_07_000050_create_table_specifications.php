<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTableSpecifications extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('specifications', function (Blueprint $table) {
            $table->double('id');
            $table->string('name');
            $table->string('short_name');
            $table->string('working_clothes_payment')->nullable();
            $table->integer('working_clothes_expense');
            $table->integer('working_breakfast_expenses');
            $table->integer('working_lunch_expenses');
            $table->integer('working_dinner_expenses');
            $table->integer('sparetime_breakfast_expenses');
            $table->integer('sparetime_lunch_expenses');
            $table->integer('sparetime_dinner_expenses');
            $table->integer('firstday_breakfast_expenses');
            $table->integer('firstday_lunch_expenses');
            $table->integer('firstday_dinner_expenses');
            $table->integer('lastday_breakfast_expenses');
            $table->integer('lastday_lunch_expenses');
            $table->integer('lastday_dinner_expenses');
            $table->integer('working_time_model');
            $table->string('working_time_weekly');
            $table->integer('accommodation');
            $table->integer('pocket');
            $table->string('manual_file');
            $table->integer('active');
            $table->primary('id');
        });
    }

    
    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('specifications');
    }
}
