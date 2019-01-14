<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 8/8/17
 * Time: 11:18 AM
 */

namespace App\Services\PDF;

use App\CompanyInfo;
use App\Holiday;
use App\Mission;
use App\RegionalCenter;
use App\Specification;
use App\User;

class AufgebotPDF extends PDF
{

    private $einsatz;
    private $pflichtenheft;
    private $zivi;
    private $regionalzentrum;
    private $companyHolidays;

    public function __construct($missionId)
    {
        parent::__construct();

        $this->einsatz = Mission::find($missionId);
        $this->pflichtenheft = $this->einsatz->specification;
        $this->zivi = $this->einsatz->user;
        $this->regionalzentrum = RegionalCenter::find($this->zivi->regional_center_id);

        $this->companyHolidays = Holiday::whereDate("date_from", "<=", $this->einsatz->end)
            ->whereDate("date_to", ">=", $this->einsatz->start)
            ->where("holiday_type_id", "=", "1")
            ->get();
    }

    public function getUserId()
    {
        return $this->zivi->id;
    }

    protected function render()
    {
        /*$this->zivi = array("health_insurance"=>"KPT","kontoNr"=>"43", "id"=>"36680", "street"=>"asd", "zip"=>"sadjl", "city"=>"jasd", "phoneP"=>"asdljk", "phoneM"=>"asjl");
        $this->zivi = array("lastname"=>"rösch", "firstname"=>"simon","email"=>"bsad@absdl.ch");*/
        $companyHolidays = array();


        $row = 0;
        $colLeft = 65;
        $colRight = 140;

        $__WORKING_BREAKFAST = array(
            "basex" => 68.4,
            "basey" => 57.7,
            "dbAttributeName" => "working_breakfast_expenses");
        $__WORKING_LUNCH = array(
            "basex" => 68.4,
            "basey" => 70.8,
            "dbAttributeName" => "working_lunch_expenses");
        $__WORKING_DINNER = array(
            "basex" => 68.4,
            "basey" => 84.3,
            "dbAttributeName" => "working_dinner_expenses");
        $__SPARETIME_BREAKFAST = array(
            "basex" => 112.9,
            "basey" => 57.7,
            "dbAttributeName" => "sparetime_breakfast_expenses");
        $__SPARETIME_LUNCH = array(
            "basex" => 112.9,
            "basey" => 70.8,
            "dbAttributeName" => "sparetime_lunch_expenses");
        $__SPARETIME_DINNER = array(
            "basex" => 112.9,
            "basey" => 84.3,
            "dbAttributeName" => "sparetime_dinner_expenses");

        $lunchchoices = array(
            $__WORKING_BREAKFAST, $__WORKING_LUNCH, $__WORKING_DINNER,
            $__SPARETIME_BREAKFAST, $__SPARETIME_LUNCH, "");

        $__WORKING_TIME_MODEL_DB_ATTRIBUTE_NAME = "working_time_model";
        $__WORKING_TIME_MODEL_POSITION[0]["cx"] = 111.0;
        $__WORKING_TIME_MODEL_POSITION[0]["cy"] = 238.5;
        $__WORKING_TIME_MODEL_POSITION[1]["cx"] = 150.0;
        $__WORKING_TIME_MODEL_POSITION[1]["cy"] = 238.5;
        $__WORKING_TIME_MODEL_POSITION[2]["cx"] = 111.0;
        $__WORKING_TIME_MODEL_POSITION[2]["cy"] = 242.0;
        $__WORKING_TIME_MODEL_POSITION[3]["cx"] = 150.0;
        $__WORKING_TIME_MODEL_POSITION[3]["cy"] = 242.0;

        $__WORKING_TIME_WEEKLY_DB_ATTRIBUTE_NAME = "working_time_weekly";
        $__WORKING_TIME_WEEKLY_POSITION["cx"] = 56;
        $__WORKING_TIME_WEEKLY_POSITION["cy"] = 234.0;

        $__ACCOMMODATION_DB_ATTRIBUTE_NAME = "accommodation";
        $__ACCOMMODATION_POSITION["cx"] = 68.5;
        $__ACCOMMODATION_POSITION["cy"] = 37.6;

        $__CHOICE_VERTICAL_DISTANCE = 4.35;
        $__CHOICE_CHARACTER = "x";

        $this->pdf->SetAutoPageBreak(false);
        $this->pdf->AddPage();
        $this->pdf->SetFont('Arial', '', 11);

        $this->pdf->SetXY(30, 60);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_NAME);
        $this->pdf->SetXY(30, 67);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_ADDRESS_WORKPLACE);
        $this->pdf->SetXY(30, 74);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_CITY_WORKPLACE);

        $this->pdf->SetXY(125, 60);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_NAME);
        $this->pdf->SetXY(125, 67);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_ADDRESS_WORKPLACE);
        $this->pdf->SetXY(125, 74);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_CITY_WORKPLACE);

        $this->pdf->SetXY(25, 120);
        $this->pdf->Cell(0, 0, "Lieber Zivi");
        $this->pdf->SetXY(25, 127);
        $this->pdf->Cell(0, 0, "Bitte sende die unterzeichnete Einsatzvereinbarung an obige Adresse. Wenn du ein Fenstercouvert mit");
        $this->pdf->SetXY(25, 134);
        $this->pdf->Cell(0, 0, "Fenster links oder rechts verwendest, kannst du dieses Deckblatt falten und in das Couvert stecken.");
        $this->pdf->SetXY(25, 141);
        $this->pdf->Cell(0, 0, "Die Adresse ist richtig platziert. Die Adresse unten rechts wird von uns benutzt um");
        $this->pdf->SetXY(25, 148);
        $this->pdf->Cell(0, 0, "die Einsatzvereinbarung an die Regionalstelle weiterzuleiten.");
        $this->pdf->SetXY(25, 155);
        $this->pdf->Cell(0, 0, "Ganz am Ende findest du ein Informationsblatt, das dir Auskunft über den Ablauf deines");
        $this->pdf->SetXY(25, 162);
        $this->pdf->Cell(0, 0, "Einsatzes gibt. Gib bitte den Talon darin am ersten Einsatztag unterschrieben dem Einsatzleiter ab.");

        $this->pdf->SetXY(125, 210);
        $this->pdf->MultiCell(0, 6, str_replace(", ", "\n", $this->regionalzentrum['address']), 0, 'L');

        // Seite Einsatzvereinbarung
        $this->pdf->AddPage();
        $this->pdf->Image(storage_path('app/einsatzvereinbarung_2016_S1.jpg'), 0, 10, 210);
        //$this->pdf->Image('images/Einsatzvereinbarung_Thun_2011_12.jpg', 0, 10, 210);

        $this->pdf->SetFont('Arial', '', 9);

        // Name der Regionalstelle
        $this->pdf->SetXY(104, 35.5);
        $this->pdf->MultiCell(0, 3, $this->regionalzentrum['name']);
        $this->pdf->SetFont('Arial', 'B', 16);

        // Titel je nachdem ob es sich um eine Verlï¿½ngerung handelt oder nicht
        $this->pdf->SetXY(29, 54);

        $this->pdf->SetFont('Arial', '', 11);

        $row = 74;


        // Angaben zum Zivi
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, $this->zivi['zdp']);
        $this->nextrow($row);

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, $this->zivi['last_name']);
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, $this->zivi['first_name']);
        $this->nextrow($row);

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, $this->zivi['address']);
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, $this->zivi['zip'] . " " . $this->zivi['city']);
        $this->nextrow($row);

        $this->pdf->SetXY($colLeft, $row);
        if ($this->zivi['phone_private'] != 0) {
            $this->pdf->Cell(0, 0, $this->zivi['phone_private']);
        }
        $this->pdf->SetXY($colRight, $row);
        if ($this->zivi['phone_mobile'] != 0) {
            $this->pdf->Cell(0, 0, $this->zivi['phone_mobile']);
        }
        $this->nextrow($row);

        $colLeft = 50;
        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, $this->zivi['bank_iban']);
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, $this->zivi['email']);
        $this->nextrow($row);
        $colLeft = 65;

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, $this->zivi['health_insurance']);
        $this->nextrow($row);
        $row += 0.875;

        $this->nextrow($row);
        $row += 5;


        // Angaben zum Einsatzbetrieb

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_NO);
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_NAME_EIS);
        $this->nextrow($row);

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::RESPONSIBLE_PERSON_NAME);
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::RESPONSIBLE_FUNCTION);
        $this->nextrow($row);

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_ADDRESS);
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_CITY);
        $this->nextrow($row);

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::RESPONSIBLE_PHONE);
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::RESPONSIBLE_MAIL);
        $this->nextrow($row);
        $row += 5.5;

        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::RESPONSIBLE_FUNCTION);
        $this->nextrow($row);

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::RESPONSIBLE_PERSON_NAME);
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::RESPONSIBLE_PHONE);
        $this->nextrow($row);
        $row += 6;


        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, CompanyInfo::COMPANY_CITY_WORKPLACE);
        $this->nextrow($row);

        $this->pdf->SetXY($colLeft, $row);
        $this->pdf->Cell(0, 0, $this->einsatz->start->format('DD.MM.YYYY'));
        $this->pdf->SetXY($colRight, $row);
        $this->pdf->Cell(0, 0, $this->einsatz->end->format('DD.MM.YYYY'));
        $this->nextrow($row);

        $row = 201;
        if ($this->einsatz['long_mission'] == 0) {
            $this->pdf->SetXY(48.75, $row);
            $this->pdf->Cell(0, 0, 'x');
        } else {
            $this->pdf->SetXY(105.5, $row);
            $this->pdf->Cell(0, 0, 'x');
        }
        if ($this->einsatz['probation_period'] != 0) {
            $this->pdf->SetXY(75, $row);
            $this->pdf->Cell(0, 0, 'x');
        }
        $this->nextrow($row);


        //Angaben zum Einsatz
        $this->pdf->SetXY($colLeft + 30, $row);
        $this->pdf->Cell(0, 0, strval($this->pflichtenheft['id']) . ' ' . $this->pflichtenheft['name']);
        $this->nextrow($row);
        $row += 6.25;

        if (count($this->companyHolidays) > 0) {
            for ($i = 0; $i < count($this->companyHolidays); $i++) {
                $text = date("d.m.Y", strtotime($this->companyHolidays[$i]->date_from));
                $this->pdf->SetXY(120, $row);
                $this->pdf->Cell(0, 0, $text);
                $text = date("d.m.Y", strtotime($this->companyHolidays[$i]->date_to));
                $this->pdf->SetXY(160, $row);
                $this->pdf->Cell(0, 0, $text);
                break;
            }
        } else {
            $text = "keine";
            $this->pdf->SetXY(70, $row);
            $this->pdf->Cell(0, 0, $text);
        }

        //2nd Page ...
        $this->pdf->AddPage();

        $this->pdf->Image(storage_path('app/einsatzvereinbarung_2016_S2.jpg'), 0, 0, 210);


        $row = 179;
        // Bekleidung
        $this->pdf->SetFont('Arial', '', 11);

        // Ort und Datum Aufgebot Zivi
        $row = 269;
        $this->pdf->SetXY(30, $row);
        $this->pdf->Cell(0, 0, $this->zivi['city'] . ", " . date("d.m.Y"));

        // Ort ufgebot SWO
        $this->pdf->SetXY(111, $row);
        $this->pdf->Cell(0, 0, "Schwerzenbach,");

        // Bedingungen anhängen
        if (strlen($this->pflichtenheft["manual_file"]) > 0) {
            $this->appendPdf($this->pdf, storage_path('app/' . $this->pflichtenheft["manual_file"]));
        }
    }

    /**
     * Imports all pages of an existing pdf document and appends it to the $pdf document
     * @param FPDI $pdf Pdf document where the file should be appended
     * @param string $fileName The PDF file which should be appended
     */
    private function appendPdf(&$pdf, $fileName)
    {
        $pagecount = $pdf->setSourceFile($fileName);
        for ($i = 1; $i <= $pagecount; $i++) {
            $tplidx = $pdf->ImportPage($i);
            $pdf->AddPage();
            $pdf->useTemplate($tplidx);
        }
    }

    private function nextrow(&$row)
    {
        $row += 6.875;
    }
}
