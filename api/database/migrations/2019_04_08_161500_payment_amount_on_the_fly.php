<?php
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class PaymentAmountOnTheFly extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('payments', function (Blueprint $table) {
           $table->dropColumn('amount');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('payments', function (Blueprint $table) {
            $table->addColumn('integer', 'amount')->after('deleted_at');
        });
//        $payments = DB::table('payments')->select('id')->get();
        $payments = \App\Payment::get();
        $payments->each(function ($payment) {
           $amount = $payment->amount;
           DB::table('payments')->where('id', $payment->id)
               ->update(['amount' => $amount]);
        });
    }
}
