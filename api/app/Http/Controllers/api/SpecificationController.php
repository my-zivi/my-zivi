<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Specification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SpecificationController extends Controller
{
    public function index()
    {
        if (Auth::user()->isAdmin()) {
            return Specification::all();
        } else {
            return Specification::all(['active', 'id', 'name']);
        }
    }

    public function post(Request $request)
    {
        $validatedData = $this->validateRequest($request);

        Specification::create($validatedData);
        return $this->index();
    }

    public function put($id, Request $request)
    {
        $validatedData = $this->validateRequest($request);

        Specification::findOrFail($id)->update($validatedData);
        return $this->index();
    }

    public function delete($id)
    {
        Specification::findOrFail($id)->delete();
        return 'Entity deleted';
    }

    private function validateRequest(Request $request)
    {
        return $this->validate($request, [
            'active' => 'required|boolean',
            'accommodation' => 'required|integer',
            'firstday_breakfast_expenses' => 'required|integer',
            'firstday_dinner_expenses' => 'required|integer',
            'firstday_lunch_expenses' => 'required|integer',
            'lastday_breakfast_expenses' => 'required|integer',
            'lastday_dinner_expenses' => 'required|integer',
            'lastday_lunch_expenses' => 'required|integer',
            'id' => 'required|string|regex:/^[0-9\d_]*$/',
            'name' => 'required|string',
            'pocket' => 'required|integer',
            'short_name' => 'required|string',
            'sparetime_breakfast_expenses' => 'required|integer',
            'sparetime_dinner_expenses' => 'required|integer',
            'sparetime_lunch_expenses' => 'required|integer',
            'working_breakfast_expenses' => 'required|integer',
            'working_clothes_expense' => 'required|integer',
            'working_clothes_payment' => 'string|nullable',
            'working_dinner_expenses' => 'required|integer',
            'working_lunch_expenses' => 'required|integer',
        ]);
    }
}
