<?php

namespace App\Mail;

class NewUserFeedback extends ZiviMailer
{
    /**
     * Create a new message instance.
     *
     * @return void
     */

    /**
     * @var String
     */
    public $feedbackId;

    /**
     * @var String null
     */
    public $url;

    public function __construct(String $feedbackId)
    {
        $this->feedbackId = $feedbackId;
        $this->url = env('APP_URL', null);
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->prefixSubject('Feedback von einem Zivi erstellt')->view('emails.user_feedback.new_feedback');
    }
}
