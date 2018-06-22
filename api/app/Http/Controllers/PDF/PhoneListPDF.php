<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 7/25/17
 * Time: 11:25 AM
 */

namespace App\Http\Controllers\PDF;

use App\Mission;
use App\Specification;

class PhoneListPDF extends PDF
{

    private $__PDF_TOP = 25;
    private $__PDF_LEFT = 20;
    private $__PDF_BODY_HEIGHT = 150;
    private $__PDF_ROW_HEIGHT = 5;
    private $__PDF_INTERROW_HEIGHT = 4;
    private $__PDF_INTERSECTION_HEIGHT = 5;

    private $typeOfNumber;

    private $startDate;
    private $endDate;
    private $zivis;

    public function __construct($from, $to)
    {
        parent::__construct(true);
        $this->startDate = $from;
        $this->endDate = $to;
        $this->zivis = array();

        $specifications = Specification::select('*', 'id')->get();
        foreach ($specifications as $specification) {
            $zivis = Mission::join('users', 'users.id', '=', 'missions.user')
                ->where('specification', '=', $specification->id)
                ->whereDate('start', '<=', date('Y-m-d', $to))
                ->whereDate('end', '>=', date('Y-m-d', $from))
                ->orderBy('last_name', 'first_name')->get();

            if (count($zivis)>0) {
                $this->zivis[] = array("pflichtenheftName" => $specification->name, "zivis" => $zivis);
            }
        }

        //json_decode('[{"zivis":[{"lastname": "Test", "firstname":"Simon", "street":"teststrasse", "zip":"1234", "city":"Teststadt", "email":"123@123.ch", "phoneM":"123123"}], "pflichtenheftName":"Pflichtenheft 1"}]', true);
    }

    protected function render()
    {
        $this->goToNextPage($this->pdf, $cx, $cy);

        $this->printTitle($this->pdf, $this->startDate, $this->endDate, $cx, $cy);
        $this->printList($this->pdf, $this->zivis, $cx, $cy);
    }

    private function printTitle(&$pdf, $startDate, $endDate, &$cx, &$cy)
    {
        //doLog("Printing the title");
        $cx = $this->__PDF_LEFT;
        $cy = $this->__PDF_TOP;
        $pdf->SetFont('Times', 'B', 14);
        $pdf->SetXY($cx, $cy);
        $europeanStartDate = $this->timestamp2europeDate($startDate);
        $europeanEndDate = $this->timestamp2europeDate($endDate);
        $pdf->Cell(0, 0, "Telefonliste vom $europeanStartDate bis $europeanEndDate");
        $cy += 15;
    }

    private function printList(&$pdf, &$ziviByPflichtenheft, &$cx, &$cy)
    {
        //doLog("Printing the list");
        $cx = $this->__PDF_LEFT;

        foreach ($ziviByPflichtenheft as $pflichtenheftid => $pflichtenheftData) {
            $this->printPflichtenheftSection($pdf, $pflichtenheftData['pflichtenheftName'], $pflichtenheftData['zivis'], $cx, $cy);
            $cy += $this->__PDF_INTERSECTION_HEIGHT;
        }
    }

    /**
     * Prints the information of all zivis of one pflichtenheft
     * @param FPDF $pdf The PDF document
     * @param string $pflichtenheftName The name of the pflichtenheft
     * @param array $zivis The zivis which work in a certain pflichtenheft
     * @param int $cx The x-coordinate where the row is printed
     * @param int $cy The y-coordinate where the row is printed
     */
    private function printPflichtenheftSection(&$pdf, $pflichtenheftName, &$zivis, &$cx, &$cy)
    {
        //doLog("Printing a pflichtenheft section");
        $sectionTitleHeight = 5;
        $sectionTitleSpaceAfter = 5;
        /* if only 2 more zivis can be placed on the current page,
         print the whole section on following page. */
        $neededHeight = $sectionTitleHeight + $sectionTitleSpaceAfter;
        $neededHeight += 2 * $this->__PDF_ROW_HEIGHT + $this->__PDF_INTERROW_HEIGHT;
        if ($cy + $neededHeight > $this->__PDF_TOP + $this->__PDF_BODY_HEIGHT) {
            $this->goToNextPage($pdf, $cx, $cy);
        }
        // Print section title
        $pdf->SetXY($cx, $cy);
        $pdf->SetFont('Times', 'B', '11');
        $pdf->Cell(0, 0, $pflichtenheftName);
        $cy += $sectionTitleHeight + $sectionTitleSpaceAfter;

        // Print the column header
        $this->printColumnHeader($pdf, $cx, $cy);
        $cy += $this->__PDF_ROW_HEIGHT + $this->__PDF_INTERSECTION_HEIGHT;

        // Print phone data
        for ($i=0; $i<count($zivis); $i++) {
            $zivi = $zivis[$i];
            $this->printRow($pdf, $zivi, $cx, $cy);
            $cy += $this->__PDF_ROW_HEIGHT;
            if ($cy > $this->__PDF_TOP + $this->__PDF_BODY_HEIGHT - $this->__PDF_ROW_HEIGHT &&
                $i < count($zivis)-1) {
                $this->goToNextPage($pdf, $cx, $cy);
                $this->printColumnHeader($pdf, $cx, $cy);
                $cy += $this->__PDF_ROW_HEIGHT + $this->__PDF_INTERSECTION_HEIGHT;
            }
        }
    }

