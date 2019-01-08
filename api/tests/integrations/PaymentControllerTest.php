<?php

namespace Tests\Integrations;

use App\Payment;
use Laravel\Lumen\Testing\DatabaseTransactions;

class PaymentControllerTest extends \TestCase
{
    use DatabaseTransactions;

    public function testIndexAsUser()
    {
        factory(Payment::class, 10)->create();
        $this->asUser()->json('GET', 'api/payments')->assertResponseStatus(401);
    }

    public function testIndexAsAdmin()
    {
        factory(Payment::class, 10)->create();
        $this->asAdmin()->json('GET', 'api/payments')->assertResponseOk();
    }
}
