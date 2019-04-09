<?php

namespace Tests\Integrations;

use App\Payment;
use App\PaymentEntry;
use App\ReportSheet;
use App\User;
use Laravel\Lumen\Testing\DatabaseTransactions;

class PaymentControllerTest extends \Tests\TestCase
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
                                            'payment_id' => $payment->id,
                                        ]);

        $this->asAdmin()->json('GET', 'api/payments/' . $payment->id)->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertEquals($payment->id, $response['id']);
        $this->assertCount(10, $response['payment_entries']);
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
        $this->asUser()->json('GET', 'api/payments/execute')->assertResponseStatus(401);
    }

    public function testGetIsoPaymentXmlAsAdmin()
    {
        $this->asAdmin()->json('GET', 'api/payments/execute')->assertResponseOk();
    }

    public function testIndexAsUser()
    {
        factory(Payment::class, 10)->create();
        $this->asUser()->json('GET', 'api/payments')->assertResponseStatus(401);
    }

    public function testIndexAsAdmin()
    {
        factory(Payment::class, 10)->create();
        $this->asAdmin()->json('GET', 'api/payments')->assertResponseOk();
        $this->assertCount(10, $this->responseToArray());
    }
}
