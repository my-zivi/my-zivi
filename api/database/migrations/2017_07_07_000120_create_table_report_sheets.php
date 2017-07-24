<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTableReportsheets extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('report_sheets', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();
            $table->softDeletes();
            $table->date('start');
            $table->date('end');
            $table->integer('user')->unsigned();
            $table->foreign('user')->references('id')->on('users');
            $table->boolean('done');
            $table->integer('work');
            $table->string('work_comment');
            $table->integer('national_holiday');
            $table->integer('company_holiday');
            $table->string('company_holiday_comment');
            $table->integer('workfree');
            $table->string('workfree_comment');
            $table->integer('additional_workfree');
            $table->string('additional_workfree_comment');
            $table->integer('ill');
            $table->string('ill_comment');
            $table->integer('holiday');
            $table->string('holiday_comment');
            $table->integer('vacation');
            $table->string('vacation_comment');
            $table->bigInteger('driving_charges');
            $table->string('driving_charges_comment');
            $table->bigInteger('extraordinarily');
            $table->string('extraordinarily_comment');
            $table->bigInteger('clothes');
            $table->string('clothes_comment');
            $table->integer('mission')->unsigned();
            $table->foreign('mission')->references('id')->on('missions');
            $table->string('bank_account_number');
            $table->integer('document_number'); // "Beleg Nummer"
            $table->date('booked_date');
            $table->date('paid_date');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('report_sheets');
    }
}
