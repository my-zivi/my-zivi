<?php

namespace App\Mail;

use App\User;
use App\Mission;

class FeedbackReminder extends ZiviMailer
{
    /**
     * Create a new message instance.
     *
     * @return void
     */

    /**
     * @var User
     */
    public $user;

    /**
     * @var Mission
     */
    public $mission;

    /**
     * @var mixed
     */
    public $url;

    public function __construct(User $user, Mission $mission)
    {
        $this->user = $user;
        $this->mission = $mission;
        $this->url = env('APP_URL', null);
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->prefixSubject('Deine Meinung ist uns wichtig')->view('emails.user.feedback_reminder');
    }
}
