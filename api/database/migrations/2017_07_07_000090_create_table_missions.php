<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTableMissions extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('missions', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();
            $table->softDeletes();
            $table->integer('user')->unsigned();
            $table->foreign('user')->references('id')->on('users');
            $table->integer('specification')->unsigned();
            $table->foreign('specification')->references('id')->on('specifications');
            $table->date('start');
            $table->date('end');
            $table->date('draft'); // "Aufgebot"
            $table->integer('eligible_holiday');
            $table->integer('role')->unsigned();
            $table->foreign('role')->references('id')->on('roles');
            $table->integer('first_time');
            $table->boolean('long_mission');
            $table->integer('probation_period');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('missions');
    }
}
