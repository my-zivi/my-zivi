<?php

namespace App;

use App\CompanyInfo;
use App\Http\Controllers\API\MissionController;
use App\Services\PDF\PDF;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use \DateTime;

class ReportSheet extends Model
{
    use SoftDeletes;

    protected $fillable = ['id',
                           'start',
                           'end',
                           'user',
                           'work',
                           'work_comment',
                           'national_holiday',
                           'company_holiday',
                           'company_holiday_comment',
                           'workfree',
                           'workfree_comment',
                           'additional_workfree',
                           'additional_workfree_comment',
                           'ill',
                           'ill_comment',
                           'holiday',
                           'holiday_comment',
                           'vacation',
                           'vacation_comment',
                           'driving_charges',
                           'driving_charges_comment',
                           'extraordinarily',
                           'extraordinarily_comment',
                           'clothes',
                           'clothes_comment',
                           'employmentId',
                           'bank_account_number',
                           'document_number', // "Beleg Nummer"
                           'state',
                           'ignore_first_last_day',
                        ];


    public function user()
    {
        return $this->belongsTo('App\User', 'user');
    }

    static function getSpesen($reportSheetId)
    {
        $reportSheet = ReportSheet::join('missions', 'missions.id', '=', 'report_sheets.mission')
            ->join('specifications', 'specifications.id', '=', 'missions.specification')
            ->join('users', 'users.id', '=', 'report_sheets.user')
            ->where('report_sheets.id', '=', $reportSheetId)
            ->select(
                'report_sheets.start AS meldeblaetter_start',
                'report_sheets.end AS meldeblaetter_end',
                'report_sheets.work AS meldeblaetter_work',
                'report_sheets.workfree AS meldeblaetter_workfree',
                'report_sheets.company_holiday_holiday AS meldeblaetter_compholiday_holiday',
                'report_sheets.company_holiday_vacation AS meldeblaetter_compholiday_vacation',
                'report_sheets.work_comment AS meldeblaetter_work_comment',
                'report_sheets.workfree_comment AS meldeblaetter_workfree_comment',
                'report_sheets.company_holiday_comment AS meldeblaetter_compholiday_comment',
                'report_sheets.additional_workfree AS meldeblaetter_add_workfree',
                'report_sheets.additional_workfree_comment AS meldeblaetter_add_workfree_comment',
                'report_sheets.ill AS meldeblaetter_ill',
                'report_sheets.ill_comment AS meldeblaetter_ill_comment',
                'report_sheets.holiday AS meldeblaetter_holiday',
                'report_sheets.holiday_comment AS meldeblaetter_holiday_comment',
                'report_sheets.vacation AS meldeblaetter_urlaub',
                'report_sheets.vacation_comment AS meldeblaetter_urlaub_comment',
                'report_sheets.driving_charges AS meldeblaetter_fahrspesen',
                'report_sheets.driving_charges_comment AS meldeblaetter_fahrspesen_comment',
                'report_sheets.extraordinarily AS meldeblaetter_ausserordentlich',
                'report_sheets.extraordinarily_comment AS meldeblaetter_ausserordentlich_comment',
                'report_sheets.clothes AS meldeblaetter_kleider',
                'report_sheets.clothes_comment AS meldeblaetter_kleider_comment',
                'report_sheets.bank_account_number AS bank_account_number',
                'report_sheets.document_number AS document_number',
                'report_sheets.state AS state',
                'report_sheets.ignore_first_last_day AS ignore_first_last_day',
                'missions.id AS mission_id',
                'missions.start AS einsaetze_start',
                'missions.end AS einsaetze_end',
                'missions.specification AS einsaetze_pflichtenheft',
                'missions.eligible_holiday AS einsaetze_eligibleholiday',
                'specifications.id AS pflichtenheft_id',
                'specifications.name AS pflichtenheft_name',
                'specifications.pocket AS pflichtenheft_pocket',
                'specifications.accommodation AS pflichtenheft_accommodation',
                'specifications.working_clothes_expense AS pflichtenheft_clothes_expense',
                'specifications.sparetime_breakfast_expenses AS pflichtenheft_sparetime_breakfast_expenses',
                'specifications.sparetime_lunch_expenses AS pflichtenheft_sparetime_lunch_expenses',
                'specifications.sparetime_dinner_expenses AS pflichtenheft_sparetime_dinner_expenses',
                'specifications.working_breakfast_expenses AS pflichtenheft_working_breakfast_expenses',
                'specifications.working_lunch_expenses AS pflichtenheft_working_lunch_expenses',
                'specifications.working_dinner_expenses AS pflichtenheft_working_dinner_expenses',
                'specifications.firstday_breakfast_expenses AS pflichtenheft_firstday_breakfast_expenses',
                'specifications.firstday_lunch_expenses AS pflichtenheft_firstday_lunch_expenses',
                'specifications.firstday_dinner_expenses AS pflichtenheft_firstday_dinner_expenses',
                'specifications.lastday_breakfast_expenses AS pflichtenheft_lastday_breakfast_expenses',
                'specifications.lastday_lunch_expenses AS pflichtenheft_lastday_lunch_expenses',
                'specifications.lastday_dinner_expenses AS pflichtenheft_lastday_dinner_expenses',
                'users.first_name AS first_name',
                'users.last_name AS last_name',
                'users.zdp AS zdp',
                'users.bank_iban AS iban',
                'users.bank_bic AS bic',
                'users.address AS address',
                'users.zip AS zip',
                'users.city AS city',
                'users.id AS user'
            )
            ->first();

        // echo("Arbeitstage ".$reportSheet['meldeblaetter_work']." in DB vs. ");


        $reportSheet['meldeblaetter_tage'] = ReportSheet::countDaysBetween(strtotime($reportSheet['meldeblaetter_start']), strtotime($reportSheet['meldeblaetter_end']));
        $reportSheet['einsaetze_tage'] = ReportSheet::countDaysBetween(strtotime($reportSheet['einsaetze_start']), strtotime($reportSheet['einsaetze_end']));


        $ziviferien = $reportSheet['einsaetze_eligibleholiday'];

        $ziviferienbisher = ReportSheet::where('report_sheets.id', '!=', $reportSheetId)
            ->where('mission', '=', $reportSheet['mission_id'])
            ->groupBy('user')
            ->selectRaw('(SUM(company_holiday_holiday) + SUM(holiday)) AS ferienbisher')
            ->first()['ferienbisher'];

        $betriebsferien = Holiday::join('holiday_types', 'holidays.holiday_type', '=', 'holiday_types.id')
            ->whereDate('date_from', '<=', $reportSheet['meldeblaetter_end'])
            ->whereDate('date_to', '>=', $reportSheet['meldeblaetter_start'])
            ->where('holiday_types.name', '=', 'Betriebsferien')
            ->get();

        $holiday_feiertage = Holiday::join('holiday_types', 'holidays.holiday_type', '=', 'holiday_types.id')
            ->whereDate('date_from', '<=', $reportSheet['meldeblaetter_end'])
            ->whereDate('date_to', '>=', $reportSheet['meldeblaetter_start'])
            ->where('holiday_types.name', '=', 'Feiertag')
            ->get();

        $feiertage = array();
        foreach ($holiday_feiertage as $range) {
            for ($u = strtotime($range['date_from']); $u<=strtotime($range['date_to']); $u=ReportSheet::tomorrow($u)) {
                if (date('w', $u)==0 || date('w', $u)==6) {
                    //ignore Feiertage an Wochenenden
                } else {
                    $feiertage[] = $u;
                }
            }
        }

        $firmenurlaubstage = array();
        foreach ($betriebsferien as $ferien) {
            for ($u = strtotime($ferien['date_from']); $u<=strtotime($ferien['date_to']); $u=ReportSheet::tomorrow($u)) {
                if (date('w', $u)==0 || date('w', $u)==6) {
                    //ignore Betriebsferien an Wochenenden
                } else {
                    $isFeiertag = false;
                    foreach ($feiertage as $feiertag) {
                        if ($u == $feiertag) {
                            $isFeiertag = true;
                            break;
                        }
                    }
                    if (!$isFeiertag) {
                        $firmenurlaubstage[] = $u;
                    }
                }
            }
        }

        // Wenn möglich Betriebsferien als Ferien verbuchen
        $ziviferienrest_fuer_urlaub = min(count($firmenurlaubstage), $ziviferien - $ziviferienbisher);


        $reportSheet['meldeblaetter_ferien_wegen_urlaub_proposal'] = $ziviferienrest_fuer_urlaub;
        if (is_numeric($reportSheet['meldeblaetter_compholiday_holiday'])) {
            $reportSheet['meldeblaetter_ferien_wegen_urlaub'] = $reportSheet['meldeblaetter_compholiday_holiday'];
        } else {
            $reportSheet['meldeblaetter_ferien_wegen_urlaub'] = $reportSheet['meldeblaetter_ferien_wegen_urlaub_proposal'];
        }

        //Verbleibende Ferien
        $reportSheet['remaining_holidays'] = $ziviferien-$ziviferienbisher-$reportSheet['meldeblaetter_ferien_wegen_urlaub']-$reportSheet['meldeblaetter_holiday'];

        $reportSheet['meldeblaetter_companyurlaub'] = count($firmenurlaubstage) - $ziviferienrest_fuer_urlaub;
        $reportSheet['meldeblaetter_companyurlaub_proposal'] = $reportSheet['meldeblaetter_companyurlaub'];
        if (is_numeric($reportSheet['meldeblaetter_compholiday_vacation'])) {
            $reportSheet['meldeblaetter_companyurlaub'] = $reportSheet['meldeblaetter_compholiday_vacation'];
        }

        // berechne Arbeitstage und arbeitsfreie Tage:
        $reportSheet['meldeblaetter_workdays'] = 0;
        $reportSheet['meldeblaetter_workfreedays'] = 0;

        $from_date = strtotime($reportSheet['meldeblaetter_start']);
        $to_date = strtotime($reportSheet['meldeblaetter_end']);

        for ($day = $from_date; $day <= $to_date; $day = ReportSheet::tomorrow($day)) {
            if (array_search($day, $firmenurlaubstage) !== false) {
                continue;
            }
            if (date("w", $day) == 6 || date("w", $day) == 0) {
                //Arbeitsfrei (Wochenende)
                $reportSheet['meldeblaetter_workfreedays']=$reportSheet['meldeblaetter_workfreedays']+1;
            } else {
                if (array_search(intval($day), $feiertage) !== false) {
                    //Arbeitsfrei (Feiertag)
                    $reportSheet['meldeblaetter_workfreedays']=$reportSheet['meldeblaetter_workfreedays']+1;
                } else {
                    //Arbeit
                    $reportSheet['meldeblaetter_workdays']=$reportSheet['meldeblaetter_workdays']+1;
                }
            }
        }



        $reportSheet['meldeblaetter_workdays_proposal'] = $reportSheet['meldeblaetter_workdays'];

        //Overwrite calcuclaed workdays with value from db if not null
        if (is_numeric($reportSheet['meldeblaetter_work'])) {
            $reportSheet['meldeblaetter_workdays'] = $reportSheet['meldeblaetter_work'];
        }

        $reportSheet['meldeblaetter_workfreedays_proposal'] = $reportSheet['meldeblaetter_workfreedays'];
        //Overwrite calcuclaed workfreedays with value from db if not null
        if (is_numeric($reportSheet['meldeblaetter_workfree'])) {
            $reportSheet['meldeblaetter_workfreedays'] = $reportSheet['meldeblaetter_workfree'];
        }

        //Krankheitstage
        $einsatzdauer = $reportSheet['einsaetze_tage'];

        /*Krankheitstage werden nach folgender Formel berechnet
        Einsatzdauer (in Tagen) Anrechenbare Abwesenheitstage infolge      Krankheit/Unfall
            1-3                                                                 1
            4-8                                                                 2
            9-14                                                                3
            15-21                                                               4
            22-29                                                               5
            pro 30 Tage Einsatz                                                 6
        */
        $verfügbare_krankheitstage = floor($einsatzdauer/30)*6;
        $resttage_einsatz = $einsatzdauer%30;
        if ($resttage_einsatz>= 1 && $resttage_einsatz<=3) {
            $verfügbare_krankheitstage+=1;
        } elseif ($resttage_einsatz>= 4 && $resttage_einsatz<=8) {
            $verfügbare_krankheitstage+=2;
        } elseif ($resttage_einsatz>= 9 && $resttage_einsatz<=14) {
            $verfügbare_krankheitstage+=3;
        } elseif ($resttage_einsatz>= 15 && $resttage_einsatz<=21) {
            $verfügbare_krankheitstage+=4;
        } elseif ($resttage_einsatz>= 22 && $resttage_einsatz<=29) {
            $verfügbare_krankheitstage+=5;
        }

        $krankheitstage_bisher = ReportSheet::selectRaw('SUM(`ill`) AS d')->where('mission', '=', $reportSheet['mission_id'])->first()['d'];

        $reportSheet['krankheitstage_verbleibend'] = $verfügbare_krankheitstage - $krankheitstage_bisher;

        $reportSheet['meldeblaetter_fahrspesen'] /= 100;
        $reportSheet['meldeblaetter_ausserordentlich'] /= 100;


        $reportSheet['meldeblaetter_kleider_proposal'] = ($reportSheet['meldeblaetter_workdays']+$reportSheet['meldeblaetter_workfreedays']+$reportSheet['meldeblaetter_ferien_wegen_urlaub'])*$reportSheet['pflichtenheft_clothes_expense']/100;
        $reportSheet['meldeblaetter_kleider_proposal'] = min(240, $reportSheet['meldeblaetter_kleider_proposal']);

        $bisher = ReportSheet::selectRaw('SUM(clothes) AS s')
                ->where('mission', '=', $reportSheet['mission_id'])
                ->where('start', '<', $reportSheet['meldeblaetter_start'])->first()['s'] / 100;

        $reportSheet['meldeblaetter_kleider_proposal'] = min($reportSheet['meldeblaetter_kleider_proposal'], 240-$bisher);

        if (is_numeric($reportSheet['meldeblaetter_kleider'])) {
            $reportSheet['meldeblaetter_kleider'] = $reportSheet['meldeblaetter_kleider'] / 100;
        } else {
            $reportSheet['meldeblaetter_kleider'] = $reportSheet['meldeblaetter_kleider_proposal'];
        }


        $reportSheet['arbeitstage'] = $reportSheet['meldeblaetter_workdays'];
        $reportSheet['arbeitsfreie_tage'] = $reportSheet['meldeblaetter_workfreedays']+$reportSheet['meldeblaetter_add_workfree'];
        $reportSheet['urlaubstage'] =  $reportSheet['meldeblaetter_urlaub'] + $reportSheet['meldeblaetter_companyurlaub'];
        $reportSheet['ferientage'] = $reportSheet['meldeblaetter_holiday'] + $reportSheet['meldeblaetter_ferien_wegen_urlaub'];
        $reportSheet['krankheitstage'] =  $reportSheet['meldeblaetter_ill'];
        $reportSheet['arbeitskleider_tage'] = $reportSheet['arbeitstage']+
                                                $reportSheet['arbeitsfreie_tage']+
                                                $reportSheet['ferientage']+
                                                $reportSheet['krankheitstage'];
        $reportSheet['total_arbeitskleider'] = $reportSheet['meldeblaetter_kleider'];
        $reportSheet['add_workfree'] = $reportSheet['meldeblaetter_add_workfree'];

        $reportSheet['sparetime_sum'] = ($reportSheet['pflichtenheft_pocket'] +
                            $reportSheet['pflichtenheft_accommodation'] +
                            $reportSheet['pflichtenheft_sparetime_breakfast_expenses'] +
                            $reportSheet['pflichtenheft_sparetime_lunch_expenses'] +
                            $reportSheet['pflichtenheft_sparetime_dinner_expenses']) / 100;
        $reportSheet['total_ill'] = PDF::getRoundedRappen($reportSheet['krankheitstage'] * $reportSheet['sparetime_sum']);

        $reportSheet['workday_sum'] =   ($reportSheet['pflichtenheft_pocket'] +
                            $reportSheet['pflichtenheft_accommodation'] +
                            $reportSheet['pflichtenheft_working_breakfast_expenses'] +
                            $reportSheet['pflichtenheft_working_lunch_expenses'] +
                            $reportSheet['pflichtenheft_working_dinner_expenses']) / 100;

        if ($reportSheet['ignore_first_last_day']) {
            $reportSheet['firstday_sum'] = $reportSheet['lastday_sum'] = $reportSheet['workday_sum'];
        } else {
            $reportSheet['firstday_sum'] = ($reportSheet['pflichtenheft_pocket'] +
                                            $reportSheet['pflichtenheft_accommodation'] +
                                            $reportSheet['pflichtenheft_firstday_breakfast_expenses'] +
                                            $reportSheet['pflichtenheft_firstday_lunch_expenses'] +
                                            $reportSheet['pflichtenheft_firstday_dinner_expenses']) / 100;
            $reportSheet['lastday_sum'] = ($reportSheet['pflichtenheft_pocket'] +
                                           $reportSheet['pflichtenheft_accommodation'] +
                                           $reportSheet['pflichtenheft_lastday_breakfast_expenses'] +
                                           $reportSheet['pflichtenheft_lastday_lunch_expenses'] +
                                           $reportSheet['pflichtenheft_lastday_dinner_expenses']) / 100;
        }

        $reportSheet['total_workdays'] = PDF::getRoundedRappen($reportSheet['arbeitstage'] * $reportSheet['workday_sum']);
        $reportSheet['total_workfree'] = PDF::getRoundedRappen($reportSheet['arbeitsfreie_tage'] * $reportSheet['sparetime_sum']);
        $reportSheet['total_holiday'] = PDF::getRoundedRappen($reportSheet['ferientage'] * $reportSheet['sparetime_sum']);
        $reportSheet['total_fahrspesen'] = PDF::getRoundedRappen($reportSheet['meldeblaetter_fahrspesen']);
        $reportSheet['total_ausserordentlich'] = PDF::getRoundedRappen($reportSheet['meldeblaetter_ausserordentlich']);


        $reportSheet['total'] = $reportSheet['total_workdays'] +
                                    $reportSheet['total_workfree'] +
                                    $reportSheet['total_ill'] +
                                    $reportSheet['total_holiday'] +
                                    $reportSheet['total_fahrspesen'] +
                                    $reportSheet['total_arbeitskleider'] +
                                    $reportSheet['total_ausserordentlich'];

        $reportSheet['sum_tage'] = $reportSheet['arbeitstage'] +
                                        $reportSheet['arbeitsfreie_tage'] +
                                        $reportSheet['urlaubstage'] +
                                        $reportSheet['ferientage'] +
                                        $reportSheet['krankheitstage'];


        if ($reportSheet['firstday_sum'] != $reportSheet['workday_sum']) {
            $reportSheet['bolListFirstDay'] = true;
            if (strtotime($reportSheet['meldeblaetter_start']) == strtotime($reportSheet['einsaetze_start'])) {
                $reportSheet['intFirstDays'] = 1;
                $reportSheet['arbeitstage'] -= 1;
                $reportSheet['total'] -= $reportSheet['workday_sum'];
                $reportSheet['total'] += $reportSheet['firstday_sum'];
            } else {
                $reportSheet['intFirstDays'] = 0;
            }
        } else {
            $reportSheet['bolListFirstDay'] = false;
        }
        if ($reportSheet['lastday_sum'] != $reportSheet['workday_sum']) {
            $reportSheet['bolListLastDay'] = true;
            if (strtotime($reportSheet['meldeblaetter_end']) == strtotime($reportSheet['einsaetze_end'])) {
                $reportSheet['intLastDays'] = 1;
                $reportSheet['arbeitstage'] -= 1;
                $reportSheet['total'] -= $reportSheet['workday_sum'];
                $reportSheet['total'] += $reportSheet['lastday_sum'];
            } else {
                $reportSheet['intLastDays'] = 0;
            }
        } else {
            $reportSheet['bolListLastDay'] = false;
        }

        return $reportSheet;
    }

