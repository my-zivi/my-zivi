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
        $this->call([
            HolidayTableSeeder::class,
            UserTableSeeder::class
        ]);
    }
}
