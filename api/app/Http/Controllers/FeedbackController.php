<?php

namespace App\Http\Controllers;

use Laravel\Lumen\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Symfony\Component\Console\Output\ConsoleOutput;

class FeedbackController extends Controller
{
    private $output = null;

    public function getFeedbacks(Application $app)
    {
        $this->output = new ConsoleOutput();

        $questions = DB::table('user_feedback_questions')->get();


        //$output->writeln("FeedbackController getFeedbacks = ".json_encode($questions));

        foreach ($questions as $question) {
            $this->output->writeln("questionID = ".$question->id);

            switch ($question->type) {
                case 0:
                    $questions['answers'] = null;
                    break;
                case 1:
                    $questions['answers'] = $this->getFeedbacksType1($question->id);
                    break;
                case 2:
                    $questions['answers'] = $this->getFeedbacksType2($question->id);
                    break;
            }

            $this->output->writeln("Answers = ".json_encode($questions['answers']));
        }

        return new JsonResponse($questions);
    }

    /*
     SELECT
     (SELECT COUNT(*) FROM user_feedback WHERE answer = 1 AND questionId = 3) AS '1',
     (SELECT COUNT(*) FROM user_feedback WHERE answer = 2 AND questionId = 3) AS '2',
     (SELECT COUNT(*) FROM user_feedback WHERE answer = 3 AND questionId = 3) AS '3',
     (SELECT COUNT(*) FROM user_feedback WHERE answer = 4 AND questionId = 3) AS '4';
    */
    private function getFeedbacksType1($questionId)
    {

        // works:
        //$results = DB::table('user_feedback')->where('answer', '=', 1)->get()->count();
        //DB::table('user_feedback')->select(DB::raw('COUNT(*) AS "1"'))->where('answer', '=', 1)->where('questionId', '=', $questionId)->get();

        $results = array();
        $results[1] = DB::table('user_feedback')->where('answer', '=', 1)->where('questionId', '=', $questionId)->get()->count();
        $results[2] = DB::table('user_feedback')->where('answer', '=', 2)->where('questionId', '=', $questionId)->get()->count();
        $results[3] = DB::table('user_feedback')->where('answer', '=', 3)->where('questionId', '=', $questionId)->get()->count();
        $results[4] = DB::table('user_feedback')->where('answer', '=', 4)->where('questionId', '=', $questionId)->get()->count();

        return $results;
    }

    private function getFeedbacksType2($questionId)
    {
        $results = DB::table('user_feedback')->select('answer')->where('questionId', '=', $questionId)->get();

        $returnObj = "";
        foreach ($results as $result) {
            //$this->output->writeln(json_encode($result->answer));
            $returnObj .= "\n\r | \n\r " . $result->answer;
        }

        return $returnObj;
    }
}



