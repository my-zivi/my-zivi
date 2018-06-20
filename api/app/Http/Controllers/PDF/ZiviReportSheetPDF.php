<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 7/26/17
 * Time: 8:53 AM
 */

namespace App\Http\Controllers\PDF;

use App\CompanyInfo;
use App\ReportSheet;
use App\User;

class ZiviReportSheetPDF extends PDF
{

    private $left_margin = 25;              // Abstand zum linken Seitenrand
    private $y_offset = 15;                 // Allgemeiner "Item-Abstand"
    private $line_break = 7;                // Zeilenabstand zwischen Hauptzeilen
    private $comment_line_break = 6.5;      // Abstand zwischen Hauptzeile und Kommentar
    private $comment_line_break2 = 5;       // Abstand zwischen zwei Kommentaren
    private $shade_height = 5;              // Höhe der Hintergrundbox für normale Zeilen
    private $shade_height8 = 4;             // Höhe der Hintergrundbox für Kommentarzeilen
    private $bank_shade_width = 125;
    private $additional_offset = 5;

    private $col = array(65, 90, 113, 131, 149, 168);
    private $shade_width = array(24, 22, 17, 17, 17, 22);
    private $col_title = array("Taschengeld", "Unterkunft", "Morgen", "Mittag", "Abend", "Total");

    private $user;
    private $spesen;

    public function __construct($spesenId)
    {
        parent::__construct();

        $this->spesen = ReportSheet::getSpesen($spesenId);

        $this->user = ReportSheet::find($spesenId)->user()->first();
    }

    public function getUserId()
    {
        return $this->user->id;
    }

    public function isDone()
    {
        return $this->spesen->state == 3;
    }

