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

    public function testGetQuestionnaireJSON()
    {
        // factory(UserFeedbackQuestion::class, 15)->create();
        $singleQuestion = factory(UserFeedbackQuestion::class, 'single_question_type')->create([
            'question' => 'Das ist eine Single Question Type',
            'required' => true
        ]);
        factory(UserFeedbackQuestion::class, 'group_title_question_type')->create([
            'question' => 'Das ist eine Group Title Question Type',
            'opt1' => 'Option 1',
            'opt2' => 'Option 2'
            // isRequired has no effect on a group title question
        ]);
        $groupQuestion = factory(UserFeedbackQuestion::class, 'group_question_type')->create([
            'question' => 'Das ist eine Group Question Type',
            'required' => true
        ]);
        $textQuestion = factory(UserFeedbackQuestion::class, 'text_question_type')->create([
            'question' => 'Das ist eine Text Question Type',
            'required' => true
        ]);
        $singleQuestion2 = factory(UserFeedbackQuestion::class, 'single_question_type_2')->create([
            'question' => 'Das ist eine Single Question Type 2',
            'required' => true
        ]);
        $singleQuestion6 = factory(UserFeedbackQuestion::class, 'single_question_type_6')->create([
            'question' => 'Das ist eine Single Question Type 6',
            'custom_info' => '"choices":[{"value":"1","text":"Kollegen"},{"value":"2","text":"eZivi"},{"value":"3","text":"Website SWO"},{"value":"4","text":"Thomas Winter"},{"value":"5","text":"Früherer Einsatz"},{"value":"6","text":"Anderes"}]',
            'required' => true
        ]);

        // should render
        $this->authJson('GET', '/api/questionnaire', 'zivi')->assertResponseOk();
        $response = $this->response->getContent();

        // verify the rendered output
        // first, the string should start with pages and ends with something else
        $this->assertStringStartsWith('{"pages":[', $response);
        $this->assertStringEndsWith('], "requiredText": "(*)", "showProgressBar": "top", "showQuestionNumbers": "off" }', $response);

        // verify that each type gets rendered out correctly
        $this->assertContains('{ "type":"rating", "isRequired":"true", "name":"' . $singleQuestion->id . '", "rateValues":["1","2","3","4"], "title":"Das ist eine Single Question Type" }', $response);
        $this->assertContains('{ "type": "html", "html": "<h4>Das ist eine Group Title Question Type</h4><p class=\'btn-group\'>Option 1 - Option 2</p>", "name": "question" }', $response);
        $this->assertContains('{ "type":"rating", "isRequired":"true", "name":"' . $groupQuestion->id . '", "rateValues":["1","2","3","4"], "title":"Das ist eine Group Question Type", "indent": "2" }', $response);
        $this->assertContains('{ "type":"comment", "isRequired":"true", "name":"' . $textQuestion->id . '", "title":"Das ist eine Text Question Type"}', $response);
        $this->assertContains('{ "type":"rating",  "isRequired":"true", "name":"' . $singleQuestion2->id . '", "rateValues":[{"value":"1","text":"Ja"},{"value":"2","text":"Nein"}], "title":"Das ist eine Single Question Type 2" }', $response);
        $this->assertContains('{ "type":"radiogroup", "isRequired":"true", "name":"' . $singleQuestion6->id . '", "choices":[{"value":"1","text":"Kollegen"},{"value":"2","text":"eZivi"},{"value":"3","text":"Website SWO"},{"value":"4","text":"Thomas Winter"},{"value":"5","text":"Früherer Einsatz"},{"value":"6","text":"Anderes"}] "title":"Das ist eine Single Question Type 6" }', $response);
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

    public function testPutFeedback()
    {
        $mission = factory(Mission::class)->create();

        $countBeforeInsert = count(UserFeedback::all());

        $this->authJson('PUT', 'api/user/feedback', 'zivi', [
            'missionId' => $mission->id,
            'survey' => [
                'question' => 'answer',
                'here you can insert an array as answer' => [
                    'what do you think about this?' => 'it is pretty good tho',
                    'what do you think about that?' => 'it is also pretty good tho'
                ]
            ]
        ])->assertResponseOk();

        $this->assertCount($countBeforeInsert + 3, UserFeedback::all());
    }
}
