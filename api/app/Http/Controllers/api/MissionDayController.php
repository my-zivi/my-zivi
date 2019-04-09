<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Services\Calculator\MissionDaysCalculator;
use Carbon\Carbon;
use Illuminate\Http\Request;

class MissionDayController extends Controller
{
    public function eligibleDays(Request $request)
    {
        $validatedData = $this->validate($request, [
            'end'   => 'required|date',
            'start' => 'required|date',
        ]);

        $carbonizedStart = Carbon::parse($validatedData['start']);
        $carbonizedEnd = Carbon::parse($validatedData['end']);

        return MissionDaysCalculator::calculateEligibleDays($carbonizedStart, $carbonizedEnd);
    }

    public function possibleEndDate(Request $request)
    {
        $validatedData = $this->validate($request, [
            'days'  => 'required|integer',
            'start' => 'required|date',
        ]);

        $carbonizedStart = Carbon::parse($validatedData['start']);

        return MissionDaysCalculator::calculatePossibleEndDate($carbonizedStart, $validatedData['days'])->format('Y-m-d');
    }
}
