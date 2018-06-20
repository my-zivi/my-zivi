<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
use App\Specification;

class UpdatedIdForSpecifications extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // first, drop the foreign key to be able to touch the id column
        Schema::table('missions', function (Blueprint $table) {
            $table->dropForeign('missions_specification_foreign');
        });

        // change data types
        Schema::table('specifications', function (Blueprint $table) {
            $table->string('id')->change();
        });

        Schema::table('missions', function (Blueprint $table) {
            $table->string('specification')->change();
        });

        // change id to notation with underscore
        $specification_ids = DB::table('specifications')->select('id')->get();
        $specification_ids->each(function ($specification_obj) {

            // build the new id based on the old one
            $existing_id = $specification_obj->id;
            $new_id = str_replace('.', '_', $existing_id);

            // only update the record if the old and new id differ
            if ($existing_id != $new_id) {
                DB::table('specifications')->where('id', $existing_id)
                    ->update(['id' => $new_id]);
                DB::table('missions')->where('specification', $existing_id)
                    ->update(['specification' => $new_id]);
            }
        });

        // restore foreign key relation
        Schema::table('missions', function (Blueprint $table) {
            $table->foreign('specification')->references('id')->on('specifications')
                ->onDelete('restrict')->onUpdate('restrict');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        // first, drop the foreign key to be able to touch the id column
        Schema::table('missions', function (Blueprint $table) {
            $table->dropForeign('missions_specification_foreign');
        });

        // change id to notation with dot
        $specification_ids = DB::table('specifications')->select('id')->get();
        $specification_ids->each(function ($specification_obj) {

            // build the new id based on the old one
            $existing_id = $specification_obj->id;
            $new_id = str_replace('_', '.', $existing_id);

            // only update the record if the old and new id differ
            if ($existing_id != $new_id) {
                DB::table('specifications')->where('id', $existing_id)
                    ->update(['id' => $new_id]);
                DB::table('missions')->where('specification', $existing_id)
                    ->update(['specification' => $new_id]);
            }
        });

        // change back data type of column
        Schema::table('specifications', function (Blueprint $table) {
            $table->float('id')->change();
        });

        Schema::table('missions', function (Blueprint $table) {
            $table->float('specification')->change();
        });

        // restore old data type
        Schema::table('missions', function (Blueprint $table) {
            $table->foreign('specification')->references('id')
                ->on('specifications')->onDelete('restrict')->onUpdate('restrict');
        });
    }
}