    /**
     * Adds a new page to the document and places cursor to the top of it
     * @param FPDF $pdf The PDF document
     * @param int $cx The x-coordinate where the row is printed
     * @param int $cy The y-coordinate where the row is printed
     */
    private function goToNextPage(&$pdf, &$cx, &$cy)
    {
        //doLog("Going to the next page");
        $pdf->AddPage();
        $cx = $this->__PDF_LEFT;
        $cy = $this->__PDF_TOP;
        $this->printPageHeader($pdf);
        $this->printPageFooter($pdf);
    }

    private function printColumnHeader(&$pdf, $cx, $cy)
    {
        $pdf->SetFont('Times', 'B', 11);
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, "Nachname");
        $cx += 40;
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, "Vorname");
        $cx += 30;
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, "Adresse");
        $cx += 50;
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, "PLZ / Ort");
        $cx += 40;
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, "Telefonnummer");
        $cx += 40;
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, "Email");
    }

    /**
     * Prints a row of the phone list
     * @param FPDF $pdf The PDF document
     * @param array $zivi The zivi which is displayed in the row
     * @param int $cx The x-coordinate where the row is printed
     * @param int $cy The y-coordinate where the row is printed
     */
    private function printRow(&$pdf, &$zivi, $cx, $cy)
    {
        //doLog("Printing a single row");
        $pdf->SetFont('Times', '', 11);
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, $zivi["last_name"]);
        $cx += 40;
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, $zivi["first_name"]);
        $cx += 30;
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, $zivi["address"]);
        $cx += 50;
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, $zivi["city"]);
        $cx += 40;
        $pdf->SetXY($cx, $cy);
        $phone = $this->getZiviPhoneNumber($zivi, $this->typeOfNumber);
        $pdf->Cell(0, 0, $this->typeOfNumber);
        $cx += 5;
        // the phone number should be aligned right
        $phonecx = $cx + 25 - $pdf->GetStringWidth($phone);
        $pdf->SetXY($phonecx, $cy);
        $pdf->Cell(0, 0, $phone);
        $cx += 35;
        if (!$zivi["email"]) {
            $zivi["email"] = "-";
        }
        $pdf->SetXY($cx, $cy);
        $pdf->Cell(0, 0, $zivi["email"]);
    }

    /**
     * Gets the best suitable phone number of a Zivi
     * 1. priority: Mobile phone, 2. priority: Private, 3. priority: Business
     * @param array $zivi The zivi with the phone number
     * @return String with the phone number
     */
    private function getZiviPhoneNumber(&$zivi, &$typeOfNumber)
    {
        foreach (array("mobile", "private", "business") as $phone) {
            if (isset($zivi["phone_".$phone]) && strlen($zivi["phone_".$phone])>0) {
                switch ($phone) {
                    case "mobile":
                        $typeOfNumber = "M:";
                        break;
                    case "private":
                        $typeOfNumber = "M:";
                        break;
                    case "business":
                        $typeOfNumber = "M:";
                        break;
                }
                return $zivi["phone_".$phone];
            }
        }
        // no valid number available
        return "-";
    }

    private function printPageHeader(&$pdf)
    {
        $pdf->SetFont('Times', '', 10);
        $pdf->SetXY(165, 12);
        $pdf->Cell(0, 0, "Stand " . date("d.m.Y"));
    }

    private function printPageFooter(&$pdf)
    {
        //doLog(print_R($HTTP_SERVER_VARS),true);
        $pdf->SetFont('Times', '', 10);
        $pdf->SetXY(20, 185);
        //$pdf->Cell(0,0,"http://" . $SERVER_NAME . $HTTP_SERVER_VARS["SCRIPT_NAME"]);
        $pdf->SetX(165);
        $pdf->Cell(0, 0, "Seite " .$pdf->PageNo());
    }
}
