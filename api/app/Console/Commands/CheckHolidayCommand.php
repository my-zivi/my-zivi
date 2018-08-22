<?php

namespace App\Console\Commands;

use App\Holiday;
use App\Mail\UpdateHoliday;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Mail;

class CheckHolidayCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'command:check-holiday';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Check if there are still enough holiday entries left';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $holiday = Holiday::query()->orderBy('date_from', 'desc')->firstOrFail();
        $holidayDate = Carbon::parse($holiday->date_from);

        $minDate = Carbon::now()->addYear();

        if ($holidayDate > $minDate) {
            return; // all good
        }

        if (app()->environment('production')) {
            Mail::to(env('API_MAIL_FEEDBACK', "office@stiftungswo.ch"))->send(new UpdateHoliday());
        } else {
            Mail::to(env('API_MAIL_FEEDBACK', "test@stiftungswo.ch"))->send(new UpdateHoliday());
        }
    }
}
