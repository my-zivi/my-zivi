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

function scrub(string $s)
{
    //these are the characters supported by the postFinance api
    $pattern = '%[^a-zA-Z0-9\.,;:\'\+\-\/\(\)?\*\[\]\{\}\\`´~ !"#\%&<>÷=@_$£àáâäçèé ëìíîïñòóôöùúûüýßÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜÑ]%u';
    return preg_replace($pattern, '', $s);
}

class PaymentController extends Controller
{

    public function index()
    {
        // TODO Examine this logic and break it down into testable parts
        $openIDs = ReportSheet::select('id')
            ->where('state', '=', '1')->get();

        $result = array();
        $result["valid"] = array();
        $result["invalid"] = array();

        foreach ($openIDs as $id) {
            $sheet = ReportSheet::getSpesen($id->id);
            $item = array();
            $item['userid'] = $sheet['user'];
            $item['zdp'] = $sheet['zdp'];
            $item['first_name'] = $sheet['first_name'];
            $item['last_name'] = $sheet['last_name'];
            $item['address'] = $sheet['address'];
            $item['zip'] = $sheet['zip'];
            $item['city'] = $sheet['city'];
            $item['iban'] = strtoupper(str_replace(' ', '', $sheet['iban']));
            $item['bic'] = $sheet['bic'];
            $item['amount'] = $sheet['total'];
            $item['sheet_id'] = $id->id;

            if (strlen($item['address'])==0 || strlen($item['zip'])==0 || strlen($item['city'])==0) {
                $item['reason'] = "Adresse unvollständig";
            }
            if (strlen($item['iban'])==0 || !(new \IBAN($item['iban']))->VerifyMachineFormatOnly()) {
                $item['reason'] = "IBAN fehlt oder hat ungültiges Format";
            }

            if (isset($item['reason'])) {
                $result["invalid"][] = $item;
            } else {
                $result["valid"][] = $item;
            }
        }

        $result["archive"] = Payment::all();

        return new JsonResponse($result);
    }

    // TODO instead of delivering the relevant data through the frontend, do it through backend
    // the execute view in the frontend does not allow to modify anything, it just gives a preview of the payment
    // so instead of relying on data from a post request, we could calculate those information directly in the backend
    public function getIsoPaymentXml()
    {
        $elements = Input::get('data');
        $total = 0;
        $skipped = 0;
        foreach ($elements as $key => $element) {
            if ($element['amount'] <= 0) {
                $elements[$key]['skip'] = true;
                $skipped++;
            }
            $total += $element['amount'];
        }

        $id = date('Ymd').".".rand(1, 100000000);


        $xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<Document xmlns=\"http://www.six-interbank-clearing.com/de/pain.001.001.03.ch.02.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.six-interbank-clearing.com/de/pain.001.001.03.ch.02.xsd  pain.001.001.03.ch.02.xsd\">
	<CstmrCdtTrfInitn>
		<GrpHdr>
			<MsgId>SWO-M-".$id."</MsgId>
			<CreDtTm>".date('c')."</CreDtTm>
			<NbOfTxs>".(count($elements) - $skipped)."</NbOfTxs>
			<CtrlSum>".$total."</CtrlSum>
			<InitgPty>
				<Nm>".CompanyInfo::COMPANY_NAME."</Nm>
			</InitgPty>
		</GrpHdr>
		<PmtInf>
			<PmtInfId>SWO-P-".$id."</PmtInfId>
			<PmtMtd>TRF</PmtMtd>
			<ReqdExctnDt>".date('Y-m-d')."</ReqdExctnDt>
			<Dbtr>
				<Nm>".CompanyInfo::COMPANY_NAME."</Nm>
			</Dbtr>
			<DbtrAcct>
				<Id>
					<IBAN>".CompanyInfo::SPESEN_PAYMENT_IBAN."</IBAN>
				</Id>
			</DbtrAcct>
			<DbtrAgt>
				<FinInstnId>
					<BIC>".CompanyInfo::SPESEN_PAYMENT_BIC."</BIC>
				</FinInstnId>
			</DbtrAgt>";


        foreach ($elements as $key => $element) {
            if (isset($element['skip']) && $element['skip']) {
                continue;
            }
            // IID oder Clearing-Nummer: https://www.moneytoday.ch/lexikon/iid/
            // kann anstelle von BIC benutzt werden
            $iid = substr($element['iban'], 4, 5);
            $xml .= "
			<CdtTrfTxInf>
				<PmtId>
					<InstrId>SWO-I-".$id."-".$key."</InstrId>
					<EndToEndId>SWO-E-".$id."-".$key."</EndToEndId>
				</PmtId>
				<Amt>
					<InstdAmt Ccy=\"CHF\">".$element['amount']."</InstdAmt>
				</Amt>
				<CdtrAgt>
					<FinInstnId>
						<ClrSysMmbId>
						    <ClrSysId>
						        <Cd>CHBCC</Cd>
                            </ClrSysId>
                            <MmbId>$iid</MmbId>
                        </ClrSysMmbId>
					</FinInstnId>
				</CdtrAgt>
				<Cdtr>
					<Nm>".scrub($element['first_name'])." ".scrub($element['last_name'])."</Nm>
					<PstlAdr>
						<StrtNm>".scrub($element['address'])."</StrtNm>
						<PstCd>".scrub($element['zip'])."</PstCd>
						<TwnNm>".scrub($element['city'])."</TwnNm>
						<Ctry>CH</Ctry>
					</PstlAdr>
				</Cdtr>
				<CdtrAcct>
					<Id>
						<IBAN>".$element['iban']."</IBAN>
					</Id>
				</CdtrAcct>
			</CdtTrfTxInf>";
        }

        $xml .= "
		</PmtInf>
	</CstmrCdtTrfInitn>
</Document>";

        $payment = new Payment();
        $payment->xml = $xml;
        $payment->amount = $total*100;
        $payment->save();

        foreach ($elements as $element) {
            $sheet = ReportSheet::find($element['sheet_id']);
            $sheet->state = 2;
            $sheet->save();

            $paymentEntry = new PaymentEntry();
            $paymentEntry->payment_id = $payment->id;
            $paymentEntry->amount = $element['amount']*100;
            $paymentEntry->user_id = $element['userid'];
            $paymentEntry->iban = $element['iban'];
            $paymentEntry->report_sheet_id = $element['sheet_id'];
            $paymentEntry->save();
        }

        return [
            'xml' => $xml,
            'filename' => $this->generatePaymentName($payment),
        ];
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
        $payment = Payment::find($id);
        return (new Response($payment->xml, 200))
            ->header('Content-Type', 'application/xml')
            ->header('Content-Disposition', 'attachment; filename="'.$this->generatePaymentName($payment).'"');
    }

    private function generatePaymentName(Payment $payment)
    {
        return "zahlung-{$payment->id}_{$payment->updated_at->format('Y-m-d')}.xml";
    }
}
