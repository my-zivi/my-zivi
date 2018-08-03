<?php

namespace App\Mail;

class UpdateHoliday extends ZiviMailer
{
    /**
     * @var String null
     */
    public $url;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->url = env('APP_URL', null);
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->prefixSubject('Feiertage aktualisieren')->view('emails.holiday.update_holiday');
    }
}
