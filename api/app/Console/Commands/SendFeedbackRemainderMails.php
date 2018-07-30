<?php

namespace App\Console\Commands;

use App\Mission;
use Carbon\Carbon;
use Illuminate\Console\Command;
use App\Mail\FeedbackReminder;
use Illuminate\Support\Facades\Mail;

class SendFeedbackRemainderMails extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'command:sendFeedbackRemainderMails';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

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

        $missions = Mission::whereDate('end', '<', Carbon::now())
            ->where('feedback_mail_sent', '=', '0')
            ->get();

        foreach ($missions as $mission) {
            $user = $mission->usermodel;

            # mail(env('API_MAIL_FEEDBACK', "office@stiftungswo.ch"), "IZIVI TEST: ".$subject, utf8_decode($emailText), 'From: swo@stiftungswo.ch');
            Mail::to(env('API_MAIL_FEEDBACK', "office@stiftungswo.ch"))->send(new FeedbackReminder($user, $mission));

            # $mission->feedback_mail_sent = true;
            $mission->save();
        }
    }
}
