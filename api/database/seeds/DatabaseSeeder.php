<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // seed random data generator
        app(\Faker\Generator::class)->seed();
        factory(\App\Holiday::class, 10)->create();
        factory(\App\ReportSheet::class, 10)->create(); // dont need to seed Mission / Specification, included in Reportsheets
        factory(\App\User::class, 'admin')->create();
        factory(\App\User::class, 10)->create();
    }
}
