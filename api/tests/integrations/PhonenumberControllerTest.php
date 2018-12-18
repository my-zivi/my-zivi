<?php

namespace tests\integrations;

use Laravel\Lumen\Testing\DatabaseTransactions;
use TestCase;

class PhonenumberControllerTest extends TestCase
{
    use DatabaseTransactions;

    public function validationData()
    {
        return [
            ['0791234567', true, '079 123 45 67'],
            ['+41791234567', true, '079 123 45 67'],
            ['0041791234567', true, '079 123 45 67'],
            ['00447855078869', true, '00 44 7855 078869'],
            ['123', false],
            ['alsjkdlaskjd', false],
        ];
    }

    /**
     * @param string $number
     * @param bool $valid
     * @param string $formatted
     *
     * @dataProvider validationData
     */
    public function testValidate($number, $valid, $formatted = '')
    {
        $response = $this->asUser()->json('POST', 'api/phonenumber/validate', [
            'phonenumber' => $number,
        ]);

        $response
            ->seeJson([
                'is_valid' => $valid,
                'formatted' => $formatted,
            ])
            ->assertResponseOk();
    }
}
