<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class SecurePasswords extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        $users = DB::table('users')
            ->whereNull('users.deleted_at')
            ->get();

        foreach ($users as $user) {
            DB::table('users')
                ->where('id', '=', $user->id)
                ->update(['password' => $this->HashPW($user->password)]);
        }
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //Schema::drop('users');
    }

    private function HashPW($newPW)
    {
        return password_hash($newPW, PASSWORD_BCRYPT);
    }
}