    private static function countDaysBetween($start_TS, $end_TS)
    {
        if ($start_TS > $end_TS) {
            $tmp = $start_TS;
            $start_TS = $end_TS;
            $end_TS = $tmp;
        }
        $d = date("d", $start_TS);
        $m = date("m", $start_TS);
        $y = date("Y", $start_TS);
        $c = 0;
        $found = false;
        while (!$found) {
            if (mktime(0, 0, 0, $m, $d + $c, $y) == $end_TS) {
                $found = true;
                $c++;
            } else {
                $c++;
            }
            if ($c > 26000) {
                $c = 0;
                break;
            }
        }
        return $c;
    }

    private static function tomorrow($day_TS)
    {
        $d = date("j", $day_TS);
        $m = date("m", $day_TS);
        $y = date("Y", $day_TS);
        return mktime(0, 0, 0, $m, $d + 1, $y);
    }

    public static function getDiensttageCount($start, $end, $long_mission = false)
    {
        if (strtotime($end)>=strtotime($start)) {
            $dayCount = ReportSheet::countDaysBetween(strtotime($start), strtotime($end));
            return ReportSheet::subtractFreeDays($start, $end, $dayCount, $long_mission);
        } else {
            return 0;
        }
    }

    public static function getDiensttageEndDate($start, $days, $long_mission)
    {

        $end = $start;
        if (isset($days) && $days > 0) {
          // end date is usually start date + days
            $end = ReportSheet::addDaysToDate($start, $days-1);
            $lastEnd = $end;
            $chargedDays = -2;
            $hasHolidays = false;

          // the end date is increased until the charged days matches the selection (in case there are holidays)
            while ($chargedDays < $days && $chargedDays < 400) {
                $lastEnd = $end;
                $end = ReportSheet::addDaysToDate($end, 1);
                $chargedDays = ReportSheet::getDiensttageCount($start, $end, $long_mission);

                if ($chargedDays < $days+1) {
                    $hasHolidays = true;
                }
            }
        }

        // if there are holidays found, the date needs to be set to the next day
        if ($hasHolidays) {
            return $end;
        }

        return $lastEnd;
    }

