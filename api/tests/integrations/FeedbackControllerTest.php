<?php

namespace test\integrations;

use App\Mission;
use App\UserFeedback;
use App\UserFeedbackQuestion;
use Laravel\Lumen\Testing\DatabaseTransactions;
use TestCase;

class FeedbackControllerTest extends TestCase
{
    use DatabaseTransactions;

    public function testIndex()
    {
        factory(UserFeedbackQuestion::class)->create();
        $this->authJson('GET', 'api/user_feedback_questions', 'zivi')->assertResponseOk();
        $this->assertCount(count(UserFeedbackQuestion::all()), $this->responseToArray()['user_feedback_questions']);
    }

    public function testGetFeedbacks()
    {
         factory(UserFeedback::class)->create();

        // zivi should not access the feedback
        $this->authJson('GET', 'api/user/feedback', 'zivi')->assertResponseStatus(401);

        // but admin should be abe to get the feedback
        $this->authJson('GET', 'api/user/feedback', 'admin')->assertResponseOk();
    }

    public function testGetFeedback()
    {
        $feedback = factory(UserFeedback::class)->create();

        // zivi should not access the feedback
        $this->authJson('GET', 'api/user/feedback/' . $feedback->feedbackId, 'zivi')->assertResponseStatus(401);

        // but admin should be abe to get the feedback
        $this->authJson('GET', 'api/user/feedback/' . $feedback->feedbackId, 'admin')->assertResponseOk();
    }

    public function testPostFeedback()
    {
        $mission = factory(Mission::class)->create();
        $userFeedbackQuestion1 = factory(UserFeedbackQuestion::class)->create();
        $userFeedbackQuestion2 = factory(UserFeedbackQuestion::class)->create();

        $countBeforeInsert = count(UserFeedback::all());

        $this->authJson('POST', 'api/user/feedback', 'zivi', [
            'missionId' => $mission->id,
            'answers' => [
                [
                    'id' => $userFeedbackQuestion1->id,
                    'answer' => 'some value'
                ], [
                    'id' => $userFeedbackQuestion2->id,
                    'answer' => 'some other value'
                ]
            ]
        ])->assertResponseOk();

        $this->assertCount($countBeforeInsert + 2, UserFeedback::all());
    }
}
