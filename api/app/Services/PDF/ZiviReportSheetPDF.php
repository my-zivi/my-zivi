<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 7/26/17
 * Time: 8:53 AM
 */

namespace App\Services\PDF;

use App\CompanyInfo;
use App\ReportSheet;

class ZiviReportSheetPDF extends PDF
{

    private $left_margin = 25;              // Abstand zum linken Seitenrand
    private $y_offset = 15;                 // Allgemeiner "Item-Abstand"
    private $line_break = 7;                // Zeilenabstand zwischen Hauptzeilen
    private $comment_line_break = 6.5;      // Abstand zwischen Hauptzeile und Kommentar
    private $comment_line_break2 = 5;       // Abstand zwischen zwei Kommentaren
    private $shade_height = 5;              // Höhe der Hintergrundbox für normale Zeilen
    private $shade_height8 = 4;             // Höhe der Hintergrundbox für Kommentarzeilen
    private $overview_shade_width = 110;
    private $bank_shade_width = 125;
    private $additional_offset = 5;
    private $max_rendered_comment_lines = 2;

    private $col = array(65, 90, 113, 131, 149, 168);
    private $shade_width = array(24, 22, 17, 17, 17, 22);
    private $col_title = array("Taschengeld", "Unterkunft", "Morgen", "Mittag", "Abend", "Total");

    private $user;
    private $reportSheet;
    private $specification;

    public function __construct($reportSheetId)
    {
        parent::__construct();

        $this->reportSheet = ReportSheet::find($reportSheetId);
        $this->user = $this->reportSheet->user;
        $this->specification = $this->reportSheet->mission->specification;
    }

    public function getUserId()
    {
        return $this->user->id;
    }

    // TODO remove this from here when we rewrite the PDF generation
    public function isDone()
    {
        return $this->reportSheet->state == 3;
    }

