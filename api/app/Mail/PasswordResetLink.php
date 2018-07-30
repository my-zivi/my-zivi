<?php

namespace App\Mail;

class PasswordResetLink extends ZiviMailer
{
    /**
     * Create a new message instance.
     *
     * @return void
     */

    /**
     * @var String
     */
    public $token;

    /**
     * @var mixed
     */
    public $url;

    public function __construct(String $token)
    {
        $this->token = $token;
        $this->url = env('APP_URL', null);
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->prefixSubject('iZivi Passwort vergessen')->view('emails.user.password_reset_link');
    }
}
