<?php

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

abstract class ZiviMailer extends Mailable
{

    use SerializesModels;

    public function prefixSubject(String $subject)
    {
        return $this->subject(app()->environment('production') ? $subject : 'iZivi Test: ' . $subject);
    }
}
