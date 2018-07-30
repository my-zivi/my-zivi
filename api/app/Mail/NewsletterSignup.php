<?php

namespace App\Mail;

use App\User;

class NewsletterSignup extends ZiviMailer
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

    public function __construct(User $user)
    {
        $this->user = $user;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->prefixSubject('iZivi Registration Newsletter-Anmeldung')->view('emails.user.newsletter_signup');
    }
}
