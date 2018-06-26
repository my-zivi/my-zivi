<?php

use Laravel\Lumen\Testing\DatabaseTransactions;

class UserTest extends TestCase
{
    use DatabaseTransactions;

    public function testGetSelf()
    {
        $self = factory(\App\User::class)->create();

        $response = $this->authJson('GET', 'api/user', $self);

        $response->seeJson([
            'id' => $self->id,
            'address' => $self->address,
        ])->assertResponseOk();
    }

    public function testUpdateSelf()
    {
        $self = factory(\App\User::class)->create();

        $response = $this->authJson('GET', 'api/user', $self);
        $responseData = $response->response->getOriginalContent();

        $new = 'test address 123';
        $responseData['address'] = $new;

        $response = $this->authJson('POST', 'api/user/me', $self, $responseData);
        $response->assertResponseOk();

        $response = $this->authJson('GET', 'api/user', $self);
        $response->seeJson([
            'id' => $self->id,
            'address' => $new,
        ])->assertResponseOk();
    }

    public function testChangePassword()
    {
        $old = 'oldpass';
        $new = 'newpass';
        $self = factory(\App\User::class)->create([
            'password' => app('hash')->make($old)
        ]);

        $response = $this->authJson('POST', 'api/postChangePassword', $self, [
            'old_password' => $old,
            'new_password' => $new,
            'new_password_2' => $new,
        ]);

        $response->assertResponseOk();
        $this->assertSame('Ihr Passwort wurde angepasst.', $response->response->getOriginalContent());

        $this->json('post', 'api/auth/login', [
            'email'     => $self->email,
            'password'  => $old
        ])->assertResponseStatus(401);

        $this->json('post', 'api/auth/login', [
            'email'     => $self->email,
            'password'  => $new
        ])->assertResponseOk();
    }
}
