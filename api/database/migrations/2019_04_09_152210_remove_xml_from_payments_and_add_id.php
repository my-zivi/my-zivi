<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class RemoveXmlFromPaymentsAndAddId extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('payments', function (Blueprint $table) {
            $table->string('xml_id')->default('2017-01-01.123456789');
            $table->string('xml_date')->default('2017-01-01');
        });

        $payments = \App\Payment::get();
        $payments->each(function ($payment) {
           $xml_id = $this->getIdFromXml($payment->xml);
           $xml_date = $this->getDateFromXml($payment->xml);
           DB::table('payments')->where('id', $payment->id)
               ->update(['xml_id' => $xml_id, 'xml_date' => $xml_date]);
        });





        Schema::table('payments', function (Blueprint $table) {
            $table->dropColumn('xml');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        // Adding xml column
        Schema::table('payments', function (Blueprint $table) {
            $table->addColumn('text', 'xml')->after('deleted_at');
        });

        // Filling xml column
        $payments = \App\Payment::get();
        $payments->each(function ($payment) {
            $sheets = \App\ReportSheet::whereHas('paymentEntry.payment', function ($query) use ($payment) {
                return $query->where('id', $payment->id);
            })->get();
            $validSheets = $sheets->where('total_costs', '>', 0);

            $xml = $this->getXmlFromIdAndDate($validSheets, $payment->xml_id, \Carbon\Carbon::parse($payment->xml_date));
            DB::table('payments')->where('id', $payment->id)
                ->update(['xml' => $xml]);
        });




        // Dropping xml_id column
        Schema::table('payments', function (Blueprint $table) {
            $table->dropColumn('xml_id');
            $table->dropColumn('xml_date');
        });
    }

    private function getXmlFromIdAndDate($validSheets, $xml_id, $xml_date) {
        $ci = [
            "company_name"        => \App\CompanyInfo::COMPANY_NAME,
            "spesen_payment_iban" => \App\CompanyInfo::SPESEN_PAYMENT_IBAN,
            "spesen_payment_bic"  => \App\CompanyInfo::SPESEN_PAYMENT_BIC,
        ];

        $data = [
            "validSheets" => $validSheets,
            "ci"          => $ci,
            "total"       => $validSheets->sum('total_costs'),
            "id"          => $xml_id,
            "xmlDate"     => $xml_date,
        ];

        $twigXml = Twig::render('payment', $data);

        return $twigXml;
    }

    private function getIdFromXml($xml) {
        $matches = [];
        preg_match("/<MsgId>SWO-M-(\d*?\.\d*?)<\/MsgId>/", $xml, $matches);
        if (count($matches) > 0) {
            return $matches[1];
        }
        return "id-not-found";
    }

    private function getDateFromXml($xml) {
        $matches = [];
        preg_match("/<CreDtTm>(.*?)<\/CreDtTm>/", $xml, $matches);
        if (count($matches) > 0) {
            return \Carbon\Carbon::parse($matches[1])->format('c');
        }
        return "now";
    }
}
