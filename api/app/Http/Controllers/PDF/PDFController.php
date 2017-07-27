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
use Laravel\Lumen\Application;

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

        $response = response()->download($reportSheet->createPDF(), 'spesenrapport.pdf')
            ->deleteFileAfterSend(true);
        $response->headers->set("Content-Type", "application/pdf");
        $response->headers->set("Content-Disposition", "inline");
        return $response;
    }
}
