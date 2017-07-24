<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Eloquent;

class CreateTableCantons extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('cantons', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->string('short_name');
        });
        
        DB::table('cantons')->insert([
            array('name' => 'Zürich', 'short_name' => 'ZH'),
            array('name' => 'Bern', 'short_name' => 'BE'),
            array('name' => 'Luzern', 'short_name' => 'LU'),
            array('name' => 'Uri', 'short_name' => 'UR'),
            array('name' => 'Schwyz', 'short_name' => 'SZ'),
            array('name' => 'Obwalden', 'short_name' => 'OW'),
            array('name' => 'Nidwalden', 'short_name' => 'NW'),
            array('name' => 'Glarus', 'short_name' => 'GL'),
            array('name' => 'Zug', 'short_name' => 'ZG'),
            array('name' => 'Freiburg', 'short_name' => 'FR'),
            array('name' => 'Solothurn', 'short_name' => 'SO'),
            array('name' => 'Basel-Stadt', 'short_name' => 'BS'),
            array('name' => 'Basel-Landschaft', 'short_name' => 'BL'),
            array('name' => 'Schaffhausen', 'short_name' => 'SH'),
            array('name' => 'Appenzell Ausserrhoden', 'short_name' => 'AR'),
            array('name' => 'Appenzell Innerrhoden', 'short_name' => 'AI'),
            array('name' => 'St. Gallen', 'short_name' => 'SG'),
            array('name' => 'Graubünden', 'short_name' => 'GR'),
            array('name' => 'Aargau', 'short_name' => 'AG'),
            array('name' => 'Thurgau', 'short_name' => 'TG'),
            array('name' => 'Tessin', 'short_name' => 'TI'),
            array('name' => 'Waadt', 'short_name' => 'VD'),
            array('name' => 'Wallis', 'short_name' => 'VS'),
            array('name' => 'Neuenburg', 'short_name' => 'NE'),
            array('name' => 'Genf', 'short_name' => 'GE'),
            array('name' => 'Jura', 'short_name' => 'JU')
        ]);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('cantons');
    }
}
