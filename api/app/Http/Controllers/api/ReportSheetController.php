<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\ReportSheet;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;

class ReportSheetController extends Controller
{
    public function delete($id)
    {
        ReportSheet::findOrFail($id)->delete();
        return 'Entity deleted';
    }

    public function get($id)
    {
        return ReportSheet::with('mission', 'mission.specification', 'user')->findOrFail($id)->append(['duration', 'proposed_values', 'total_costs']);
    }

    public function index(Request $request)
    {
        if (!Auth::user()->isAdmin()) {
            // TODO Improve this piece by using Auth::user->report_sheets, then use the Laravel Collection where and select functions
            $reportSheets = ReportSheet::join('users', 'report_sheets.user_id', '=', 'users.id')
                ->select('report_sheets.id AS id', 'start', 'end', 'state')
                ->where('users.id', '=', Auth::id())
                ->where('state', '>', '0')
                ->get();

            // Add calculated column days
            $reportSheets->each(function ($r) {
                $r->append('duration');
            });

            return $reportSheets;
        } else {
            $validatedData = $this->validate($request, [
                'state' => [ Rule::in(['current', 'pending', 'ready_for_payment']) ],
            ]);

            if (!empty($validatedData['state']) && $validatedData['state'] === 'ready_for_payment') {
                return ReportSheet::with('user')->where('state', '=', 1)->get()->each->append('total_costs');
            }

            $builder = ReportSheet::with('user:first_name,last_name,zdp,id')
                ->orderBy('start', 'asc')
                ->orderBy('end', 'asc');


            if (!empty($validatedData['state'])) {
                if ($validatedData['state'] === 'pending') {
                    $builder = $builder->where('report_sheets.state', '!=', 3);
                } elseif ($validatedData['state'] === 'current') {
                    $builder = $builder->where('report_sheets.state', '=', 0)
                        ->whereDate('start', '>=', date('Y-m-d', strtotime('first day of last month')))
                        ->whereDate('end', '<', date('Y-m-d', strtotime('first day of next month')));
                }
            }

            return $builder->get([ 'end', 'report_sheets.id as id', 'start', 'user_id']);
//            select([ 'end', 'report_sheets.id as id', 'start', 'user_id'])
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

    public function putState($id, Request $request)
    {
        $validatedData = $this->validate($request, [
            'state' => 'required|integer',
        ]);

        $reportSheet = ReportSheet::findOrFail($id);
        $reportSheet->state = $validatedData['state'];
        $reportSheet->save();

        return response("updated");
    }

    private function validateRequest(Request $request)
    {
        return $this->validate($request, [
            'additional_workfree'         => 'integer|nullable',
            'additional_workfree_comment' => 'string|nullable',
            'bank_account_number'         => 'required|string',
            'clothes'                     => 'integer|nullable',
            'clothes_comment'             => 'string|nullable',
            'company_holiday_vacation'    => 'integer|nullable',
            'company_holiday_comment'     => 'string|nullable',
            'company_holiday_holiday'     => 'integer|nullable',
            'document_number'             => 'integer|nullable',
            'driving_charges'             => 'required|integer',
            'driving_charges_comment'     => 'string|nullable',
            'end'                         => 'required|date',
            'extraordinarily'             => 'required|integer',
            'extraordinarily_comment'     => 'string|nullable',
            'holiday'                     => 'required|integer',
            'holiday_comment'             => 'string|nullable',
            'ignore_first_last_day'       => 'required|boolean',
            'ill'                         => 'required|integer',
            'ill_comment'                 => 'string|nullable',
            'start'                       => 'required|date',
            'state'                       => 'required|integer',
            'vacation'                    => 'required|integer',
            'vacation_comment'            => 'string|nullable',
            'work'                        => 'integer|nullable',
            'work_comment'                => 'string|nullable',
            'workfree'                    => 'integer|nullable',
            'workfree_comment'            => 'string|nullable',
        ]);
    }
}
