<?php

namespace App\Http\Controllers\API;

use App\Holiday;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class HolidayController extends Controller
{
    public function delete($id)
    {
        Holiday::findOrFail($id)->delete();
        return 'Entity deleted';
    }

    public function index()
    {
        return Holiday::all();
    }

    public function post(Request $request)
    {
        $validatedData = $this->validateRequest($request);

        Holiday::create($validatedData);
        return $this->index();
    }

    public function put($id, Request $request)
    {
        $validatedData = $this->validateRequest($request);

        Holiday::findOrFail($id)->update($validatedData);
        return $this->index();
    }

    private function validateRequest(Request $request)
    {
        return $this->validate($request, [
            'date_from' => 'required|date',
            'date_to' => 'required|date',
            'description' => 'required|string',
            'holiday_type_id' => 'required|integer'
        ]);
    }
}
