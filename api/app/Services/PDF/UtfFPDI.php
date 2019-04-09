<?php
/**
 * Created by PhpStorm.
 * User: niels
 * Date: 2019-04-09
 * Time: 15:04
 */

namespace App\Services\PDF;

use setasign\Fpdi\Fpdi;

class UtfFPDI extends FPDI
{

    // phpcs:ignore
    function Cell($w, $h = 0, $txt = "", $border = 0, $ln = 0, $align = '', $fill = false, $link = '', $allowStringOverflow = false)
    {
        if (!empty($txt)) {
            if (mb_detect_encoding($txt, 'UTF-8', false)) {
                $txt = iconv('UTF-8', 'windows-1252', $txt);
            }
            if ($w > 0 && !$allowStringOverflow) {
                $textwidth = $this->getstringwidth($txt);
                while ($textwidth > $w) {              // loop until textwidth is shorter than cell width
                    $txt = substr($txt, 0, -1);             // strip last char
                    $textwidth = $this->getstringwidth($txt); // read text width again
                }
            }
        }
        parent::Cell($w, $h, $txt, $border, $ln, $align, $fill, $link);
    }
}
