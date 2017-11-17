<?php

namespace App\Console;

use App\Console\Commands\SendFeedbackRemainderMails;
use App\Console\Commands\DatabaseCreateCommand;
use Illuminate\Console\Scheduling\Schedule;
use Laravel\Lumen\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
        SendFeedbackRemainderMails::class,
        DatabaseCreateCommand::class
    ];

    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {
        $schedule->command(SendFeedbackRemainderMails::class)->daily();
    }
}
