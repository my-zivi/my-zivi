<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\RegionalCenter;

class RegionalCenterController extends Controller
{
    public function index()
    {
        return RegionalCenter::all();
    }
}
