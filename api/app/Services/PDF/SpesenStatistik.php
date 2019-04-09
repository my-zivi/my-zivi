<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 8/3/17
 * Time: 9:30 AM
 */

namespace App\Services\PDF;

use App\CompanyInfo;
use App\ReportSheet;
use Carbon\Carbon;

class SpesenStatistik extends PDF
{

    private $time_type;
    private $time_from;
    private $time_to;
    private $time_year;
    private $showOnlyDoneSheets;
    private $showDetails;


    private $TITLE_GESAMT;
    private $TITLE_DETAIL;


    private $OFFSET_Y;


    private $PAGE_WIDTH = 210;
    private $PAGE_HEIGHT = 297;
    private $PAGE_WIDTH_L = 297;
    private $PAGE_HEIGHT_L = 210;
    private $MARGIN_LEFT = 15;
    private $MARGIN_RIGHT = 15;
    private $MARGIN_TOP = 15;
    private $MARGIN_BOTTOM = 15;
    private $FONT = 'Arial';
    private $FONT_SIZE_LARGE = 14;
    private $FONT_SIZE_NORMAL = 12;
    private $FONT_SIZE_SMALL = 9;
    private $FONT_SIZE_TINY = 7;
    private $FONT_SIZE_TITLE = 16;
    private $TITLE_BOX_COLOR_R = 210;
    private $TITLE_BOX_COLOR_G = 240;
    private $TITLE_BOX_COLOR_B = 230;
    private $TITLE_BOX_HEIGHT = 10;

    private $LINE_BREAK;
    private $LINE_BREAK_ROW2ROW;
    private $LINE_BREAK_HEADER;
    private $TAB1_X;
    private $TAB2_X;
    private $TAB_WIDTH;
    private $COL1_X;
    private $COL2_X;
    private $COL3_X;
    private $COL_WIDTH;

    private $SHADE_SPACE;
    private $WEIGHT_TAGE;
    private $WEIGHT_FR;
    private $SHADE_HEIGHT_TABLE;
    private $FONT_WEAK_R;
    private $FONT_WEAK_B;
    private $ROW_COLOR_R;
    private $ROW_COLOR_G;
    private $ROW_COLOR_B;
    private $LBL_COLOR_R;
    private $LBL_COLOR_G;
    private $LBL_COLOR_B;
    private $ROW_COLOR_WEAK_R;
    private $ROW_COLOR_WEAK_G;
    private $ROW_COLOR_WEAK_B;
    private $SUBTOTAL_COLOR_R;
    private $SUBTOTAL_COLOR_G;
    private $SUBTOTAL_COLOR_B;


    public function __construct($showOnlyDoneSheets, $showDetails, $time_type, $time_from, $time_to, $time_year)
    {
        parent::__construct();

        $this->showOnlyDoneSheets = $showOnlyDoneSheets;
        $this->showDetails = $showDetails;
        $this->time_type = $time_type;
        $this->time_year = $time_year;
        $this->time_from = Carbon::parse($time_from);
        $this->time_to = Carbon::parse($time_to);
    }

    protected function render()
    {

        if ($this->time_type == 1) {
            $start_TS = Carbon::parse($this->time_from);
            $end_TS = Carbon::parse($this->time_to);
            $period = $start_TS->format('d.m.y') . " - " . $end_TS->format('d.m.y');
            $this->TITLE_GESAMT = "  Zivi-Spesen Gesamtstatistik  (Zeitperiode: $period)";
            $this->TITLE_DETAIL = "  Zivi-Spesen Detailübersicht  (Zeitperiode: $period)";
        } elseif ($this->time_type == 2) {
            $start_TS = (new Carbon())->startOfMonth();
            $end_TS = (new Carbon())->endOfMonth();
            $period = $this->getGermanMonth($start_TS->format('m')) . " " . $start_TS->format('Y');
            $this->TITLE_GESAMT = "  Zivi-Spesen Gesamtstatistik  (Aktive Zivis - $period)";
            $this->TITLE_DETAIL = "  Zivi-Spesen Detailübersicht  (Aktive Zivis - $period)";
        } elseif ($this->time_type == 3) {
            $start_TS = (new Carbon())->subMonth()->startOfMonth();
            $end_TS = (new Carbon())->subMonth()->endOfMonth();
            $period = $this->getGermanMonth($start_TS->format('m')) . " " . $start_TS->format('Y');
            $this->TITLE_GESAMT = "  Zivi-Spesen Gesamtstatistik  (Aktive Zivis - $period)";
            $this->TITLE_DETAIL = "  Zivi-Spesen Detailübersicht  (Aktive Zivis - $period)";
        } else {
            $start_TS = Carbon::createFromDate($this->time_year, 01, 01);
            $end_TS = Carbon::createFromDate($this->time_year, 12, 31);
            $this->TITLE_GESAMT = "  Zivi-Spesen Gesamtstatistik  (Jahr $this->time_year)";
            $this->TITLE_DETAIL = "  Zivi-Spesen Detailübersicht  (Jahr $this->time_year)";
        }
        $this->pdf->SetAutoPageBreak(false);

        if ($this->showDetails) {
            $this->generateDetailStatistik($start_TS, $end_TS);
        } else {
            $this->generateGesamtStatistik($start_TS, $end_TS);
        }
    }

