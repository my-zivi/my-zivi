<?php

namespace tests\integrations;

use App\User;
use Laravel\Lumen\Testing\DatabaseTransactions;
use TestCase;

class UserControllerTest extends TestCase
{
    use DatabaseTransactions;

    public function testGetIndex()
    {
        factory(User::class, 'user_with_admin')->times(10)->create();
        factory(User::class, 10)->create();

        $this->asAdmin()->json('GET', 'api/users');
        $response = $this->responseToArray();
        $this->assertCount(count(User::all()), $response);
        $this->assertArrayHasKey('missions', $response[0]);
        $this->assertArrayHasKey('user_role', $response[0]);
    }

    public function testGetAsUser()
    {
        $self = factory(User::class)->create();

        $this->asUser($self)->json('GET', 'api/users/' . $self->id)->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertEquals($self->id, $response['id']);
        $this->assertEquals($self->address, $response['address']);
        $this->assertArrayHasKey('missions', $response);
        $this->assertArrayNotHasKey('internal_note', $response);
    }
    
    public function testGetOtherUserAsNormalUser()
    {
        $otherGuy = factory(User::class)->create();
        $requestingGuy = factory(User::class)->create();

        $this->asUser($requestingGuy)->json('GET', 'api/users/' . $otherGuy->id)->assertResponseStatus(401);
    }

    public function testGetOtherUserAsAdmin()
    {
        $otherGuy = factory(User::class)->create();

        $this->asAdmin()->json('GET', 'api/users/' . $otherGuy->id)->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertEquals($otherGuy->id, $response['id']);
        $this->assertEquals($otherGuy->address, $response['address']);
        $this->assertArrayHasKey('missions', $response);
        $this->assertArrayHasKey('internal_note', $response);
    }

    public function testUpdateSelf()
    {
        $self = factory(User::class)->create();

        $this->asUser($self)->json('GET', 'api/users/' . $self->id)->assertResponseOk();
        $responseData = $this->responseToArray();

        $new = 'test address 123';
        $responseData['address'] = $new;

        $this->asUser($self)->json('PUT', 'api/users/' . $self->id, $responseData)->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertEquals($self->id, $response['id']);
        $this->assertEquals($new, $response['address']);
        $this->assertArrayNotHasKey('internal_note', $response);
    }

    public function testUpdateOtherGuyAsNormalUser()
    {
        $self = factory(User::class)->create();
        $otherGuy = factory(User::class)->create();

        $this->asUser($self)->json('PUT', 'api/users/' . $otherGuy->id, [])->assertResponseStatus(401);
    }

    public function testUpdateOtherGuyAsAdmin()
    {
        $otherGuy = factory(User::class)->create();

        $otherGuyAsArray = $otherGuy->toArray();
        $otherGuyAsArray['address'] = 'New hip address from other guy';
        $otherGuyAsArray['internal_note'] = 'Internal note';

        $this->asAdmin()->json('PUT', 'api/users/' . $otherGuy->id, $otherGuyAsArray)->assertResponseOk();
        $response = $this->responseToArray();

        $this->assertEquals('New hip address from other guy', $response['address']);
        $this->assertEquals('Internal note', $response['internal_note']);
    }

    public function testValidChangePassword()
    {
        $old = 'oldpass';
        $new = 'newpass';
        $self = factory(User::class)->create([
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
        ])->assertResponseStatus(400);

        $this->json('post', 'api/auth/login', [
            'email' => $self->email,
            'password' => $new
        ])->assertResponseOk();
    }

    public function testChangePasswordOldPasswordEmpty()
    {
        $self = factory(User::class)->create();
        $this->asUser($self)->json('POST', 'api/users/change_password', [])->assertResponseStatus(406);
        $this->assertContains('Altes Passwort darf nicht leer sein!', $this->responseToArray());
    }

    public function testChangePasswordOldPasswordWrong()
    {
        $self = factory(User::class)->create();
        $this->asUser($self)->json('POST', 'api/users/change_password', [
            'old_password' => 'schabdudisianidniasdasq2413'
        ])->assertResponseStatus(406);
        $this->assertContains('Altes Passwort stimmt nicht!', $this->responseToArray());
    }

    public function testChangePasswordNewPasswordsMismatch()
    {
        $old = 'oldpass';
        $self = factory(User::class)->create([
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
        $self = factory(User::class)->create([
            'password' => app('hash')->make($old)
        ]);

        $this->asUser($self)->json('POST', 'api/users/change_password', [
            'old_password' => $old,
            'new_password' => 'Hans',
            'new_password_2' => 'Hans'
        ])->assertResponseStatus(406);
        $this->assertContains('Das Passwort muss aus mindestens 7 Zeichen bestehen!', $this->responseToArray());
    }

    public function testInvalidDelete()
    {
        // can't delete because object does not exist
        $this->asAdmin()->json('DELETE', 'api/users/1789764')->assertResponseStatus(404);
    }

    public function testValidDelete()
    {
        $userId = factory(User::class)->create()->id;
        $this->asAdmin()->json('DELETE', 'api/users/' . $userId)->assertResponseOk();
        $this->assertEquals('Entity deleted', $this->response->getContent());
    }
}
