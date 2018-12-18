<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

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
        if (!Auth::user()->isAdmin()) {
            return response()->json('{"message": "Unauthorized - Only for administrators", "status_code": 401}', 401);
        }

        return $next($request);
    }
}