    private function renderComment($comment, $start_on_current_line = false)
    {
        $this->pdf->SetFont('', 'I', 8);
        $comment_width = $this->pdf->GetStringWidth($comment) + 4;

        if (!$start_on_current_line) {
            $this->y_offset = $this->y_offset + $this->comment_line_break;
        }

        // Check if comment does not exceed one line
        if ((!$start_on_current_line && $comment_width < $this->bank_shade_width) || ($start_on_current_line && $comment_width < 100)) {
            if ($start_on_current_line) {
                $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
            } else {
                $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            }
            $this->pdf->Cell($comment_width, $this->shade_height8, $comment, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
            return;
        }

        if ($start_on_current_line) {
            $comment_chunks = str_split($comment, 70);
        } else {
            $comment_chunks = str_split($comment, 95);
        }

        for ($i = 0; $i < $this->max_rendered_comment_lines; $i++) {
            if ($i !== 0) {
                $this->y_offset = $this->y_offset + $this->comment_line_break2;
            }
            if ($start_on_current_line) {
                $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
            } else {
                $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            }
            $this->pdf->Cell($this->pdf->GetStringWidth($comment_chunks[$i]) + 4, $this->shade_height8, $comment_chunks[$i], 0, 0, '', 1);
        }

        $this->pdf->SetFont('', '', 10);
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
        if ($this->reportSheet->duration != $this->reportSheet->charged_days) {
            $warn_str .= "Summe der Tage ist falsch! ";
        }
        if ($this->reportSheet->work < 0) {
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
        $str = $this->specification->id . " " . $this->specification->name;
        $this->pdf->Cell($this->overview_shade_width, $this->shade_height, $str, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Name, Vorname:");
        $this->pdf->SetFont('Arial', 'B', 10);
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $str = $this->user->last_name . " " . $this->user->first_name;
        $this->pdf->Cell($this->overview_shade_width, $this->shade_height, $str, 0, 0, '', 1);
        $this->pdf->SetFont('Arial', '', 10);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Adresse:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $str = $this->user->address . ", " . $this->user->zip . " " . $this->user->city;
        $this->pdf->Cell($this->overview_shade_width, $this->shade_height, $str, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "ZDP:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->overview_shade_width, $this->shade_height, $this->user->zdp, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Gesamteinsatz:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $str = $this->getGermanDate($this->reportSheet->mission->start->timestamp) . " bis ";
        $str .= $this->getGermanDate($this->reportSheet->mission->end->timestamp);
        $str .= " (" . $this->reportSheet->mission->days . " Tage)";
        $this->pdf->Cell($this->overview_shade_width, $this->shade_height, $str, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Meldeperiode:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->SetFont('Arial', 'B', 10);
        $str = $this->getGermanDate($this->reportSheet->start->timestamp) . " bis ";
        $str .= $this->getGermanDate($this->reportSheet->end->timestamp);
        $str .= " (" . $this->reportSheet->duration . " Tage)";
        $this->pdf->Cell($this->overview_shade_width, $this->shade_height, $str, 0, 0, '', 1);

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

        if (!$this->reportSheet->ignore_first_last_day) {
            $this->pdf->SetFont('', 'B');
            $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
            $this->pdf->Cell(3, 10, strval($this->reportSheet->first_day), 0, 0, 'R', false, '', true);
            $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
            $this->pdf->Cell(0, 10, "Erster Arbeitstag");
            $this->pdf->SetFont('', '');
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->specification->pocket / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->specification->accomodation / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->specification->firstday_breakfast_expenses / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->specification->firstday_lunch_expenses / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->specification->firstday_dinner_expenses / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->first_day_costs / 100), 0, 0, 'R', 1);
            $this->y_offset = $this->y_offset + $this->line_break;
        }

        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, strval($this->reportSheet->normal_work_days), 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->reportSheet->work == 1) {
            $this->pdf->Cell(0, 10, "Arbeitstag");
        } else {
            $this->pdf->Cell(0, 10, "Arbeitstage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->specification->pocket / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->specification->accomodation / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->specification->working_breakfast_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->specification->working_lunch_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->specification->working_dinner_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->work_days_costs / 100), 0, 0, 'R', 1);
        $this->y_offset = $this->y_offset + $this->line_break;

        if (!$this->reportSheet->ignore_first_last_day) {
            $this->pdf->SetFont('', 'B');
            $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
            $this->pdf->Cell(3, 10, strval($this->reportSheet->last_day), 0, 0, 'R', false, '', true);
            $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
            $this->pdf->Cell(0, 10, "Letzter Arbeitstag");
            $this->pdf->SetFont('', '');
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->specification->pocket / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->specification->accomodation / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->specification->lastday_breakfast_expenses / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->specification->lastday_lunch_expenses / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->specification->lastday_dinner_expenses / 100), 0, 0, '', 1);
            $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->last_day_costs / 100), 0, 0, 'R', 1);
            $this->y_offset = $this->y_offset + $this->line_break;
        }

//<-- MG.16.02.2011 --
        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, strval($this->reportSheet->workfree + $this->reportSheet->additional_workfree), 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->reportSheet->workfree + $this->reportSheet->additional_workfree == 1) {
            $this->pdf->Cell(0, 10, "Arbeitsfreier Tag");
        } else {
            $this->pdf->Cell(0, 10, "Arbeitsfreie Tage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->specification->pocket / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->specification->accomodation / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_breakfast_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_lunch_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_dinner_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->work_free_days_costs / 100), 0, 0, 'R', 1);

        $n_comments = 0;
        if (!empty($feiertage_comment)) {
            $str = "inkl. " . $feiertage_comment;
            $this->renderComment($str);
            $n_comments++;
        }

        if ($this->reportSheet->additional_workfree >= 1) {
            $str = "inkl. " . $this->reportSheet->additional_workfree;
            if ($this->reportSheet->additional_workfree == 1) {
                $str = $str . " zusätzlicher arbeitsfreier Tag";
            } else {
                $str = $str . " zusätzliche arbeitsfreie Tage";
            }
            if (!empty($this->reportSheet->additional_workfree_comment)) {
                $str = $str . " (" . $this->reportSheet->additional_workfree_comment . ")";
            } else {
                $str = $str . ".";
            }
            $this->renderComment($str);
        }

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, $this->reportSheet->ill, 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->reportSheet->ill == 1) {
            $this->pdf->Cell(0, 10, "Krankheitstag");
        } else {
            $this->pdf->Cell(0, 10, "Krankheitstage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->specification->pocket / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->specification->accomodation/ 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_breakfast_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_lunch_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_dinner_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->ill_days_costs / 100), 0, 0, 'R', 1);

        if (!empty($this->reportSheet->ill_comment)) {
            $str = "Bemerkung: " . $this->reportSheet->ill_comment;
            $this->renderComment($str);
        }

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, $this->reportSheet->holiday + $this->reportSheet->company_holiday_holiday, 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->reportSheet->holiday + $this->reportSheet->company_holiday_holiday == 1) {
            $this->pdf->Cell(0, 10, "Ferientag");
        } else {
            $this->pdf->Cell(0, 10, "Ferientage");
        }
        $this->pdf->SetFont('', '');
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[0], $this->shade_height, $this->getRoundedRappen($this->specification->pocket / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[1], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[1], $this->shade_height, $this->getRoundedRappen($this->specification->accomodation/ 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[2], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[2], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_breakfast_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[3], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[3], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_lunch_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[4], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[4], $this->shade_height, $this->getRoundedRappen($this->specification->sparetime_dinner_expenses / 100), 0, 0, '', 1);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->holidays_costs / 100), 0, 0, 'R', 1);

        if (!empty($this->reportSheet['meldeblaetter_holiday_comment'])) {
            $str = "Bemerkung: " . $this->reportSheet['meldeblaetter_holiday_comment'];
            $this->renderComment($str);
        }

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', 'B');
        $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
        $this->pdf->Cell(3, 10, $this->reportSheet->vacation + $this->reportSheet->company_holiday_vacation, 0, 0, 'R', false, '', true);
        $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
        if ($this->reportSheet->vacation + $this->reportSheet->company_holiday_vacation == 1) {
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

        if (!empty($this->reportSheet->company_holiday_vacation)) {
            $str = "inkl. " . $this->reportSheet->company_holiday_vacation;
            if ($this->reportSheet->company_holiday_holiday == 1) {
                $str .= " (" . $this->reportSheet->company_holiday_vacation . " Tag)";
            } else {
                $str .= " (" . $this->reportSheet->company_holiday_vacation . " Tage)";
            }
            $this->renderComment($str);
        }

        if (!empty($this->reportSheet->vacation_comment)) {
            $str = "inkl. " . $this->reportSheet->vacation_comment;
            if ($this->reportSheet->vacation == 1) {
                $str .= " (" . $this->reportSheet->vacation . " Tag)";
            } else {
                $str .= " (" . $this->reportSheet->vacation . " Tage)";
            }
            $this->renderComment($str);
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
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->driving_charges), 0, 0, 'R', 1);

        $str = $this->reportSheet->driving_charges_comment;
        if (empty($this->reportSheet->driving_charges)
            & empty($this->reportSheet->driving_charges_comment)) {
            $str = "Keine Angaben.";
        }
        if (!empty($str)) {
            $this->renderComment($str, true);
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
        if ($this->reportSheet->clothes_days == 1) {
            $str = "CHF " . $this->getRoundedRappen($this->specification->working_clothes_expense / 100) . "/Tag für " . $this->reportSheet->clothes_days . " anrechenbaren Tag";
        } else {
            $str = "CHF " . $this->getRoundedRappen($this->specification->working_clothes_expense / 100) . "/Tag für " . $this->reportSheet->clothes_days . " anrechenbare Tage";
        }
        $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
        $this->pdf->SetFont('', '', 10);
        $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
        $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->clothes / 100), 0, 0, 'R', 1);

