<?php

namespace Tests\Integrations;

use App\Holiday;
use Laravel\Lumen\Testing\DatabaseTransactions;

class HolidayControllerTest extends \Tests\TestCase
{
    use DatabaseTransactions;

    public function testIndexWithNormalUser()
    {
        factory(Holiday::class, 10)->create();
        $this->asUser()->json('GET', 'api/holidays')->assertResponseStatus(401);
    }

    public function testIndexWithAdminUser()
    {
        factory(Holiday::class, 10)->create();
        $this->asAdmin()->json('GET', 'api/holidays')->assertResponseOk();
        $this->assertCount(count(Holiday::all()), $this->responseToArray());
    }

    public function testPostAsUser()
    {
        $this->asUser()->json('POST', 'api/holidays', [])->assertResponseStatus(401);
    }

    public function testPostAsAdminWithInvalidData()
    {
        $this->asAdmin()->json('POST', 'api/holidays', [])->assertResponseStatus(422);
    }

    public function testPostAsAdminWithValidData()
    {
        $holidayTemplate = factory(Holiday::class)->make()->toArray();
        $this->asAdmin()->json('POST', 'api/holidays', $holidayTemplate);
        $this->assertResponseMatchesTemplate($holidayTemplate, true);
    }

    public function testPutAsUser()
    {
        $specification = factory(Holiday::class)->create();
        $this->asUser()->json('PUT', 'api/holidays/' . $specification->id, [])->assertResponseStatus(401);
    }

    public function testPutAsAdminWithInvalidId()
    {
        $this->asAdmin()->json('PUT', 'api/holidays/34032804928', factory(Holiday::class)->make()->toArray());
        $this->assertResponseStatus(404);
    }

    public function testPutAsAdminWithInvalidData()
    {
        $specification = factory(Holiday::class)->create();
        $this->asAdmin()->json('PUT', 'api/holidays/' . $specification->id, [])->assertResponseStatus(422);
    }

    public function testPutAsAdminWithValidData()
    {
        $originalHoliday = factory(Holiday::class)->create();
        $holidayTemplate = factory(Holiday::class)->make()->toArray();

        $this->asAdmin()->json('PUT', 'api/holidays/' . $originalHoliday->id, $holidayTemplate);
        $this->assertResponseMatchesTemplate($holidayTemplate, true);
    }

    public function testDeleteWithAdmin()
    {
        $holidayId = factory(Holiday::class)->create()->id;
        $this->asUser()->json('DELETE', 'api/holidays/' . $holidayId)->assertResponseStatus(401);
    }

    public function testInvalidDelete()
    {
        // can't delete because object does not exist
        $this->asAdmin()->json('DELETE', 'api/holidays/1789764')->assertResponseStatus(404);
    }

    public function testValidDelete()
    {
        $holidayId = factory(Holiday::class)->create()->id;
        $this->asAdmin()->json('DELETE', 'api/holidays/' . $holidayId)->assertResponseOk();
        $this->assertEquals('Entity deleted', $this->response->getContent());
    }
}
