<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class PasswordResetLink extends Mailable
{
    use Queueable, SerializesModels;

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
        return $this->subject('iZivi Passwort vergessen')->view('emails.user.password_reset_link');
    }
}
