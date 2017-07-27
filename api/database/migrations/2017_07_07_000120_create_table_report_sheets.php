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
            $table->integer('work')->nullable();
            $table->string('work_comment')->nullable();
            $table->integer('company_holiday_holiday')->nullable();
            $table->string('company_holiday_comment')->nullable();
            $table->integer('company_holiday_vacation')->nullable();
            $table->integer('workfree')->nullable();
            $table->string('workfree_comment')->nullable();
            $table->integer('additional_workfree');
            $table->string('additional_workfree_comment')->nullable();
            $table->integer('ill');
            $table->string('ill_comment')->nullable();
            $table->integer('holiday');
            $table->string('holiday_comment')->nullable();
            $table->integer('vacation');
            $table->string('vacation_comment')->nullable();
            $table->bigInteger('driving_charges');
            $table->string('driving_charges_comment')->nullable();
            $table->bigInteger('extraordinarily');
            $table->string('extraordinarily_comment')->nullable();
            $table->bigInteger('clothes')->nullable();
            $table->string('clothes_comment')->nullable();
            $table->integer('mission')->unsigned();
            $table->foreign('mission')->references('id')->on('missions');
            $table->string('bank_account_number');
            $table->integer('document_number')->nullable(); // "Beleg Nummer"
            $table->date('booked_date')->nullable();
            $table->date('paid_date')->nullable();
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
