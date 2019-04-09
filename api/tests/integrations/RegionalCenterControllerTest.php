<?php

namespace Tests\Integrations;

use App\RegionalCenter;
use Laravel\Lumen\Testing\DatabaseTransactions;

class RegionalCenterControllerTest extends \Tests\TestCase
{
    use DatabaseTransactions;

    public function testGetIndexAsAdmin()
    {
        factory(RegionalCenter::class, 10)->create();

        $this->asAdmin()->json('GET', 'api/regional_centers')->assertResponseOk();
        $this->assertCount(count(RegionalCenter::all()), $this->responseToArray());
    }

    public function testGetIndexAsUser()
    {
        factory(RegionalCenter::class, 10)->create();

        $this->asUser()->json('GET', 'api/regional_centers')->assertResponseOk();
        $this->assertCount(count(RegionalCenter::all()), $this->responseToArray());
    }
}