    protected function render()
    {
        $this->pdf->AddPage();

        $this->pdf->SetFont('Arial', 'B', 12);
        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->SetFillColor(210, 240, 230);
        $this->pdf->Cell(165, 10, "Spesenrapport", 0, 0, "", 1);
        $this->pdf->SetFillColor(235, 235, 235);

        $this->pdf->SetFont('Arial', 'B', 10);
        $this->pdf->SetXY($this->left_margin + 32, $this->y_offset);
        $this->pdf->Cell(0, 10, "des Einsatzbetriebes " . CompanyInfo::COMPANY_NO . " - " . CompanyInfo::COMPANY_NAME_SHORT . ", " . CompanyInfo::COMPANY_ADDRESS . ", " . CompanyInfo::COMPANY_CITY);

        $this->y_offset = $this->y_offset + 18;

        $warn_str = "";
        if ($this->spesen['meldeblaetter_tage'] != $this->spesen['sum_tage']) {
            $warn_str .= "Summe der Tage ist falsch! ";
        }
        if ($this->spesen['arbeitstage'] < 0) {
            $warn_str .= "Arbeitstage kleiner als 0!";
        }
        if (!empty($warn_str)) {
            $this->pdf->SetFont('Arial', '', 10);
            $this->pdf->SetXY($this->left_margin, $this->y_offset);
            $this->pdf->SetFillColor(255, 200, 200);
            $this->pdf->Cell(170, 10, "Warnung: " . $warn_str, 1, 0, "", 1);
            $this->pdf->SetFillColor(235, 235, 235);
            $this->y_offset = $this->y_offset + 18;
        }

        $this->pdf->SetFont('Arial', '', 10);
        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Pflichtenheft:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $str = $this->spesen['einsaetze_pflichtenheft'] . " " . $this->spesen['pflichtenheft_name'];
        $this->pdf->Cell(100, $this->shade_height, $str, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Name, Vorname:");
        $this->pdf->SetFont('Arial', 'B', 10);
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $str = $this->user['last_name'] . " " . $this->user['first_name'];
        $this->pdf->Cell(100, $this->shade_height, $str, 0, 0, '', 1);
        $this->pdf->SetFont('Arial', '', 10);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Adresse:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $str = $this->user['address'] . ", " . $this->user['zip'] . " " . $this->user['city'];
        $this->pdf->Cell(100, $this->shade_height, $str, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "ZDP:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell(100, $this->shade_height, $this->user['zdp'], 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Gesamteinsatz:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $str = $this->getGermanDate(strtotime($this->spesen['einsaetze_start'])) . " bis ";
        $str .= $this->getGermanDate(strtotime($this->spesen['einsaetze_end']));
        $str .= " (" . $this->spesen['einsaetze_tage'] . " Tage)";
        $this->pdf->Cell(100, $this->shade_height, $str, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Meldeperiode:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->SetFont('Arial', 'B', 10);
        $str = $this->getGermanDate(strtotime($this->spesen['meldeblaetter_start'])) . " bis ";
        $str .= $this->getGermanDate(strtotime($this->spesen['meldeblaetter_end']));
        $str .= " (" . $this->spesen['meldeblaetter_tage'] . " Tage)";
        $this->pdf->Cell(100, $this->shade_height, $str, 0, 0, '', 1);

        $this->pdf->SetFont('Arial', '', 10);

        $this->y_offset = $this->y_offset + 20;

// Drucke Spaltenbeschriftungen //
        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->col[0], $this->y_offset);
        $this->pdf->Cell($this->shade_width[0], 10, $this->col_title[0]);
        $this->pdf->SetXY($this->col[1], $this->y_offset);
        $this->pdf->Cell($this->shade_width[1], 10, $this->col_title[1]);
        $this->pdf->SetXY($this->col[2], $this->y_offset);
        $this->pdf->Cell($this->shade_width[2], 10, $this->col_title[2]);
        $this->pdf->SetXY($this->col[3], $this->y_offset);
        $this->pdf->Cell($this->shade_width[3], 10, $this->col_title[3]);
        $this->pdf->SetXY($this->col[4], $this->y_offset);
        $this->pdf->Cell($this->shade_width[4], 10, $this->col_title[4]);
        $this->pdf->SetXY($this->col[5], $this->y_offset);
        $this->pdf->Cell($this->shade_width[5], 10, $this->col_title[5], 0, 0, 'R');
        $this->pdf->SetFont('', '');

        $this->y_offset = $this->y_offset + 0.7 * $this->line_break;

// Drucke Einheitsbezeichnungen (Fr.) //
        $this->pdf->SetFont('', '', 9);
        $this->pdf->SetXY($this->col[0], $this->y_offset);
        $this->pdf->Cell($this->shade_width[0], 10, "(Fr.)");
        $this->pdf->SetXY($this->col[1], $this->y_offset);
        $this->pdf->Cell($this->shade_width[1], 10, "(Fr.)");
        $this->pdf->SetXY($this->col[2], $this->y_offset);
        $this->pdf->Cell($this->shade_width[2], 10, "(Fr.)");
        $this->pdf->SetXY($this->col[3], $this->y_offset);
        $this->pdf->Cell($this->shade_width[3], 10, "(Fr.)");
        $this->pdf->SetXY($this->col[4], $this->y_offset);
        $this->pdf->Cell($this->shade_width[4], 10, "(Fr.)");
        $this->pdf->SetXY($this->col[5], $this->y_offset);
        $this->pdf->Cell($this->shade_width[5], 10, "(Fr.)", 0, 0, 'R');
        $this->pdf->SetFont('', '', 10);

        $this->y_offset = $this->y_offset + 1.25 * $this->line_break;
//-- MG.16.02.2011 -->

        if ($this->spesen['bolListFirstDay']) {
            $this->pdf->SetFont('', 'B');
            $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
            $this->pdf->Cell(3, 10, strval($this->spesen['intFirstDays']), 0, 0, 'R', false, '', true);
            $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
            $this->pdf->Cell(0, 10, "Erster Arbeitstag");
            $this->pdf->SetFont('', '');
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_pocket'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_accommodation'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_firstday_breakfast_expenses'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_firstday_lunch_expenses'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_firstday_dinner_expenses'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['intFirstDays'] * $this->spesen['firstday_sum']), 0, 0, 'R', 1);
            $this->y_offset = $this->y_offset + $this->line_break;
        }

        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, strval($this->spesen['arbeitstage']), 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->spesen['arbeitstage'] == 1) {
            $this->pdf->Cell(0, 10, "Arbeitstag");
        } else {
            $this->pdf->Cell(0, 10, "Arbeitstage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_pocket'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_accommodation'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_working_breakfast_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_working_lunch_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_working_dinner_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['arbeitstage'] * $this->spesen['workday_sum']), 0, 0, 'R', 1);
        $this->y_offset = $this->y_offset + $this->line_break;

        if ($this->spesen['bolListLastDay']) {
            $this->pdf->SetFont('', 'B');
            $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
            $this->pdf->Cell(3, 10, strval($this->spesen['intLastDays']), 0, 0, 'R', false, '', true);
            $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
            $this->pdf->Cell(0, 10, "Letzter Arbeitstag");
            $this->pdf->SetFont('', '');
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_pocket'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_accommodation'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_lastday_breakfast_expenses'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_lastday_lunch_expenses'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_lastday_dinner_expenses'] / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['intLastDays'] * $this->spesen['lastday_sum']), 0, 0, 'R', 1);
            $this->y_offset = $this->y_offset + $this->line_break;
        }
//<-- MG.16.02.2011 --
        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, strval($this->spesen['arbeitsfreie_tage']), 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->spesen['arbeitsfreie_tage'] == 1) {
            $this->pdf->Cell(0, 10, "Arbeitsfreier Tag");
        } else {
            $this->pdf->Cell(0, 10, "Arbeitsfreie Tage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_pocket'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_accommodation'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_breakfast_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_lunch_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_dinner_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['total_workfree']), 0, 0, 'R', 1);

        $n_comments = 0;
        if (!empty($feiertage_comment)) {
            $this->pdf->SetFont('', 'I', 8);
            $this->y_offset = $this->y_offset + $this->comment_line_break;
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            $str = "inkl. " . $feiertage_comment;
            $w = $this->pdf->GetStringWidth($str) + 4;
            if ($w > 120) {
                $w = 120;
            }
            $this->pdf->Cell($w, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
            $n_comments++;
        }

        if ($this->spesen['add_workfree'] >= 1) {
            $this->pdf->SetFont('', 'I', 8);
            if ($n_comments == 0) {
                $this->y_offset = $this->y_offset + $this->comment_line_break;
            } else {
                $this->y_offset = $this->y_offset + $this->comment_line_break2;
            }
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            $str = "inkl. " . $this->spesen['add_workfree'];
            if ($this->spesen['add_workfree'] == 1) {
                $str = $str . " zusätzlicher arbeitsfreier Tag";
            } else {
                $str = $str . " zusätzliche arbeitsfreie Tage";
            }
            if (!empty($this->spesen['meldeblaetter_add_workfree_comment'])) {
                $str = $str . " (" . $this->spesen['meldeblaetter_add_workfree_comment'] . ")";
            } else {
                $str = $str . ".";
            }
            $w = $this->pdf->GetStringWidth($str) + 4;
            if ($w > 120) {
                $w = 120;
            }
            $this->pdf->Cell($w, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
            $n_comments++;
        }

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, $this->spesen['krankheitstage'], 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->spesen['krankheitstage'] == 1) {
            $this->pdf->Cell(0, 10, "Krankheitstag");
        } else {
            $this->pdf->Cell(0, 10, "Krankheitstage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_pocket'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_accommodation'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_breakfast_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_lunch_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_dinner_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['total_ill']), 0, 0, 'R', 1);

        if (!empty($this->spesen['meldeblaetter_ill_comment'])) {
            $this->pdf->SetFont('', 'I', '8');
            $this->y_offset = $this->y_offset + $this->comment_line_break;
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            $str = "Bemerkung: " . $this->spesen['meldeblaetter_ill_comment'];
            $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
        }

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, $this->spesen['ferientage'], 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->spesen['ferientage'] == 1) {
            $this->pdf->Cell(0, 10, "Ferientag");
        } else {
            $this->pdf->Cell(0, 10, "Ferientage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_pocket'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_accommodation'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_breakfast_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_lunch_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->spesen['pflichtenheft_sparetime_dinner_expenses'] / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['total_holiday']), 0, 0, 'R', 1);

        if (!empty($this->spesen['meldeblaetter_holiday_comment'])) {
            $this->pdf->SetFont('', 'I', 8);
            $this->y_offset = $this->y_offset + $this->comment_line_break;
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            $str = "Bemerkung: " . $this->spesen['meldeblaetter_holiday_comment'];
            $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
        }

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, $this->spesen['urlaubstage'], 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->spesen['urlaubstage'] == 1) {
            $this->pdf->Cell(0, 10, "Urlaubstag");
        } else {
            $this->pdf->Cell(0, 10, "Urlaubstage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, "0.00", 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, "0.00", 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, "0.00", 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, "0.00", 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, "0.00", 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, "0.00", 0, 0, 'R', 1);

        $n_comments = 0;
        if (!empty($urlaub_comment)) {
            $this->pdf->SetFont('', 'I', 8);
            $this->y_offset = $this->y_offset + $this->comment_line_break;
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            $str = "inkl. " . $urlaub_comment;
            if ($this->spesen['meldeblaetter_companyurlaub'] == 1) {
                $str .= " (" . $this->spesen['meldeblaetter_companyurlaub'] . " Tag)";
            } else {
                $str .= " (" . $this->spesen['meldeblaetter_companyurlaub'] . " Tage)";
            }
            $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
            $n_comments++;
        }

        if (!empty($this->spesen['meldeblaetter_urlaub_comment'])) {
            $this->pdf->SetFont('', 'I', 8);
            if ($n_comments == 0) {
                $this->y_offset = $this->y_offset + $this->comment_line_break;
            } else {
                $this->y_offset = $this->y_offset + $this->comment_line_break2;
            }
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            $str = "inkl. " . $this->spesen['meldeblaetter_urlaub_comment'];
            if ($this->spesen['meldeblaetter_urlaub'] == 1) {
                $str .= " (" . $this->spesen['meldeblaetter_urlaub'] . " Tag)";
            } else {
                $str .= " (" . $this->spesen['meldeblaetter_urlaub'] . " Tage)";
            }
            $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
            $n_comments++;
        }

        $this->y_offset = $this->y_offset + $this->line_break;

// FAHRSPESEN //
        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, "+", 0, 0, 'R');
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        $this->pdf->Cell(0, 10, "Fahrspesen");
        $this->pdf->SetFont('', '', 10);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['meldeblaetter_fahrspesen']), 0, 0, 'R', 1);
        $str = $this->spesen['meldeblaetter_fahrspesen_comment'];
        if (empty($this->spesen['meldeblaetter_fahrspesen'])
            & empty($this->spesen['meldeblaetter_fahrspesen_comment'])) {
            $str = "Keine Angaben.";
        }
        if (!empty($str)) {
            $this->pdf->SetFont('', 'I', 8);
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
        }


        $this->y_offset = $this->y_offset + $this->line_break;

        // ARBEITSKLEIDER SPESEN //
        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, "+", 0, 0, 'R');
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        $this->pdf->Cell(0, 10, "Arbeitskleider");
        $this->pdf->SetFont('', 'I', 8);
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        if ($this->spesen['arbeitskleider_tage'] == 1) {
            //$str = "Für " . $arbeitskleider_tage . " anrechenbarer Tag (Fr. 60.- pro 26 Tage / max. Fr. 240.- total)";
            $str = "CHF " . $this->getRoundedRappen($this->spesen['pflichtenheft_clothes_expense'] / 100) . "/Tag für " . $this->spesen['arbeitskleider_tage'] . " anrechenbaren Tag";
        } else {
            //$str = "Für " . $arbeitskleider_tage . " anrechenbare Tage (Fr. 60.- pro 26 Tage / max. Fr. 240.- total)";
            $str = "CHF " . $this->getRoundedRappen($this->spesen['pflichtenheft_clothes_expense'] / 100) . "/Tag für " . $this->spesen['arbeitskleider_tage'] . " anrechenbare Tage";
        }
        $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
        $this->pdf->SetFont('', '', 10);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['total_arbeitskleider']), 0, 0, 'R', 1);

        if ($this->spesen['meldeblaetter_kleider'] == 240) {
            $this->pdf->SetFont('', 'I', 8);
            $this->y_offset = $this->y_offset + $this->comment_line_break;
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            $str = "Das Maximum von ausbezahlten Fr. 240.- wurde erreicht.";
            $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
        }

        $this->y_offset = $this->y_offset + $this->line_break;

// AUSSERORDENTLICHE SPESEN //
        if (!empty($this->spesen['meldeblaetter_ausserordentlich'])) {
            $this->pdf->SetFont('', 'B');
            $this->pdf->SetXY($this->left_margin+3, $this->y_offset);
            $this->pdf->Cell(3, 10, "+", 0, 0, 'R');
            $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
            $this->pdf->Cell(0, 10, "Ausserordentlich");
            $this->pdf->SetFont('', '');

            if (!empty($this->spesen['meldeblaetter_ausserordentlich_comment'])) {
                $this->pdf->SetFont('', 'I', 8);
                $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
                $str = $this->spesen['meldeblaetter_ausserordentlich_comment'];
                $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
                $this->pdf->SetFont('', '', 10);
            }

            $this->pdf->SetXY($this->col[5], $this->y_offset+$this->shade_height/2);
            $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->spesen['meldeblaetter_ausserordentlich']), 0, 0, 'R', 1);
            $this->y_offset = $this->y_offset + $this->line_break;
        }

        $this->y_offset = $this->y_offset + $this->line_break;

// GESAMT //
        $this->pdf->SetFont('', 'B', '10');
        $this->pdf->SetXY($this->col[4], $this->y_offset);
        $this->pdf->Cell(0, 10, "Gesamt:");
        $this->pdf->SetXY($this->col[5], $this->y_offset);
        $this->pdf->Cell($this->shade_width[5], 10, $this->getRoundedRappen($this->spesen['total']), 0, 0, 'R', 0);
        $this->pdf->SetLineWidth(0.2);
        $ll = $this->shade_width[4] + $this->shade_width[5] + 2;
        $this->pdf->Line($this->col[4], $this->y_offset, $this->col[4] + $ll, $this->y_offset);
        $this->pdf->SetLineWidth(.4);
        $this->pdf->Line($this->col[4], $this->y_offset + $this->line_break + 2, $this->col[4] + $ll, $this->y_offset + $this->line_break + 2);
        $this->pdf->Line($this->col[4], $this->y_offset + $this->line_break + 3, $this->col[4] + $ll, $this->y_offset + $this->line_break + 3);
        $this->pdf->SetLineWidth(0.2);

        $this->y_offset = $this->y_offset + 15;

        $this->pdf->SetFont('', 'B', '10');
        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Bankverbindung:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $str = "";
        if ($this->user["bank_iban"] != '') {
            $str .= $this->user["bank_iban"] . "\n";
            $this->additional_offset += 5;
        }
        $this->pdf->MultiCell($this->bank_shade_width, $this->shade_height, $str, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break + $this->additional_offset - 5;

        $this->pdf->SetFont('', 'B', '10');
        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Konto-Nr.:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->SetFont('', '', '10');
        $this->pdf->Cell($this->bank_shade_width, $this->shade_height, $this->spesen['bank_account_number'], 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', 'B', '10');
        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Beleg-Nr.:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->SetFont('', '', '10');
        $this->pdf->Cell($this->bank_shade_width, $this->shade_height, $this->spesen['document_number'], 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break*2;

        if ($this->y_offset > 250) {
            $this->pdf->AddPage();
            $this->y_offset = 15;
        } elseif ($this->y_offset > 240 && $this->y_offset < 250) {
            $this->y_offset = $this->y_offset + 10;
        } else {
            $this->y_offset = $this->y_offset + 20;
        }


        $this->pdf->SetFont('', '', '10');
        $this->pdf->SetXY($this->col[0], $this->y_offset);
        $this->pdf->Cell(0, 10, "Einsatz- & Projektleitung");

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', '', '10');
        $this->pdf->SetDrawColor(0, 0, 0);
        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Unterschrift / Datum:");

        $this->pdf->SetXY($this->col[0], $this->y_offset);
        $str = CompanyInfo::COMPANY_NAME_SHORT . ":";
        $line_x1 = $this->col[0] + $this->pdf->GetStringWidth($str) + 4;
        $line_y = $this->y_offset + $this->line_break;
        $this->pdf->Cell(0, 10, $str);
        $this->pdf->Line($line_x1, $line_y, $this->col[3] - 5, $line_y);

        $this->pdf->SetXY($this->col[3], $this->y_offset);
        $str = "Datum:";
        $line_x1 = $this->col[3] + $this->pdf->GetStringWidth($str) + 4;
        $line_y = $this->y_offset + $this->line_break;
        $this->pdf->Cell(0, 10, $str);
        $this->pdf->Line($line_x1, $line_y, $this->col[5] + $this->shade_width[5], $line_y);
        // $this->pdf->SetXY($line_x1 + 10, $this->y_offset);
        // $this->pdf->Cell(0, 10, date("d.m.Y"));
    }
}
