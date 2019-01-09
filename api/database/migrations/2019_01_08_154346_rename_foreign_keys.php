<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class RenameForeignKeys extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('holidays', function (Blueprint $table) {
            $table->renameColumn('holiday_type', 'holiday_type_id');
        });

        Schema::table('missions', function (Blueprint $table) {
            $table->renameColumn('specification', 'specification_id');
            $table->renameColumn('user', 'user_id');
        });

        Schema::table('payment_entries', function (Blueprint $table) {
            $table->renameColumn('payment', 'payment_id');
            $table->renameColumn('report_sheet', 'report_sheet_id');
            $table->renameColumn('user', 'user_id');
        });

        Schema::table('report_sheets', function (Blueprint $table) {
            $table->renameColumn('mission', 'mission_id');
            $table->renameColumn('user', 'user_id');
        });

        Schema::table('user_feedbacks', function (Blueprint $table) {
            $table->renameColumn('user', 'user_id');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->renameColumn('regional_center', 'regional_center_id');
            $table->renameColumn('role', 'role_id');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('holidays', function (Blueprint $table) {
            $table->renameColumn('holiday_type_id', 'holiday_type');
        });

        Schema::table('missions', function (Blueprint $table) {
            $table->renameColumn('specification_id', 'specification');
            $table->renameColumn('user_id', 'user');
        });

        Schema::table('payment_entries', function (Blueprint $table) {
            $table->renameColumn('payment_id', 'payment');
            $table->renameColumn('report_sheet_id', 'report_sheet');
            $table->renameColumn('user_id', 'user');
        });

        Schema::table('report_sheets', function (Blueprint $table) {
            $table->renameColumn('mission_id', 'mission');
            $table->renameColumn('user_id', 'user');
        });

        Schema::table('user_feedbacks', function (Blueprint $table) {
            $table->renameColumn('user_id', 'user');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->renameColumn('regional_center_id', 'regional_center');
            $table->renameColumn('role_id', 'role');
        });
    }
}
