<?php

namespace Tests\Integrations;

use App\Specification;
use Laravel\Lumen\Testing\DatabaseTransactions;

class SpecificationControllerTest extends \Tests\TestCase
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

    public function testPostAsUser()
    {
        $this->asUser()->json('POST', 'api/specifications', [])->assertResponseStatus(401);
    }

    public function testPostAsAdminWithInvalidData()
    {
        $this->asAdmin()->json('POST', 'api/specifications', [])->assertResponseStatus(422);
    }

    public function testPostAsAdminWithValidData()
    {
        $specificationTemplate = factory(Specification::class)->make()->toArray();
        $this->asAdmin()->json('POST', 'api/specifications', $specificationTemplate);
        $this->assertResponseMatchesTemplate($specificationTemplate, true);
    }

    public function testPutAsUser()
    {
        $specification = factory(Specification::class)->create();
        $this->asUser()->json('PUT', 'api/specifications/' . $specification->id, [])->assertResponseStatus(401);
    }

    public function testPutAsAdminWithInvalidId()
    {
        $this->asAdmin()->json('PUT', 'api/specifications/238402830922', factory(Specification::class)->make()->toArray())->assertResponseStatus(404);
    }

    public function testPutAsAdminWithInvalidData()
    {
        $specification = factory(Specification::class)->create();
        $this->asAdmin()->json('PUT', 'api/specifications/' . $specification->id, [])->assertResponseStatus(422);
    }

    public function testPutAsAdminWithValidData()
    {
        $originalSpecification = factory(Specification::class)->create();
        $specificationTemplate = factory(Specification::class)->make()->toArray();

        $this->asAdmin()->json('PUT', 'api/specifications/' . $originalSpecification->id, $specificationTemplate);
        $this->assertResponseMatchesTemplate($specificationTemplate, true);
    }
}
