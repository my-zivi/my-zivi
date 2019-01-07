<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\ReportSheet;
use Illuminate\Support\Facades\Auth;

class ReportSheetController extends Controller
{
    public function index()
    {
        if (!Auth::user()->isAdmin()) {
            // TODO Improve this piece by using Auth::user->report_sheets, then use the Laravel Collection where and select functions
            $reportSheets = ReportSheet::join('users', 'report_sheets.user', '=', 'users.id')
                ->select('report_sheets.id AS id', 'start', 'end', 'state')
                ->where('users.id', '=', Auth::id())
                ->where('state', '>', '0')
                ->get();

            // Add calculated column days
            foreach ($reportSheets as $reportSheet) {
                $reportSheet['days'] = ReportSheet::getDiensttageCount($reportSheet->start, $reportSheet->end);
            }

            return $reportSheets;
        } else {
            return ReportSheet::with('user')->get();
        }
    }
}
