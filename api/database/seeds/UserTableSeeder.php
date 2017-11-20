<?php

use Illuminate\Database\Seeder;

class UserTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('users')->insert([
            'first_name' => 'John',
            'last_name' => ' Doe',
            'email' => 'johndoe@example.com',
            'password' => app('hash')->make('johndoe'),
            'remember_token' => str_random(10),
            'role' => 2,
            'regional_center' => 2
        ]);
    }
}