    private function generateGesamtStatistik($start_TS, $end_TS)
    {
        $this->pdf->AddPage();

        $this->LINE_BREAK = 15;
        $this->LINE_BREAK_ROW2ROW = 10;
        $this->LINE_BREAK_HEADER = 6;
        $this->TAB1_X = $this->MARGIN_LEFT + 5;
        $this->TAB2_X = $this->MARGIN_LEFT + 40;
        $this->TAB_WIDTH = 10;
        $this->COL1_X = $this->MARGIN_LEFT + 5;
        $this->COL2_X = $this->MARGIN_LEFT + 40;
        $this->COL3_X = $this->MARGIN_LEFT + 95;
        $this->COL_WIDTH = 80;

        $this->OFFSET_Y = $this->MARGIN_TOP;

        $meldeblaetter = $this->getMeldeblaetterInPeriod($start_TS, $end_TS);
        $num_zivis = $this->countNumberOfZivis($meldeblaetter);

        $sum_tage = $this->generateEmptyGeldOrTageArray();

        $sum_geld = $this->generateEmptyGeldOrTageArray();

        foreach ($meldeblaetter as $blatt) {
            $ret = $this->getSpesenDetails($blatt['id']);

            $tage = $ret['tage'];
            $geld = $ret['geld'];

            foreach ($tage as $key => $value) {
                $sum_tage[$key] += $tage[$key];
            }
            foreach ($geld as $key => $value) {
                $sum_geld[$key] += $geld[$key];
            }
        }

        // Zeichne das Titelfeld //
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_TITLE);
        $this->pdf->SetFillColor($this->TITLE_BOX_COLOR_R, $this->TITLE_BOX_COLOR_G, $this->TITLE_BOX_COLOR_B);
        $this->pdf->SetXY($this->MARGIN_LEFT, $this->OFFSET_Y);
        $this->pdf->Cell(
            $this->PAGE_WIDTH - $this->MARGIN_LEFT - $this->MARGIN_RIGHT,
            $this->TITLE_BOX_HEIGHT,
            $this->TITLE_GESAMT,
            1,
            0,
            "",
            1
        );

        $this->OFFSET_Y += $this->LINE_BREAK * 1.5;

