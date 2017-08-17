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
            switch ($questions[$i]->type) {
                case 0:
                    $questions[$i]->answers = null;
                    break;
                case 1:
                    $questions[$i]->answers = $this->getFeedbacksTypeRange($questions[$i]->id);
                    break;
                case 2:
                    $questions[$i]->answers = $this->getFeedbacksTypeText($questions[$i]->id);
                    break;
            }
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
    private function getFeedbacksTypeRange($questionId)
    {
        $results = array();

        for ($i = 1; $i <= 6; $i++) {
            $results[$i] = DB::table('user_feedback')->where('answer', '=', $i)->where('questionId', '=', $questionId)->get()->count();
        }

        return $results;
    }

    private function getFeedbacksTypeText($questionId)
    {
        $results = DB::table('user_feedback')->select('answer')->where('questionId', '=', $questionId)->get();

        $answerTexts = "";
        foreach ($results as $key => $value) {
            //$this->output->writeln(json_encode($value->answer));
            $answerTexts .= $value->answer . "\n\r";
        }

        return $answerTexts;
    }
}
