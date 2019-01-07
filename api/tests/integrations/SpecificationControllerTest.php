<?php

namespace Tests\Integrations;

use App\Specification;
use Laravel\Lumen\Testing\DatabaseTransactions;

class SpecificationControllerTest extends \TestCase
{
    use DatabaseTransactions;

    public function testGetIndexAsNonAdmin()
    {
        factory(Specification::class, 10)->create();
        $this->asUser()->json('GET', 'api/specifications')->assertResponseOk();

        $response = $this->responseToArray();
        $this->assertCount(count(Specification::all()), $response);
        $this->assertArrayHasKey('id', $response[0]);
        $this->assertArrayHasKey('active', $response[0]);
        $this->assertArrayHasKey('name', $response[0]);
        $this->assertArrayNotHasKey('working_breakfast_expenses', $response[0]);
        $this->assertArrayNotHasKey('firstday_breakfast_expenses', $response[0]);
    }

    public function testGetIndexAsAdmin()
    {
        factory(Specification::class, 10)->create();
        $this->asAdmin()->json('GET', 'api/specifications')->assertResponseOk();

        $response = $this->responseToArray();
        $this->assertCount(count(Specification::all()), $response);
        $this->assertArrayHasKey('id', $response[0]);
        $this->assertArrayHasKey('active', $response[0]);
        $this->assertArrayHasKey('name', $response[0]);
        $this->assertArrayHasKey('working_breakfast_expenses', $response[0]);
        $this->assertArrayHasKey('firstday_breakfast_expenses', $response[0]);
    }
}
