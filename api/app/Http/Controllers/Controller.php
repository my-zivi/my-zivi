<?php

namespace App\Http\Controllers;

use Laravel\Lumen\Routing\Controller as BaseController;

class Controller extends BaseController
{
    protected function respondWithUnauthorized()
    {
        return response()->json("You don't have the required permissions to perform this action.", 401);
    }
}
