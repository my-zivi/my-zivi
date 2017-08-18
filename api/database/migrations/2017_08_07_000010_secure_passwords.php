<?php

use Illuminate\Database\Migrations\Migration;

//This file does nothing and only exists to fix the migration reset if the corresponding After migration was run

class SecurePasswords extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //do nothing, this migration is optional and therefore placed in the After folder
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
    }
}
