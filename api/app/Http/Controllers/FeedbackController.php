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

    public function getFeedbacks()
    {
        $this->output = new ConsoleOutput();

        $questions = DB::table('user_feedback_questions')->get();

        for ($i = 0; $i < count($questions); $i++) {
            //$this->output->writeln("questionID = ".$question->id);

            switch ($questions[$i]->type) {
                case 0:
                    $questions[$i]->answers = null;
                    break;
                case 1:
                    $questions[$i]->answers = $this->getFeedbacksType1($questions[$i]->id);
                    break;
                case 2:
                    $questions[$i]->answers = $this->getFeedbacksType2($questions[$i]->id);
                    break;
            }

            //$this->output->writeln("Answers = ".json_encode($question['answers']));
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
