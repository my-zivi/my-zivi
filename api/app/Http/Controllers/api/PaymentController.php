<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 8/28/17
 * Time: 3:05 PM
 */

namespace App\Http\Controllers\API;

use App\CompanyInfo;
use App\Http\Controllers\Controller;
use App\Payment;
use App\PaymentEntry;
use App\ReportSheet;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Input;
use Twig;

function scrub(string $s)
{
    //these are the characters supported by the postFinance api
    $pattern = '%[^a-zA-Z0-9\.,;:\'\+\-\/\(\)?\*\[\]\{\}\\`´~ !"#\%&<>÷=@_$£àáâäçèé ëìíîïñòóôöùúûüýßÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜÑ]%u';
    return preg_replace($pattern, '', $s);
}

class PaymentController extends Controller
{

    public function get($id)
    {
        return Payment::with(['paymentEntries', 'paymentEntries.user', 'paymentEntries.reportSheet'])->findOrFail($id);
    }

    public function index()
    {
        return Payment::all();
    }


    public function getIsoPaymentXml()
    {
        $openSheets = ReportSheet::with('user')->where('state', '=', '1')->get();
        $validSheets = $openSheets->where('total_costs', '>', 0);

        $payment = new Payment();
        $payment->xml = "";
        $payment->save();

        $openSheets->each(function ($sheet) use ($payment) {
            $sheet->state = 2;
            $sheet->save();

            $paymentEntry = new PaymentEntry();
            $paymentEntry->payment_id = $payment->id;
            $paymentEntry->amount = $sheet->total_costs;
            $paymentEntry->user_id = $sheet->user_id;
            $paymentEntry->iban = $sheet->user->clean_iban;
            $paymentEntry->report_sheet_id = $sheet->id;
            $paymentEntry->save();
        });

        return (new Response($this->renderPaymentXml($validSheets), 200))
            ->header('Content-Type', 'application/xml')
            ->header('Content-Disposition', 'attachment; filename="'.$this->generatePaymentName($payment).'"');
    }

    public function getArchivedPayment($id)
    {
        $payment = Payment::find($id);
        $payment->sheets = PaymentEntry::
            join('users', 'users.id', '=', 'payment_entries.user_id')
            ->join('report_sheets', 'report_sheets.id', '=', 'payment_entries.report_sheet_id')
            ->select('amount', 'report_sheet_id', 'first_name', 'last_name', 'zdp', 'users.id AS userid', 'iban', 'state')
            ->where('payment_id', '=', $id)->get();
        return new JsonResponse($payment);
    }

    public function getArchivedXml($id)
    {
        $payment = Payment::select(['id', 'updated_at'])->find($id);
        $sheets = ReportSheet::whereHas('paymentEntry.payment', function ($query) use ($id) {
            return $query->where('id', $id);
        })->get();
        $validSheets = $sheets->where('total_costs', '>', 0);

        return (new Response($this->renderPaymentXml($validSheets), 200))
            ->header('Content-Type', 'application/xml')
            ->header('Content-Disposition', 'attachment; filename="'.$this->generatePaymentName($payment).'"');
    }


    private function renderPaymentXml($validSheets)
    {
        $ci = [
            "company_name"        => CompanyInfo::COMPANY_NAME,
            "spesen_payment_iban" => CompanyInfo::SPESEN_PAYMENT_IBAN,
            "spesen_payment_bic"  => CompanyInfo::SPESEN_PAYMENT_BIC,
        ];

        $data = [
            "validSheets" => $validSheets,
            "ci"          => $ci,
            "total"       => $validSheets->sum('total_costs'),
            "id"          => date('Ymd').".".rand(1, 100000000),
        ];

        $twigXml = Twig::render('payment', $data);

        return $twigXml;
    }

    private function generatePaymentName(Payment $payment)
    {
        return "zahlung-{$payment->id}_{$payment->updated_at->format('Y-m-d')}.xml";
    }
}
