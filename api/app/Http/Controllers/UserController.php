<?php

namespace App\Http\Controllers;

use Laravel\Lumen\Routing\Controller as BaseController;

use App;
use App\User;
use Illuminate\Http\JsonResponse;

class UserController extends BaseController
{
    /**
     * Get authenticated user.
     *
     * @return \Illuminate\Http\Response
     */
    public function getZivis()
    {
        $zivis = User::all();


        return         new JsonResponse([
            'data' => response()->json($zivis)
        ]);
        ;
    }
}