        if ($this->reportSheet->clothes == 24000) {
            $this->pdf->SetFont('', 'I', 8);
            $this->y_offset = $this->y_offset + $this->comment_line_break;
            $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height8 / 2);
            $str = "Das Maximum von ausbezahlten Fr. 240.- wurde erreicht.";
            $this->pdf->Cell($this->pdf->GetStringWidth($str) + 4, $this->shade_height8, $str, 0, 0, '', 1);
            $this->pdf->SetFont('', '', 10);
        }

        $this->y_offset = $this->y_offset + $this->line_break;

// AUSSERORDENTLICHE SPESEN //
        if (!empty($this->reportSheet->extraordinarily)) {
            $this->pdf->SetFont('', 'B');
            $this->pdf->SetXY($this->left_margin + 3, $this->y_offset);
            $this->pdf->Cell(3, 10, "+", 0, 0, 'R');
            $this->pdf->SetXY($this->left_margin + 6, $this->y_offset);
            $this->pdf->Cell(0, 10, "Ausserordentlich");
            $this->pdf->SetFont('', '');

            $this->pdf->SetXY($this->col[5], $this->y_offset + $this->shade_height / 2);
            $this->pdf->Cell($this->shade_width[5], $this->shade_height, $this->getRoundedRappen($this->reportSheet->extraordinarily / 100), 0, 0, 'R', 1);

            if (!empty($this->reportSheet->extraordinarily_comment)) {
                $str = $this->reportSheet->extraordinarily_comment;
                $this->renderComment($str, true);
            }
            $this->y_offset = $this->y_offset + $this->line_break;
        }

        $this->y_offset = $this->y_offset + $this->line_break;

// GESAMT //
        $this->pdf->SetFont('', 'B', '10');
        $this->pdf->SetXY($this->col[4], $this->y_offset);
        $this->pdf->Cell(0, 10, "Gesamt:");
        $this->pdf->SetXY($this->col[5], $this->y_offset);
        $this->pdf->Cell($this->shade_width[5], 10, $this->getRoundedRappen($this->reportSheet->total_costs / 100), 0, 0, 'R', 0);
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
        if ($this->user->bank_iban != '') {
            $str .= $this->user->bank_iban . "\n";
            $this->additional_offset += 5;
        }
        $this->pdf->MultiCell($this->bank_shade_width, $this->shade_height, $str, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break + $this->additional_offset - 5;

        $this->pdf->SetFont('', 'B', '10');
        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Konto-Nr.:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->SetFont('', '', '10');
        $this->pdf->Cell($this->bank_shade_width, $this->shade_height, $this->reportSheet->bank_account_number, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break;

        $this->pdf->SetFont('', 'B', '10');
        $this->pdf->SetXY($this->left_margin, $this->y_offset);
        $this->pdf->Cell(0, 10, "Beleg-Nr.:");
        $this->pdf->SetXY($this->col[0], $this->y_offset + $this->shade_height / 2);
        $this->pdf->SetFont('', '', '10');
        $this->pdf->Cell($this->bank_shade_width, $this->shade_height, $this->reportSheet->document_number, 0, 0, '', 1);

        $this->y_offset = $this->y_offset + $this->line_break * 2;

        if ($this->y_offset > 250) {
            $this->pdf->AddPage();
            $this->y_offset = 15;
        } else {
            $this->y_offset = 250;
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
