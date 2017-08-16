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
    public function getFeedbacks(Application $app)
    {
        $answers = DB::table('user_feedbacks')->get();

        $output = new ConsoleOutput();
        $output->writeln("FeedbackController getFeedbacks = ".json_encode($answers));

        foreach ($answers as $value) {
            {$value.questionId: [1:count($value.answer==1), 2:count($value.answer==2)]}
        }

        return new JsonResponse($answers);
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
