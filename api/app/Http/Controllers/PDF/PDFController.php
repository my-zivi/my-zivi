<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 7/25/17
 * Time: 11:15 AM
 */

namespace App\Http\Controllers\PDF;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Request;
use Laravel\Lumen\Application;
use Tymon\JWTAuth\Facades\JWTAuth;

class PDFController extends Controller
{

    public function getPhoneList(Application $app)
    {
        $from = strtotime(Input::get("start", ""));
        $to = strtotime(Input::get("end", ""));

        $phoneList = new PhoneListPDF($from, $to);

        $response =  response()->download($phoneList->createPDF(), 'phonelist.pdf')
            ->deleteFileAfterSend(true);
        $response->headers->set("Content-Type", "application/pdf");
        $response->headers->set("Content-Disposition", "inline");
        return $response;
    }


    public function getZiviReportSheet(Application $app)
    {

        $reportSheetId = Input::get("reportSheetId");

        $reportSheet = new ZiviReportSheetPDF($reportSheetId);

        //Allow only admins to get reportSheets of other Users
        $user = JWTAuth::parseToken()->authenticate();
        if ($user->role!=1 && ($user->id!=$reportSheet->getUserId() || !$reportSheet->isDone())) {
            return response("unauthorized", 401);
        }

        $response = response()
            ->download($reportSheet->createPDF(), 'spesenrapport.pdf', ["Content-Type" => "application/pdf"], 'inline')
            ->deleteFileAfterSend(true);
        return $response;
    }

    public function getSpesenStatistik(Application $app)
    {
        $showOnlyDoneSheets = Input::get("showOnlyDoneSheets")==1;
        $showDetails = Input::get("showDetails")==1;
        $time_type = Input::get("time_type");
        $time_from = strtotime(Input::get("time_from"));
        $time_to = strtotime(Input::get("time_to"));
        $time_year = Input::get("time_year");

        $statistik = new SpesenStatistik(
            $showOnlyDoneSheets,
            $showDetails,
            $time_type,
            $time_from,
            $time_to,
            $time_year
        );

        $response = response()->download($statistik->createPDF(), 'statistik.pdf')
            ->deleteFileAfterSend(true);
        $response->headers->set("Content-Type", "application/pdf");
        $response->headers->set("Content-Disposition", "inline");
        return $response;
    }

    public function getAufgebot(Application $app, $id)
    {
        $aufgebot = new AufgebotPDF($id);

        //Allow only admins to get reportSheets of other Users
        $user = JWTAuth::parseToken()->authenticate();
        if ($user->role!=1 && $user->id!=$aufgebot->getUserId()) {
            return response("unauthorized", 401);
        }


        $response = response()->download($aufgebot->createPDF(), 'aufgebot.pdf')
            ->deleteFileAfterSend(true);
        $response->headers->set("Content-Type", "application/pdf");
        $response->headers->set("Content-Disposition", "inline");
        return $response;
    }
}
