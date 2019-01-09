<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Mission;
use App\ReportSheet;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Input;

class MissionController extends Controller
{
    public function delete($id)
    {
        Mission::findOrFail($id)->delete();
        ReportSheet::deleteByMission($id);
        return response("deleted");
    }

    public function indexByYear($year)
    {
        // TODO remove join and work with Laravel relations instead
        $data = Mission::join('users', 'users.id', '=', 'missions.user_id')
            ->join('specifications', 'specifications.id', '=', 'missions.specification_id')
            ->select('*', 'users.id AS userid')
            ->whereNull('missions.deleted_at')
            ->whereDate('end', '>=', $year . '-01-01')
            ->whereDate('start', '<=', $year . '-12-31')
            ->orderBy('start')
            ->get();
        $intermediateResult = array();
        foreach ($data as $m) {
            if (!isset($intermediateResult[$m->userid])) {
                $intermediateResult[$m->userid] = array();
            }
            $intermediateResult[$m->userid][] = $m;
        }

        $result = array();
        foreach ($intermediateResult as $m) {
            $result[] = $m;
        }

        return response()->json($result);
    }

    public function post(Request $request)
    {
        $validatedData = $this->validateRequest($request);

        if (Auth::user()->isAdmin() || Auth::id() == $validatedData['user_id']) {
            $mission = new Mission($validatedData);
            $mission->feedback_mail_sent = false;
            $mission->feedback_done = false;

            $dayCount = Carbon::parse($mission->start)->diffInDays(Carbon::parse($mission->end));

            // TODO replace this implementation with the new Calculators from #78
            $mission->eligible_holiday = MissionController::calculateZiviHolidays($mission->long_mission, $dayCount);

            // TODO replace this piece as soon as the frontend implementation of the Profile view is specified
            $user = Auth::user();
            if ($mission->user_id == 'me') {
                $mission->user_id = $user->id;
            }

            $mission->save();
            return $mission;
        } else {
            return $this->respondWithUnauthorized();
        }
    }

    public function put($id, Request $request)
    {
        $mission = Mission::findOrFail($id);

        if (Auth::user()->isAdmin() || Auth::id() == $mission->user_id) {
            DB::beginTransaction();
            try {
                $validatedData = $this->validateRequest($request);
                $this->updateReportSheets($mission);

                $mission->update($validatedData);
            } catch (\Exception $e) {
                DB::rollBack();
                throw $e;
            }
            DB::commit();

            return $mission;
        } else {
            return $this->respondWithUnauthorized();
        }
    }

    public function receivedDraft($id)
    {
        $mission = Mission::findOrFail($id);
        $mission->draft = date("Y-m-d");
        $mission->save();

        //Add new ReportSheets
        $start = Carbon::parse($mission->start);
        $end = Carbon::parse($mission->end);

        $reportSheetEnd = $start->copy()->modify('last day of this month');
        while ($reportSheetEnd->lessThan($end)) {
            ReportSheet::add($mission, $start, $reportSheetEnd);
            $start->modify('first day of next month');
            $reportSheetEnd->modify('last day of next month');
        }
        ReportSheet::add($mission, $start, $end);

        return response("updated");
    }

    private function updateReportSheets(&$mission)
    {
        // TODO move this into the model in an update hook
        if ($mission->draft) {
            if ($mission->end != Input::get("end", "") && $mission->end < Input::get("end", "")) {
                $start = new \DateTime($mission->end);
                $end = new \DateTime(Input::get("end", ""));
                $iteratorStart = $start->modify("next day");
                $iteratorEnd = clone $iteratorStart;
                $iteratorEnd->modify('last day of this month');

                while ($iteratorEnd<$end) {
                    ReportSheet::add($mission, $iteratorStart, $iteratorEnd);
                    $iteratorStart->modify('first day of next month');
                    $iteratorEnd->modify('last day of next month');
                }
                ReportSheet::add($mission, $iteratorStart, $end);
            }
        }
    }

    # TODO implement a test as soon as calculate zivi holidays got replaced (issue #78)
    public static function calculateZiviHolidays($long_mission, $dayCount)
    {

        if ($long_mission === 'true' || $long_mission === true || $long_mission == 1) {
            $long_mission_min_duration = 180;
            $base_holiday_days = 8;
            $holiday_days_per_month = 2;
            $month_day_rule = 30;

            if ($dayCount < $long_mission_min_duration) {
                return 0;
            } else {
              // Holiday calculation: 8 per 180 days + 2 every additional 30 days
                return $base_holiday_days + (floor(($dayCount - $long_mission_min_duration) / $month_day_rule) * $holiday_days_per_month);
            }
        }
        return 0;
    }

    private function validateRequest(Request $request)
    {
        return $this->validate($request, [
            'days' => 'required|integer',
            'end' => 'required|date',
            'first_time' => 'required|boolean',
            'long_mission' => 'required|boolean',
            'mission_type' => 'required|integer',
            'probation_period' => 'required|boolean',
            'specification_id' => 'required|integer',
            'start' => 'required|date',
            'user_id' => 'required|integer'
        ]);
    }
}
