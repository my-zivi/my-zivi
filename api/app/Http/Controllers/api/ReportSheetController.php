<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\ReportSheet;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReportSheetController extends Controller
{
    public function delete($id)
    {
        ReportSheet::findOrFail($id)->delete();
        return 'Entity deleted';
    }

    public function get($id)
    {
        return ReportSheet::with('mission', 'mission.specification', 'user')->findOrFail($id)->append(['duration', 'proposed_values']);
    }

    public function index()
    {
        if (!Auth::user()->isAdmin()) {
            // TODO Improve this piece by using Auth::user->report_sheets, then use the Laravel Collection where and select functions
            $reportSheets = ReportSheet::join('users', 'report_sheets.user_id', '=', 'users.id')
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
            return ReportSheet::join('users', 'users.id', '=', 'report_sheets.user_id')
                ->orderBy('start', 'desc')
                ->orderBy('end', 'desc')
                ->orderBy('users.zdp')
                ->get();
        }
    }

    // TODO reimplement POST route after finalizing frontend implementation
    // probably we need to set some attributes on initialization

    public function put($id, Request $request)
    {
        $validatedData = $this->validateRequest($request);

        ReportSheet::findOrFail($id)->update($validatedData);
        return $this->get($id);
    }

    private function validateRequest(Request $request)
    {
        return $this->validate($request, [
            'additional_workfree_comment' => 'string|nullable',
            'bank_account_number' => 'required|string',
            'clothes' => 'integer|nullable',
            'clothes_comment' => 'string|nullable',
            'company_holiday_vacation' => 'integer|nullable',
            'company_holiday_comment' => 'string|nullable',
            'company_holiday_holiday' => 'integer|nullable',
            'document_number' => 'integer|nullable',
            'driving_charges' => 'required|integer',
            'driving_charges_comment' => 'string|nullable',
            'end' => 'required|date',
            'extraordinarily' => 'required|integer',
            'extraordinarily_comment' => 'string|nullable',
            'holiday' => 'required|integer',
            'holiday_comment' => 'string|nullable',
            'ignore_first_last_day' => 'required|boolean',
            'ill' => 'required|integer',
            'ill_comment' => 'string|nullable',
            'start' => 'required|date',
            'state' => 'required|integer',
            'vacation' => 'required|integer',
            'vacation_comment' => 'string|nullable',
            'work' => 'integer|nullable',
            'work_comment' => 'string|nullable',
            'workfree' => 'integer|nullable',
            'workfree_comment' => 'string|nullable'
        ]);
    }
}
