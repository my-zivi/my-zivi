<?php

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class NewUserFeedback extends Mailable
{
    use SerializesModels;

    /**
     * Create a new message instance.
     *
     * @return void
     */

    /**
     * @var int
     */
    public $feedbackId;

    /**
     * @var String null
     */
    public $url;

    public function __construct(int $feedbackId)
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
        return $this->subject('Feedback von einem Zivi erstellt')->view('emails.user_feedback.new_feedback');
    }
}
