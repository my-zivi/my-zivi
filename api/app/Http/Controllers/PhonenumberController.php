<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Input;
use libphonenumber\NumberParseException;
use libphonenumber\PhoneNumberFormat;
use libphonenumber\PhoneNumberUtil;

class PhonenumberController extends Controller
{

    public function validatePhonenumber()
    {
        $number = Input::get('phonenumber', '');
        $phoneUtil = PhoneNumberUtil::getInstance();

        $formatted = '';
        try {
            $numberProto = $phoneUtil->parse($number, 'CH');
            $isValid = $phoneUtil->isValidNumber($numberProto);
            if ($isValid) {
                $formatted = $phoneUtil->formatOutOfCountryCallingNumber($numberProto, 'CH');
            }
        } catch (NumberParseException $e) {
            $isValid = false;
        }

        return [
            'is_valid' => $isValid,
            'formatted' => $formatted,
        ];
    }
}
