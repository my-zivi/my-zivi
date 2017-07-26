<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 7/25/17
 * Time: 11:34 AM
 */

namespace App\Http\Controllers\PDF;

use FPDI;

abstract class PDF
{
    protected $pdf;

    public function __construct($landscape = false)
    {
        if ($landscape) {
            $this->pdf = new FPDI('L');
        } else {
            $this->pdf = new FPDI();
        }
    }

    abstract protected function render();

    public function createPDF()
    {

        $this->render();

        $DIR_TEMP = "/tmp";
        $file=basename(tempnam($DIR_TEMP, 'tmp'));
        //Save PDF to file
        $this->pdf->Output($file, 'F');
        return $file;
    }

    /*
     * Helpers
     */

    /**
     * Converts a unix timestamp to a iso date (YYYY-MM-DD).
     * @param int $timestamp A unix timestamp
     */
    protected function timestamp2iso($timestamp)
    {
        $isoDate= date("Y-m-d", $timestamp);
        return $isoDate;
    }

    /**
     * Converts a unix timestamp to a european date (DD.MM.YYYY)
     */
    protected function timestamp2europeDate($timestamp)
    {
        $europeanDate = date("d.m.Y", $timestamp);
        return $europeanDate;
    }
}
