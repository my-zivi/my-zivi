<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ModifyUserFields extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('phone');
            $table->boolean('driving_licence_b')->default(false);
            $table->boolean('driving_licence_be')->default(false);
        });

        // update new phone field
        $users = DB::table('users')->select('id', 'phone_mobile', 'phone_private', 'phone_business')->get();
        $users->each(function ($user) {
            $phones = [ $user->phone_mobile, $user->phone_private, $user->phone_business ];
            $not_empty_phones = preg_grep('/^[0|-]$/i', $phones, PREG_GREP_INVERT);
            $phone = array_shift($not_empty_phones) ?? "";
            DB::table('users')->where('id', $user->id)
                ->update(['phone' => $phone]);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('phone');
            $table->dropColumn('driving_licence_b');
            $table->dropColumn('driving_licence_be');
        });
    }
}
