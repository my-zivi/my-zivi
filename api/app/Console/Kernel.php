<?php

namespace App\Console;

use App\Console\Commands\CheckHolidayCommand;
use App\Console\Commands\FetchBICs;
use App\Console\Commands\FormatPhonenumbersCommand;
use App\Console\Commands\SendFeedbackReminderMails;
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
        SendFeedbackReminderMails::class,
        DatabaseCreateCommand::class,
        FetchBICs::class,
        CheckHolidayCommand::class,
        FormatPhonenumbersCommand::class,
    ];

    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {
        $schedule->command(SendFeedbackReminderMails::class)->daily();
    }
}
