<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddIgnoreFirstAndLastDayFieldToReportSheets extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('report_sheets', function (Blueprint $table) {
            $table->boolean('ignore_first_last_day')->default(false);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('report_sheets', function (Blueprint $table) {
            $table->dropColumn('ignore_first_last_day');
        });
    }
}
