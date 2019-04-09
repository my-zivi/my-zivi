<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 7/25/17
 * Time: 11:15 AM
 */

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Services\PDF\AufgebotPDF;
use App\Services\PDF\PhoneListPDF;
use App\Services\PDF\SpesenStatistik;
use App\Services\PDF\ZiviReportSheetPDF;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Input;
use Laravel\Lumen\Application;

class PDFController extends Controller
{

    public function getPhoneList(Request $request)
    {
        $validatedData = $this->validate($request, [
            'end'   => 'required|date',
            'start' => 'required|date',
        ]);

        $phoneList = new PhoneListPDF($validatedData['start'], $validatedData['end']);

        $response = response()->download($phoneList->createPDF(), 'phonelist.pdf')
            ->deleteFileAfterSend(true);
        $response->headers->set("Content-Type", "application/pdf");
        $response->headers->set("Content-Disposition", "inline");
        return $response;
    }


    public function getZiviReportSheet($id)
    {
        $reportSheet = new ZiviReportSheetPDF($id);

        if (Auth::user()->isAdmin() || (Auth::id() == $reportSheet->getUserId() && $reportSheet->isDone())) {
            $response = response()
                ->download($reportSheet->createPDF(), 'spesenrapport.pdf', ["Content-Type" => "application/pdf"], 'inline')
                ->deleteFileAfterSend(true);
            return $response;
        } else {
            return $this->respondWithUnauthorized();
        }
    }

    public function getSpesenStatistik(Request $request)
    {
        // because we use a get request, the bool are sent as string, which ends up kinda ugly
        $this->validate($request, [
            'date_from'        => 'date',
            'date_to'          => 'date',
            'time_type'        => 'integer',
            'detail_view'      => 'string',
            'only_done_sheets' => 'string',
            'year'             => 'integer',
        ]);

        $statistik = new SpesenStatistik(
            Input::get("only_done_sheets") === 'true',
            Input::get("detail_view") === 'true',
            Input::get("time_type"),
            strtotime(Input::get("date_from")),
            strtotime(Input::get("date_to")),
            Input::get("year")
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
        $user = Auth::user();
        if (!$user->isAdmin() && $user->id != $aufgebot->getUserId()) {
            return response("unauthorized", 401);
        }

        $response = response()->download($aufgebot->createPDF(), 'aufgebot.pdf')
            ->deleteFileAfterSend(true);
        $response->headers->set("Content-Type", "application/pdf");
        $response->headers->set("Content-Disposition", "inline");
        return $response;
    }
}
