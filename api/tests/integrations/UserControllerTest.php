<?php

namespace tests\integrations;

use Laravel\Lumen\Testing\DatabaseTransactions;
use TestCase;

class UserControllerTest extends TestCase
{
    use DatabaseTransactions;

    public function testGetIndex()
    {
        factory(\App\User::class, 'user_with_admin')->times(10)->create();
        factory(\App\User::class, 10)->create();

        $this->asAdmin()->json('GET', 'api/users');
        $response = $this->responseToArray();
        $this->assertCount(count(\App\User::all()), $response);
        $this->assertArrayHasKey('missions', $response[0]);
        $this->assertArrayHasKey('user_role', $response[0]);
    }

    public function testGetSelf()
    {
        $self = factory(\App\User::class)->create();

        $this->asUser($self)->json('GET', 'api/users/me')->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertEquals($self->id, $response['id']);
        $this->assertEquals($self->address, $response['address']);
        $this->assertArrayHasKey('missions', $response);
    }

    public function testUpdateSelf()
    {
        $self = factory(\App\User::class)->create();

        $this->asUser($self)->json('GET', 'api/users/me');
        $responseData = $this->responseToArray();

        $new = 'test address 123';
        $responseData['address'] = $new;

        $this->asUser($self)->json('PUT', 'api/users/me', $responseData);

        $this->asUser($self)->json('GET', 'api/users/me')->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertEquals($self->id, $response['id']);
        $this->assertEquals($new, $response['address']);
    }

    public function testValidChangePassword()
    {
        $old = 'oldpass';
        $new = 'newpass';
        $self = factory(\App\User::class)->create([
            'password' => app('hash')->make($old)
        ]);

        $response = $this->asUser($self)->json('POST', 'api/users/change_password', [
            'old_password' => $old,
            'new_password' => $new,
            'new_password_2' => $new,
        ]);

        $response->assertResponseOk();
        $this->assertSame('Ihr Passwort wurde angepasst.', $response->response->getOriginalContent());

        $this->json('post', 'api/auth/login', [
            'email' => $self->email,
            'password' => $old
        ])->assertResponseStatus(401);

        $this->json('post', 'api/auth/login', [
            'email' => $self->email,
            'password' => $new
        ])->assertResponseOk();
    }

    public function testChangePasswordOldPasswordEmpty()
    {
        $self = factory(\App\User::class)->create();
        $this->asUser($self)->json('POST', 'api/users/change_password', [])->assertResponseStatus(406);
        $this->assertContains('Altes Passwort darf nicht leer sein!', $this->responseToArray());
    }

    public function testChangePasswordOldPasswordWrong()
    {
        $self = factory(\App\User::class)->create();
        $this->asUser($self)->json('POST', 'api/users/change_password', [
            'old_password' => 'schabdudisianidniasdasq2413'
        ])->assertResponseStatus(406);
        $this->assertContains('Altes Passwort stimmt nicht!', $this->responseToArray());
    }

    public function testChangePasswordNewPasswordsMismatch()
    {
        $old = 'oldpass';
        $self = factory(\App\User::class)->create([
            'password' => app('hash')->make($old)
        ]);

        $this->asUser($self)->json('POST', 'api/users/change_password', [
            'old_password' => $old,
            'new_password' => 'Hans',
            'new_password_2' => 'Heiri'
        ])->assertResponseStatus(406);
        $this->assertContains('Die neuen Passwörter stimmen nicht überein!', $this->responseToArray());
    }

    public function testChangePasswordNewPasswordsTooShort()
    {
        $old = 'oldpass';
        $self = factory(\App\User::class)->create([
            'password' => app('hash')->make($old)
        ]);

        $this->asUser($self)->json('POST', 'api/users/change_password', [
            'old_password' => $old,
            'new_password' => 'Hans',
            'new_password_2' => 'Hans'
        ])->assertResponseStatus(406);
        $this->assertContains('Das Passwort muss aus mindestens 7 Zeichen bestehen!', $this->responseToArray());
    }
}