//$answerMatrix->name = 1;
/*
var answerMatrix = {
1: [{1:0}, {2:0}, {3:0}, {4:0}, {5:0}, {6:0}],
2: [{1:0}, {2:0}, {3:0}, {4:0}],
3: [{1:0}, {2:0}, {3:0}, {4:0}],
4: [{1:0}, {2:0}, {3:0}, {4:0}],
5: [{1:0}, {2:0}, {3:0}, {4:0}],
6: [{1:0}, {2:0}, {3:0}, {4:0}],
7: [{1:0}, {2:0}, {3:0}, {4:0}],
8: [{1:0}, {2:0}, {3:0}, {4:0}],
9: [{1:0}, {2:0}, {3:0}, {4:0}],
10: [{1:0}, {2:0}, {3:0}, {4:0}],
11: [{1:0}, {2:0}, {3:0}, {4:0}],
12: [{1:0}, {2:0}, {3:0}, {4:0}],
13: [{1:0}, {2:0}, {3:0}, {4:0}],
14: [{1:0}, {2:0}, {3:0}, {4:0}],
15: [{1:0}, {2:0}, {3:0}, {4:0}],
16: [{1:0}, {2:0}, {3:0}, {4:0}],
17: [{1:0}, {2:0}, {3:0}, {4:0}],
18: [{1:0}, {2:0}, {3:0}, {4:0}],
19: [{1:0}, {2:0}, {3:0}, {4:0}],
20: [{1:0}, {2:0}, {3:0}, {4:0}],
21: [{1:0}, {2:0}, {3:0}, {4:0}],
22: [{1:0}, {2:0}, {3:0}, {4:0}],
23: [{1:0}, {2:0}, {3:0}, {4:0}],
24: [{1:0}, {2:0}, {3:0}, {4:0}],
25: [{1:0}, {2:0}, {3:0}, {4:0}],
26: [{1:0}, {2:0}],
27: [{1:0}, {2:0}, {3:0}, {4:0}],
28: [{1:0}, {2:0}, {3:0}, {4:0}],
29: [{1:0}, {2:0}, {3:0}, {4:0}],
30: [{1:0}, {2:0}, {3:0}, {4:0}],
31: [{1:0}, {2:0}, {3:0}, {4:0}],
32: [{1:0}, {2:0}, {3:0}, {4:0}],
33: [{1:0}, {2:0}, {3:0}, {4:0}],
34: [{1:0}, {2:0}, {3:0}, {4:0}],
35: [{1:0}, {2:0}, {3:0}, {4:0}],
36: [{1:0}, {2:0}, {3:0}, {4:0}],
37: [{1:0}, {2:0}, {3:0}, {4:0}],
38: [{1:0}, {2:0}, {3:0}, {4:0}],
39: [],
40: [],
41: [{1:0}, {2:0}, {3:0}, {4:0}],
42: [{1:0}, {2:0}, {3:0}, {4:0}],
43: [{1:0}, {2:0}, {3:0}, {4:0}],
44: [],
45: [],
46: [{1:0}, {2:0}, {3:0}, {4:0}],
47: [{1:0}, {2:0}, {3:0}, {4:0}],
48: [{1:0}, {2:0}, {3:0}, {4:0}],
49: [],
50: [],
51: [{1:0}, {2:0}, {3:0}, {4:0}],
52: [{1:0}, {2:0}, {3:0}, {4:0}],
53: [{1:0}, {2:0}, {3:0}, {4:0}],
54: [],
55: [],
56: [{1:0}, {2:0}, {3:0}, {4:0}],
57: [{1:0}, {2:0}, {3:0}, {4:0}],
58: [{1:0}, {2:0}, {3:0}, {4:0}],
59: [],
60: [],
61: [{1:0}, {2:0}, {3:0}, {4:0}],
62: [{1:0}, {2:0}, {3:0}, {4:0}],
63: [{1:0}, {2:0}, {3:0}, {4:0}],
64: [],
65: [],
76: [{1:0}, {2:0}, {3:0}, {4:0}],
67: [{1:0}, {2:0}, {3:0}, {4:0}],
68: [],
69: [],
70: [],
71: [],
}



SELECT user_feedbacks.questionId, user_feedbacks.answer, user_feedback_questions.type
FROM user_feedback_questions
JOIN user_feedbacks ON user_feedback_questions.id = user_feedbacks.questionId

SELECT user_feedbacks.questionId, user_feedbacks.answer, user_feedback_questions.type
FROM user_feedback_questions
JOIN user_feedbacks ON user_feedback_questions.id = user_feedbacks.questionId





//Example answer strukture
//[{id, userId, year, questionId, answer},{id, userId, year, questionId, answer}...]
//
// [
//   {"id":15,"user":498,"year":"2017-08-16","questionId":1,"answer":"1.5"},
//   {"id":16,"user":498,"year":"2017-08-16","questionId":13,"answer":"2"},
//   {"id":17,"user":498,"year":"2017-08-16","questionId":14,"answer":"4"},
//   {"id":18,"user":498,"year":"2017-08-16","questionId":15,"answer":"5"}
// ]

what do we want?
questionId ------------ count answer for value 1, count answer for value 2 etc.
questionId ------------ count answer for value 1, count answer for value 2 etc.
questionId ------------ count answer for value 1, count answer for value 2 etc.

questionId 1-71
text only: 39, 40, 44, 45, 49, 50, 54, 55, 59, 60, 64, 65, 68, 69, 70, 71
other answers: 1, 26
other questions just count same values


//atkuell sollte der Wert 0 oder []
console.log('answerMatrix[answers[i].questionId].answers[i].answer =', answerMatrix[answers[i].questionId].answers[i].answer)
for(var i = 0; i <= answers.length; i++){
answerMatrix[answers[i].questionId]
switch(answers[i].questionId) {
case 39:
    code block
    break;
case 40:
    code block
    break;
case 44:
    code block
    break;
case 45:
    code block
    break;
case 49:
    code block
    break;
case 50:
    code block
    break;
case 54:
    code block
    break;
case 55:
    code block
    break;
case 59:
    code block
    break;
case 60:
    code block
    break;
case 64:
    code block
    break;
case 65:
    code block
    break;
case 68:
    code block
    break;
case 69:
    code block
    break;
case 70:
    code block
    break;
case 71:
    code block
    break;
default:
    code block
}
}

*/
