<?php

use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddMissionDaysToMissions extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('missions', function (Blueprint $table) {
            $table->addColumn('integer', 'days')->after('draft');
        });

        $missions = DB::table('missions')->select('id', 'start', 'end')->get();
        $missions->each(function ($mission) {
            $missionDays = \App\Services\Calculator\MissionDaysCalculator::calculateEligibleDays(Carbon::parse($mission->start), Carbon::parse($mission->end));

            DB::table('missions')->where('id', $mission->id)
                ->update(['days' => $missionDays]);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('missions', function (Blueprint $table) {
            $table->dropColumn('days');
        });
    }
}
