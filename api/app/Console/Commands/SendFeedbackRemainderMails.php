<?php

namespace App\Console\Commands;

use App\Mission;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\App;

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
            $vorname = $user->first_name;
            $email = $user->email;
            $subject = "Deine Meinung ist uns wichtig";
            $emailText = 'Lieber '.$vorname.',
              
wir danken dir herzlich für deinen Einsatz bei der Stiftung Wirtschaft und Ökologie SWO. Um besser abschätzen zu können wie dein Einsatz beim SWO war, bitten wir dich, unsere Evaluation auszufüllen.
          
Du findest die Evaluation unter folgendem Link: https://izivi.stiftungswo.ch/user_feedback/'.$mission->id.'

Herzlichen Dank für dein Feedback.
          
Liebe Grüsse aus Schwerzenbach
          
Dein SWO-Team
Bahnstrasse 9
8603 Schwerzenbach

Phone:  +41 (0)43 355 58 44
E-Mail:  swo@stiftungswo.ch
http://www.stiftungswo.ch';

            print $email."\n";
            if (App::environment('production')) {
                mail($email, $subject, utf8_decode($emailText), 'From: swo@stiftungswo.ch');
            } else {
                mail("test@stiftungswo.ch", $subject, utf8_decode($emailText), 'From: swo@stiftungswo.ch');
            }

            $mission->feedback_mail_sent = true;
            $mission->save();
        }
    }
}