        // Drucke Bemerkung, ob alle Meldeblätter angezeigt werden oder nur erledigte //
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_SMALL);
        $this->pdf->SetXY($this->TAB1_X, $this->OFFSET_Y);
        if ($this->showOnlyDoneSheets) {
            $str = "Statistik basiert auf allen erledigten Meldeblättern.";
        } else {
            $str = "Statistik basiert auf allen Meldeblättern (erledigte und pendente).";
        }
        $this->pdf->Cell($this->TAB_WIDTH, 0, $str, 0, 0, 'L');

        //Print header Statistics //
        $this->OFFSET_Y += $this->LINE_BREAK_HEADER;
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_SMALL);
        $this->pdf->SetXY($this->TAB1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->TAB_WIDTH, 0, "Anzahl aktiver Zivis:");
        $this->pdf->SetXY($this->TAB2_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->TAB_WIDTH, 0, strval($num_zivis), 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_HEADER;
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_SMALL);
        $this->pdf->SetXY($this->TAB1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->TAB_WIDTH, 0, "Anzahl Meldeblätter:");
        $this->pdf->SetXY($this->TAB2_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->TAB_WIDTH, 0, strval(count($meldeblaetter)), 0, 0, 'R');

        $this->OFFSET_Y += $this->LINE_BREAK;

        // Zeichne die Summen-Tabelle //
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL2_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Anzahl Tage", 0, 0, 'R');
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Spesen (Fr.)", 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->Line($this->COL1_X, $this->OFFSET_Y, $this->COL3_X + $this->COL_WIDTH, $this->OFFSET_Y);
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Arbeitstage:");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL2_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, strval($sum_tage['arbeitstage']), 0, 0, 'R');
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $this->getRoundedRappen($sum_geld['arbeitstage']), 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Arbeitsfreie Tage:");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL2_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, strval($sum_tage['arbeitsfreietage']), 0, 0, 'R');
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $this->getRoundedRappen($sum_geld['arbeitsfreietage']), 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Krankheitstage:");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL2_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, strval($sum_tage['krankheitstage']), 0, 0, 'R');
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $this->getRoundedRappen($sum_geld['krankheitstage']), 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Ferientage:");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL2_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, strval($sum_tage['ferientage']), 0, 0, 'R');
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $this->getRoundedRappen($sum_geld['ferientage']), 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Urlaubstage:");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL2_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, strval($sum_tage['urlaubstage']), 0, 0, 'R');
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $this->getRoundedRappen($sum_geld['urlaubstage']), 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW / 2 + 2;
        $this->pdf->Line($this->COL1_X, $this->OFFSET_Y, $this->COL3_X + $this->COL_WIDTH, $this->OFFSET_Y);
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW / 2 + 2;
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Fahrspesen:");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $this->getRoundedRappen($sum_geld['fahrspesen']), 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Arbeitskleider:");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $this->getRoundedRappen($sum_geld['arbeitskleider']), 0, 0, 'R');
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Ausserordentlich:");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_NORMAL);
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $this->getRoundedRappen($sum_geld['ausserordentlich']), 0, 0, 'R');

        // Print underlined Total //
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->Line($this->COL1_X, $this->OFFSET_Y, $this->COL3_X + $this->COL_WIDTH, $this->OFFSET_Y);
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_LARGE);
        $this->pdf->SetXY($this->COL1_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, "Total:", 0, 0, 'L');
        $str = $this->getRoundedRappen($sum_geld['sum']);
        $str_w = $this->pdf->GetStringWidth($str);
        $this->pdf->SetXY($this->COL3_X, $this->OFFSET_Y);
        $this->pdf->Cell($this->COL_WIDTH, 0, $str, 0, 0, 'R');
        $this->pdf->SetLineWidth(0.4);
        $this->pdf->Line($this->COL3_X + $this->COL_WIDTH - $str_w - 1, $this->OFFSET_Y + 3, $this->COL3_X + $this->COL_WIDTH - 1, $this->OFFSET_Y + 3);
        $this->pdf->Line($this->COL3_X + $this->COL_WIDTH - $str_w - 1, $this->OFFSET_Y + 4, $this->COL3_X + $this->COL_WIDTH - 1, $this->OFFSET_Y + 4);
    }

    private function generateDetailStatistik($start_TS, $end_TS)
    {

        $this->pdf->AddPage('L');

        $this->LINE_BREAK_HEADER = 6;
        $this->LINE_BREAK_ROW2ROW = 4;
        $this->SHADE_SPACE = 2;
        $this->WEIGHT_TAGE = 0.42;
        $this->WEIGHT_FR = 1 - $this->WEIGHT_TAGE;
        $this->SHADE_HEIGHT_TABLE = 3;
        $this->FONT_WEAK_R = 100;
        $this->FONT_WEAK_B = 100;
        $this->ROW_COLOR_R = 235;
        $this->ROW_COLOR_G = 235;
        $this->ROW_COLOR_B = 235;
        $this->LBL_COLOR_R = 210;
        $this->LBL_COLOR_G = 230;
        $this->LBL_COLOR_B = 240;
        $this->ROW_COLOR_WEAK_R = 245;
        $this->ROW_COLOR_WEAK_G = 245;
        $this->ROW_COLOR_WEAK_B = 245;
        $this->SUBTOTAL_COLOR_R = 240;
        $this->SUBTOTAL_COLOR_G = 210;
        $this->SUBTOTAL_COLOR_B = 210;

        $COL_LBL = [
            'ID',
            'Name',
            'Meldeperiode',
            'Arbeitstage',
            'Arbeitsfrei',
            'Krankheit',
            'Ferientage',
            'Urlaubstage',
            'Wegspesen',
            'Kleider',
            'Extra',
            'Total',
        ];
        $COL_UNIT = [
            '',
            '',
            '',
            '',
            '',
            '',
            'Tage',
            'Fr.',
            'Tage',
            'Fr.',
            'Tage',
            'Fr.',
            'Tage',
            'Fr.',
            'Tage',
            'Fr.',
            '',
            'Fr.',
            'Tage',
            'Fr.',
            '',
            'Fr.',
            'Tage',
            'Fr.',
        ];
        $COL_LBL_X = [
            0,
            12,
            50,
            75,
            97,
            119,
            141,
            163,
            187,
            209,
            230,
            245,
        ];
        $COL_UNIT_X = [];
        $SHADE_LBL = [];
        $SHADE_UNIT = [];

        // Generiere automatische Schattierungsbreiten //
        for ($i = 0; $i < count($COL_LBL_X) - 1; $i++) {
            $w = $COL_LBL_X[$i + 1] - $COL_LBL_X[$i] - $this->SHADE_SPACE;
            $COL_UNIT_X[] = $COL_LBL_X[$i];
            $COL_UNIT_X[] = $COL_LBL_X[$i] + $w * $this->WEIGHT_TAGE + $this->SHADE_SPACE / 4;
            $SHADE_LBL[] = $w;
            $SHADE_UNIT[] = $w * $this->WEIGHT_TAGE - $this->SHADE_SPACE / 4;
            $SHADE_UNIT[] = $w * $this->WEIGHT_FR - $this->SHADE_SPACE / 4;
        }
        $w = ($this->PAGE_WIDTH_L - $this->MARGIN_RIGHT - $this->MARGIN_LEFT) - $COL_LBL_X[count($COL_LBL_X) - 1];
        $COL_UNIT_X[] = $COL_LBL_X[count($COL_LBL_X) - 1];
        $COL_UNIT_X[] = $COL_LBL_X[count($COL_LBL_X) - 1] + $w * $this->WEIGHT_TAGE + $this->SHADE_SPACE / 4;
        $SHADE_LBL[] = $w;
        $SHADE_UNIT[] = $w * $this->WEIGHT_TAGE - $this->SHADE_SPACE / 4;
        $SHADE_UNIT[] = $w * $this->WEIGHT_FR - $this->SHADE_SPACE / 4;

        $this->OFFSET_Y = $this->MARGIN_TOP;

        $meldeblaetter = $this->getMeldeblaetterInPeriod($start_TS, $end_TS);

        $this->printDocumentTitle();
        $this->OFFSET_Y += 17.5;

        $this->printInfoEinsatzbetrieb();
        $this->OFFSET_Y += $this->LINE_BREAK_HEADER;

        $this->printMeldeblaetterSource();
        $this->OFFSET_Y += 15;

        $sum_tage = $this->generateEmptyGeldOrTageArray();
        $sum_geld = $this->generateEmptyGeldOrTageArray();

        $cur_id = 0;
        $total_geld = 0;
        $total_tage = 0;
        $count_mb = 0;
        $print_header = true;

        //$test_loop = 36;

        foreach ($meldeblaetter as $blatt) {
            $ret = $this->getSpesenDetails($blatt['id']);
            $tage = $ret['tage'];
            $geld = $ret['geld'];

            $tage['sum'] = $tage['sum'] - $tage['urlaubstage'];

            foreach ($tage as $key => $value) {
                $sum_tage[$key] += $tage[$key];
            }
            foreach ($geld as $key => $value) {
                $sum_geld[$key] += $geld[$key];
            }

            //if($test_loop > 0) {
            if ($blatt['ziviId'] != $cur_id) {
                $count_mb = 0;
                $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW / 2;
                if ($this->checkIfNewPageIsNecessary($meldeblaetter, $blatt, $this->OFFSET_Y)) {
                    $this->pdf->AddPage('L');
                    $this->OFFSET_Y = $this->MARGIN_TOP;
                    $print_header = true;
                }
                if ($print_header) {
                    $print_header = false;
                    $this->printTableHeaders($COL_LBL_X, $COL_LBL, $SHADE_LBL, $this->OFFSET_Y);
                    $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW * 1.2;
                    $this->printTableSubHeaders($COL_UNIT_X, $COL_UNIT, $SHADE_UNIT, $this->OFFSET_Y);
                    $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW * 1.4;
                }
                $this->printIdAndName($blatt, $COL_LBL_X, $SHADE_LBL, $this->OFFSET_Y);
            }

            //$total_geld += $this->getRoundedRappen($geld['sum']);
            $total_geld += $geld['sum'];
            $total_tage += $tage['sum'];
            $cur_id = $blatt['ziviId'];
            $n = $this->countMeldeblaetterOf($meldeblaetter, $cur_id);

            // Print Data Row //
            $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_TINY);
            if ($blatt['state'] == 3) {
                $this->pdf->SetTextColor($this->FONT_WEAK_R, $this->FONT_WEAK_R, $this->FONT_WEAK_R);
                $this->pdf->SetFillColor($this->ROW_COLOR_WEAK_R, $this->ROW_COLOR_WEAK_G, $this->ROW_COLOR_WEAK_B);
            } else {
                $this->pdf->SetTextColor(0, 0, 0);
                $this->pdf->SetFillColor($this->ROW_COLOR_R, $this->ROW_COLOR_G, $this->ROW_COLOR_B);
            }
            $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[2], $this->OFFSET_Y);
            $str = $blatt['start']->format('d.m.y') . " - " . $blatt['end']->format('d.m.y');
            $this->pdf->Cell($SHADE_LBL[2], $this->SHADE_HEIGHT_TABLE, $str, 0, 0, 'L', 1);
            $i = 6;
            foreach ($geld as $key => $value) {
                if ($key == 'fahrspesen') {
                    $this->writeGeldCell($COL_LBL_X[8], $SHADE_LBL[8], $value, $this->OFFSET_Y);
                } elseif ($key == 'ausserordentlich') {
                    $this->writeGeldCell($COL_LBL_X[10], $SHADE_LBL[10], $value, $this->OFFSET_Y);
                } else {
                    $this->writeTageAndGeldCell($i, $key, $COL_UNIT_X, $SHADE_UNIT, $tage, $geld, $this->OFFSET_Y);
                }
                $i += 2;
            }
            $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;

            $count_mb++;
            if ($count_mb == $n) {
                $this->printSubTotalPerZivi($COL_UNIT_X, $COL_LBL_X, $SHADE_UNIT, $SHADE_LBL, $total_tage, $total_geld, $this->OFFSET_Y);
                $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW;
                $total_tage = 0;
                $total_geld = 0;
                $count_mb = 0;
            }
            //    $test_loop -= 1;
            //}
        }
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW * 2;

        // Berechne ob das Gesamttotal noch auf der Seite Platz hat //
        $HEIGHT_TOTAL = $this->LINE_BREAK_ROW2ROW * 1.5 + $this->LINE_BREAK_ROW2ROW * 1.2;
        if ($HEIGHT_TOTAL + $this->OFFSET_Y > $this->PAGE_HEIGHT_L - $this->MARGIN_BOTTOM) {
            $this->pdf->AddPage('L');
            $this->OFFSET_Y = $this->MARGIN_TOP;
        }
        // Drucke das Gesamttotal //
        $this->pdf->SetFillColor($this->LBL_COLOR_R, $this->LBL_COLOR_G, $this->LBL_COLOR_B);
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_LARGE);
        $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[1], $this->OFFSET_Y + $this->LINE_BREAK_ROW2ROW * 1.5);
        $str = 'Gesamttotal:';
        $this->pdf->Cell($SHADE_LBL[1], 9, $str, 0, 0, 'L', 1);
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_SMALL);
        for ($i = 3; $i < min(count($COL_LBL_X), count($COL_LBL)); $i++) {
            $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[$i], $this->OFFSET_Y);
            $this->pdf->Cell($SHADE_LBL[$i], 4, $COL_LBL[$i], 0, 0, 'R', 1);
        }
        $this->OFFSET_Y += $this->LINE_BREAK_ROW2ROW * 1.5;
        $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[2], $this->OFFSET_Y);
        $this->pdf->Cell($SHADE_LBL[2], 4, 'Total Tage', 0, 0, 'L', 1);
        $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[2], $this->OFFSET_Y + $this->LINE_BREAK_ROW2ROW * 1.2);
        $this->pdf->Cell($SHADE_LBL[2], 4, 'Total Franken', 0, 0, 'L', 1);
        $tage_keys = array_keys($sum_tage);
        $geld_keys = array_keys($sum_geld);
        $this->pdf->SetFillColor($this->SUBTOTAL_COLOR_R, $this->SUBTOTAL_COLOR_G, $this->SUBTOTAL_COLOR_B);

        for ($i = 0; $i < count($tage_keys); $i++) {
            $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[$i + 3], $this->OFFSET_Y);
            $str = strval($sum_tage[$tage_keys[$i]]);
            $this->pdf->Cell($SHADE_LBL[$i + 3], 4, $str, 0, 0, 'R', 1);
            $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[$i + 3], $this->OFFSET_Y + $this->LINE_BREAK_ROW2ROW * 1.2);
            $str = $this->getRoundedRappen($sum_geld[$geld_keys[$i]]);
            $this->pdf->Cell($SHADE_LBL[$i + 3], 4, $str, 0, 0, 'R', 1);
        }
    }

    private function printMeldeblaetterSource()
    {
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_SMALL);
        $this->pdf->SetXY($this->MARGIN_LEFT, $this->OFFSET_Y);
        if ($this->showOnlyDoneSheets) {
            $str = "Statistik basiert auf allen erledigten Meldeblättern.";
        } else {
            $str = "Statistik basiert auf allen Meldeblättern (erledigte und pendente).";
        }
        $this->pdf->Cell(0, 0, $str, 0, 0, 'L');
    }

    private function printDocumentTitle()
    {
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_TITLE);
        $this->pdf->SetFillColor($this->TITLE_BOX_COLOR_R, $this->TITLE_BOX_COLOR_G, $this->TITLE_BOX_COLOR_B);
        $this->pdf->SetXY($this->MARGIN_LEFT, $this->OFFSET_Y);
        $this->pdf->Cell($this->PAGE_WIDTH_L - $this->MARGIN_LEFT - $this->MARGIN_RIGHT, $this->TITLE_BOX_HEIGHT, $this->TITLE_DETAIL, 1, 0, "", 1);
    }

    private function printInfoEinsatzbetrieb()
    {
        $str = CompanyInfo::COMPANY_NAME . " (Einsatzbetrieb Nr. " . CompanyInfo::COMPANY_NO . ")  -  Verfügung vom " . date("d.m.Y");
        $this->pdf->SetFont($this->FONT, '', $this->FONT_SIZE_SMALL);
        $this->pdf->SetXY($this->MARGIN_LEFT, $this->OFFSET_Y);
        $this->pdf->Cell(0, 0, $str, 0, 0, 'L');
    }

    private function printTableHeaders($COL_LBL_X, $COL_LBL, $SHADE_LBL)
    {
        $this->pdf->SetFillColor($this->LBL_COLOR_R, $this->LBL_COLOR_G, $this->LBL_COLOR_B);
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_SMALL);
        for ($i = 0; $i < min(count($COL_LBL_X), count($COL_LBL)); $i++) {
            $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[$i], $this->OFFSET_Y);
            $align = "L";
            if ($i == 11) {
                $align = "R";
            }
            $this->pdf->Cell($SHADE_LBL[$i], 4, $COL_LBL[$i], 0, 0, $align, 1);
        }
    }

    private function printTableSubHeaders($COL_UNIT_X, $COL_UNIT, $SHADE_UNIT)
    {
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_TINY);
        for ($i = 0; $i < min(count($COL_UNIT_X), count($COL_UNIT)); $i++) {
            $str = $COL_UNIT[$i];
            if (!empty($str)) {
                $this->pdf->SetXY($this->MARGIN_LEFT + $COL_UNIT_X[$i], $this->OFFSET_Y);
                $this->pdf->Cell($SHADE_UNIT[$i], 3, $str, 0, 0, 'R', 1);
            } elseif ($i > 5) {
                $this->pdf->SetXY($this->MARGIN_LEFT + $COL_UNIT_X[$i], $this->OFFSET_Y);
                $this->pdf->Cell($SHADE_UNIT[$i] + $this->SHADE_SPACE, 3, "", 0, 0, 'R', 1);
            }
        }
    }

    private function printIdAndName($blatt, $COL_LBL_X, $SHADE_LBL)
    {
        $this->pdf->SetFillColor($this->LBL_COLOR_R, $this->LBL_COLOR_G, $this->LBL_COLOR_B);
        $this->pdf->SetFont($this->FONT, '', ($this->FONT_SIZE_TINY + $this->FONT_SIZE_SMALL) / 2);
        $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[0], $this->OFFSET_Y);
        $str = $blatt['ziviId'];
        $this->pdf->Cell($SHADE_LBL[0], 3, $str, 0, 0, 'L', 1);
        $this->pdf->SetFont($this->FONT, 'B', ($this->FONT_SIZE_TINY + $this->FONT_SIZE_SMALL) / 2);
        $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[1], $this->OFFSET_Y);
        $str = $blatt['last_name'] . " " . $blatt['first_name'];
        $this->pdf->Cell($SHADE_LBL[1], 3, "$str", 0, 0, 'L', 1);
    }

    private function printSubTotalPerZivi($COL_UNIT_X, $COL_LBL_X, $SHADE_UNIT, $SHADE_LBL, $total_tage, $total_geld)
    {
        $this->pdf->SetFillColor($this->ROW_COLOR_R, $this->ROW_COLOR_G, $this->ROW_COLOR_B);
        $this->pdf->SetTextColor(0, 0, 0);
        $this->pdf->SetXY($this->MARGIN_LEFT + $COL_LBL_X[10], $this->OFFSET_Y);
        $this->pdf->SetFont($this->FONT, 'B', $this->FONT_SIZE_TINY);
        $this->pdf->SetFillColor($this->SUBTOTAL_COLOR_R, $this->SUBTOTAL_COLOR_G, $this->SUBTOTAL_COLOR_B);
        $this->pdf->Cell($SHADE_LBL[10], $this->SHADE_HEIGHT_TABLE, "Gesamt:", 0, 0, 'L', 1);
        $this->pdf->SetXY($this->MARGIN_LEFT + $COL_UNIT_X[22], $this->OFFSET_Y);
        $this->pdf->Cell($SHADE_UNIT[22], $this->SHADE_HEIGHT_TABLE, strval($total_tage), 0, 0, 'R', 1);
        $this->pdf->SetXY($this->MARGIN_LEFT + $COL_UNIT_X[23], $this->OFFSET_Y);
        $this->pdf->Cell($SHADE_UNIT[23], $this->SHADE_HEIGHT_TABLE, $this->getRoundedRappen($total_geld), 0, 0, 'R', 1);
    }

    private function checkIfnewpageIsNecessary($meldeblaetter, $blatt)
    {
        $n = $this->countMeldeblaetterOf($meldeblaetter, $blatt['ziviId']);
        $p = $n * ($this->LINE_BREAK_ROW2ROW + 1) + $this->LINE_BREAK_ROW2ROW / 2;
        return ($this->OFFSET_Y + $p > ($this->PAGE_HEIGHT_L - $this->MARGIN_BOTTOM));
    }

    private function writeTageAndGeldCell($number, $name, $col_array, $shade_array, $tage, $geld)
    {
        $this->writeTageCell($col_array[$number], $shade_array[$number], $tage[$name], $this->OFFSET_Y);
        $this->writeGeldCell($col_array[$number + 1], $shade_array[$number + 1], $geld[$name], $this->OFFSET_Y);
    }

    private function writeTageCell($unit_x, $shade_unit, $nof_tage, $offset)
    {
        $this->pdf->SetXY($this->MARGIN_LEFT + $unit_x, $offset);
        $str = strval($nof_tage);
        $this->pdf->Cell($shade_unit, $this->SHADE_HEIGHT_TABLE, $str, 0, 0, 'R', 1);
    }

    private function writeGeldCell($unit_x, $shade_unit, $geld, $offset)
    {
        $this->pdf->SetXY($this->MARGIN_LEFT + $unit_x, $offset);
        $str = $this->getRoundedRappen($geld);
        $this->pdf->Cell($shade_unit, $this->SHADE_HEIGHT_TABLE, $str, 0, 0, 'R', 1);
    }

    private function generateEmptyGeldOrTageArray()
    {
        return [
            'arbeitstage'      => 0,
            'arbeitsfreietage' => 0,
            'krankheitstage'   => 0,
            'ferientage'       => 0,
            'urlaubstage'      => 0,
            'fahrspesen'       => 0,
            'arbeitskleider'   => 0,
            'ausserordentlich' => 0,
            'sum'              => 0,
        ];
    }

    private function getMeldeblaetterInPeriod(Carbon $start_TS, Carbon $end_TS)
    {
        $query = ReportSheet::join('users', 'users.id', '=', 'report_sheets.user_id');

        if ($this->showOnlyDoneSheets) {
            $query = $query->where('report_sheets.state', '=', '3');
        }

        $result = $query
            ->whereDate('report_sheets.start', '<=', $end_TS->format('Y-m-d'))
            ->whereDate('report_sheets.end', '>=', $start_TS->format('Y-m-d'))
            ->orderBy('users.last_name')
            ->orderBy('users.first_name')
            ->orderBy('users.zdp')
            ->orderBy('report_sheets.start')
            ->orderBy('report_sheets.end')
            ->select('report_sheets.id AS id', 'users.zdp AS ziviId', 'first_name', 'last_name', 'start', 'end', 'state')
            ->get();

        foreach ($result as $row) {
            $row["start"] = strtotime($row["start"]);
            $row["end"] = strtotime($row["end"]);
        }

        return $result;
        /*switch($done_flag) {
            case 0:
                $sql= "SELECT id, ziviId, start, end, done, einsaetze_id, firstname, lastname
           FROM meldeblaetter, accounts
           WHERE done=1 AND username=ziviId
           ORDER BY lastname, firstname, ziviId, start, end;";
                break;
            default:
                $sql= "SELECT id, ziviId, start, end, done, einsaetze_id, firstname, lastname
           FROM meldeblaetter, accounts
           WHERE username=ziviId
           ORDER BY lastname, firstname, ziviId, start, end;";
        }
        $res = mysql_query($sql);
        $rows = array();
        while ($row = mysql_fetch_array($res)) {
            $row["start"] = strtotime($row["start"]);
            $row["end"] = strtotime($row["end"]);
            if(($row['start'] >= $start_TS && $row['start'] <= $end_TS)
                || ($row['end'] >= $start_TS && $row['end'] <= $end_TS)
                || ($row['start'] <= $start_TS && $row['end'] >= $end_TS)) {
                $rows[] = $row;
            }
        }
        return $rows;*/
    }

    private function getSpesenDetails($meldeblatt)
    {

        $spesen = ReportSheet::findOrFail($meldeblatt);

        // Add first & last day to arbeitstage, since they are not considered yet in getSpesen.
        $tage = [
            'arbeitstage'      => $spesen->work + $spesen->first_day + $spesen->last_day,
            'arbeitsfreietage' => $spesen->workfree + $spesen->additional_workfree,
            'krankheitstage'   => $spesen->ill,
            'ferientage'       => $spesen->holiday + $spesen->company_holiday_holiday,
            'urlaubstage'      => $spesen->vacation + $spesen->company_holiday_vacation,
            'arbeitskleider'   => $spesen->clothes_days,
        ];

        $geld_arbeitstage = $spesen->work_days_costs + $spesen->first_day_costs + $spesen->last_day_costs;

        $geld = [
            'arbeitstage'      => $this->getRoundedRappen($geld_arbeitstage / 100),
            'arbeitsfreietage' => $this->getRoundedRappen($spesen->work_free_days_costs / 100),
            'krankheitstage'   => $this->getRoundedRappen($spesen->ill_days_costs / 100),
            'ferientage'       => $this->getRoundedRappen($spesen->holidays_costs / 100),
            'urlaubstage'      => 0,
            'fahrspesen'       => $this->getRoundedRappen($spesen->driving_charges  / 100),
            'arbeitskleider'   => $this->getRoundedRappen($spesen->clothes / 100),
            'ausserordentlich' => $this->getRoundedRappen($spesen->extraordinarily / 100),
        ];

        $geld['sum'] = $geld['arbeitstage'] + $geld['arbeitsfreietage'] + $geld['krankheitstage']
            + $geld['ferientage'] + $geld['fahrspesen'] + $geld['arbeitskleider']
            + $geld['ausserordentlich'];
        $tage['sum'] = $tage['arbeitstage'] + $tage['arbeitsfreietage'] + $tage['urlaubstage'] + $tage['ferientage'] + $tage['krankheitstage'];

        return (['tage' => $tage, 'geld' => $geld]);
    }

    private function countMeldeblaetterOf($meldeblaetter, $ziviID)
    {
        $c = 0;
        foreach ($meldeblaetter as $blatt) {
            if ($blatt['ziviId'] == $ziviID) {
                $c++;
            }
        }
        return $c;
    }

    private function countNumberOfZivis($meldeblaetter)
    {
        $eunik = [];
        foreach ($meldeblaetter as $blatt) {
            if (array_search($blatt['ziviId'], $eunik) === false) {
                $eunik[] = $blatt['ziviId'];
            }
        }
        return count($eunik);
    }
}
