<?php

namespace App\Console\Commands;

use App\Holiday;
use Carbon\Carbon;
use Illuminate\Console\Command;

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

        $minDate = Carbon::now()->addMonth()->addWeeks(3);

        if ($holidayDate > $minDate) {
            return; // all good
        }

        $this->line('Es sind nicht mehr genügend Feiertage im Dime eingetragen!');
        $this->line('Es müssen immer für mindestens das nächste Jahr Feiertage hinterlegt sein.');
    }
}
