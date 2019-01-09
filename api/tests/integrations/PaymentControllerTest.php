<?php

namespace Tests\Integrations;

use App\Payment;
use App\PaymentEntry;
use App\ReportSheet;
use App\User;
use Laravel\Lumen\Testing\DatabaseTransactions;

class PaymentControllerTest extends \TestCase
{
    use DatabaseTransactions;

    public function testGetAsUser()
    {
        $paymentId = factory(Payment::class)->create()->id;
        $this->asUser()->json('GET', 'api/payments/' . $paymentId)->assertResponseStatus(401);
    }

    public function testGetAsAdmin()
    {
        $payment = factory(Payment::class)->create();
        factory(PaymentEntry::class, 10)->create([
            'payment_id' => $payment->id
        ]);

        $this->asAdmin()->json('GET', 'api/payments/' . $payment->id)->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertCount(10, $response['sheets']);
    }

    public function testGetXmlAsUser()
    {
        $paymentId = factory(Payment::class)->create()->id;
        $this->asUser()->json('GET', 'api/payments/' . $paymentId . '/xml')->assertResponseStatus(401);
    }

    public function testGetXmlAsAdmin()
    {
        $payment = factory(Payment::class)->create();

        $this->asAdmin()->json('GET', 'api/payments/' . $payment->id . '/xml')->assertResponseOk();
        $this->assertTrue($this->response->headers->get('content-type') == 'application/xml');
    }

    public function testGetIsoPaymentXmlAsUser()
    {
        $this->asUser()->json('POST', 'api/payments/execute', [])->assertResponseStatus(401);
    }

    public function testGetIsoPaymentXmlAsAdmin()
    {
        $reportSheet1 = factory(ReportSheet::class)->create();
        $user1 = $reportSheet1->user;

        $reportSheet2 = factory(ReportSheet::class)->create();
        $user2 = $reportSheet1->user;

        $this->asAdmin()->json('POST', 'api/payments/execute', [
            'data' => [
                [
                    'address' => $user1->address,
                    'amount' => 1000,
                    'bic' => $user1->bank_bic,
                    'city' => $user1->city,
                    'first_name' => $user1->first_name,
                    'iban' => $user1->bank_iban,
                    'last_name' => $user1->last_name,
                    'sheet_id' => $reportSheet1->id,
                    'userid' => $user1->id,
                    'zdp' => $user1->zdp,
                    'zip' => $user1->zip
                ], [
                    'address' => $user2->address,
                    'amount' => 0,
                    'bic' => $user2->bank_bic,
                    'city' => $user2->city,
                    'first_name' => $user2->first_name,
                    'iban' => $user2->bank_iban,
                    'last_name' => $user2->last_name,
                    'sheet_id' => $reportSheet2->id,
                    'userid' => $user2->id,
                    'zdp' => $user2->zdp,
                    'zip' => $user2->zip
                ]
            ]
        ])->assertResponseOk();
    }

    public function testIndexAsUser()
    {
        factory(Payment::class, 10)->create();
        $this->asUser()->json('GET', 'api/payments')->assertResponseStatus(401);
    }

    public function testIndexAsAdmin()
    {
        factory(Payment::class, 10);
        factory(ReportSheet::class, 10)->create([
            'state' => 1
        ]);

        $this->asAdmin()->json('GET', 'api/payments')->assertResponseOk();
    }
}