    /**
    * Subtracts the number of days that are "Betriebsferien" and not "Feiertage"
    */
    private static function subtractFreeDays($start, $end, $dayCount, $long_mission)
    {
        $ziviHolidays = MissionController::calculateZiviHolidays($long_mission, $dayCount);

        $betriebsferien = Holiday::join('holiday_types', 'holidays.holiday_type', '=', 'holiday_types.id')
          ->whereDate('date_from', '<=', $end)
          ->whereDate('date_to', '>=', $start)
          ->where('holiday_types.name', '=', 'Betriebsferien')
          ->get();

        $feiertage = Holiday::join('holiday_types', 'holidays.holiday_type', '=', 'holiday_types.id')
          ->whereDate('date_from', '<=', $end)
          ->whereDate('date_to', '>=', $start)
          ->where('holiday_types.name', '=', 'Feiertag')
          ->get();

        foreach ($betriebsferien as $ferien) {
            for ($u = max(strtotime($start), strtotime($ferien['date_from'])); $u<=min(strtotime($end), strtotime($ferien['date_to'])); $u=ReportSheet::tomorrow($u)) {
                if (date('w', $u)==0 || date('w', $u)==6) {
                    //ingore saturday & sunday, because they count as Diensttag anyway
                } else {
                    $isInFeiertag = false;
                    foreach ($feiertage as $feiertag) {
                        if (strtotime($feiertag['date_from'])<=$u && $u<=strtotime($feiertag['date_to'])) {
                            $isInFeiertag = true;
                            break;
                        }
                    }
                    if (!$isInFeiertag) {
                        if ($ziviHolidays > 0) {
                            $ziviHolidays--;
                        } else {
                            $dayCount--;
                        }
                    }
                }
            }
        }

        return $dayCount;
    }

    /**
    * Returns the calculated date as a string
    */
    private static function addDaysToDate($dateString, $days)
    {
        $datetime = DateTime::createFromFormat('Y-m-d', $dateString);
        $datetime->modify('+'.$days.' day');
        return $datetime->format('Y-m-d');
    }

    public static function add($mission, $start, $end)
    {
        $sheet = new ReportSheet();
        $sheet->mission = $mission->id;
        $sheet->user = $mission->user;
        $sheet->start = $start;
        $sheet->end = $end;
        $sheet->bank_account_number = CompanyInfo::DEFAULT_ACCOUNT_NUMBER_REPORT_SHEETS;
        $sheet->additional_workfree = 0;
        $sheet->driving_charges = 0;
        $sheet->extraordinarily = 0;
        $sheet->ill = 0;
        $sheet->holiday = 0;
        $sheet->state = 0;
        $sheet->vacation = 0;
        $sheet->save();
    }

    // Delete all linked report sheets to a mission when a mission is soft deleted
    public static function deleteByMission($missionId)
    {
        $reportSheets = ReportSheet::where('mission', '=', $missionId);
        $reportSheets->delete();
    }
}
