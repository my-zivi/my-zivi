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
        $this->asUser()->json('GET', 'api/user_feedback_questions')->assertResponseOk();
        $this->assertCount(count(UserFeedbackQuestion::all()), $this->responseToArray());
    }

    public function testGetFeedbacks()
    {
         factory(UserFeedback::class)->create();

        // zivi should not access the feedback
        $this->asUser()->json('GET', 'api/user/feedback')->assertResponseStatus(401);

        // but admin should be abe to get the feedback
        $this->asAdmin()->json('GET', 'api/user/feedback')->assertResponseOk();
    }

    public function testGetFeedback()
    {
        $feedback = factory(UserFeedback::class)->create();

        // zivi should not access the feedback
        $this->asUser()->json('GET', 'api/user/feedback/' . $feedback->feedbackId)->assertResponseStatus(401);

        // but admin should be abe to get the feedback
        $this->asAdmin()->json('GET', 'api/user/feedback/' . $feedback->feedbackId)->assertResponseOk();
    }

    public function testPostFeedback()
    {
        $mission = factory(Mission::class)->create();
        $userFeedbackQuestion1 = factory(UserFeedbackQuestion::class)->create();
        $userFeedbackQuestion2 = factory(UserFeedbackQuestion::class)->create();

        $countBeforeInsert = count(UserFeedback::all());

        $this->asUser()->json('POST', 'api/user/feedback', [
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
