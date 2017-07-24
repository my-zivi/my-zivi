<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTableRegionalCenters extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('regional_centers', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->string('address');
            $table->string('short_name');
        });
        
        DB::table('regional_centers')->insert([
            array('name' => 'Regionalzentrum Thun', 'address' => 'Vollzugsstelle für den Zivildienst ZIVI, Regionalzentrum Thun, Malerweg 6, 3600 Thun', 'short_name' => 'Th'),
            array('name' => 'Regionalzentrum Rueti/ZH', 'address' => 'Vollzugsstelle für den Zivildienst ZIVI, Regionalzentrum Rüti (ZH), Spitalstrasse 31, Postfach, 8630 Rüti (ZH) ', 'short_name' => 'Ru'),
            array('name' => 'Regionalzentrum Lausanne', 'address' => 'Organe d’exécution du service civil ZIVI, Centre régional de Lausanne, Route de Chavannes 31, Case postale, 1001 Lausanne', 'short_name' => 'La'),
            array('name' => 'Regionalzentrum Rivera', 'address' => 'Organo d’esecuzione del servizio civile ZIVI, Centro regionale Rivera, Via Lagacci 8, CP 443, 6802 Rivera', 'short_name' => 'Ri'),
            array('name' => 'Regionalzentrum Aarau', 'address' => 'Vollzugsstelle für den Zivildienst ZIVI, Regionalzentrum Aarau, Bahnhofstrasse 29, Postfach, 5000 Aarau', 'short_name' => 'Aa')
        ]);
    }

    
    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('regional_centers');
    }
}
