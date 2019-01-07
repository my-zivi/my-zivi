<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Specification;
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
}
