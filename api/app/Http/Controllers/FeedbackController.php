<?php

namespace App\Http\Controllers;

use Laravel\Lumen\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\Facades\DB;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Symfony\Component\Console\Output\ConsoleOutput;

define("ONE_YEAR_IN_SEC", 60 * 60 * 24 * 365);

class FeedbackController extends Controller
{
    private $output = null;
    private $date_from = null;
    private $date_to = null;

    public function getFeedbacks()
    {
        $this->output = new ConsoleOutput();

        $oneYearAgo = date('m/d/Y h:i:s a', time() - constant("ONE_YEAR_IN_SEC"));
        $today = date('m/d/Y h:i:s a', time());

        $this->date_from = Input::get("date_from", $oneYearAgo);
        $this->date_to = Input::get("date_to", $today);

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
            $results[$i] = DB::table('user_feedbacks')
                ->where('answer', '=', $i)
                ->where('questionId', '=', $questionId)
                ->whereDate('year', '>=', $this->date_from)
                ->whereDate('year', '<=', $this->date_to)
                ->get()->count();
        }

        return $results;
    }

    private function getFeedbacksTypeText($questionId)
    {
        $results = DB::table('user_feedbacks')->select('answer')
            ->where('questionId', '=', $questionId)
            ->whereDate('year', '>=', $this->date_from)
            ->whereDate('year', '<=', $this->date_to)
            ->get();

        $answerTexts = "";
        foreach ($results as $key => $value) {
            //$this->output->writeln(json_encode($value->answer));
            $answerTexts .= $value->answer . "\n\r";
        }

        return $answerTexts;
    }
}
