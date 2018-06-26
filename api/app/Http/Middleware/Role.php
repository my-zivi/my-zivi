<?php

namespace App\Http\Middleware;

use Closure;
use Tymon\JWTAuth\Facades\JWTAuth;

class Role
{
    /**
     * Only allow access for users with administrator role.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if (!JWTAuth::parseToken()->authenticate()->isAdmin()) {
            return response()->json('{"message": "Unauthorized - Only for administrators", "status_code": 401}', 401);
        }

        return $next($request);
    }
}
