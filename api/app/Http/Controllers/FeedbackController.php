<?php

namespace App\Http\Controllers;

use App\Mission;
use App\UserFeedback;
use App\UserFeedbackQuestion;
use Carbon\Carbon;
use Faker\Provider\Uuid;
use Laravel\Lumen\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\Facades\DB;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Symfony\Component\Console\Output\ConsoleOutput;

define("ONE_YEAR_IN_SEC", 60 * 60 * 24 * 365);

define("TYPE_SINGLE_QUESTION", 1);
define("TYPE_GROUP_TITLE", 2);
define("TYPE_GROUP_QUESTION", 3);
define("TYPE_TEXT", 4);

class FeedbackController extends Controller
{
    private $date_from = null;
    private $date_to = null;
    private $feedback_id = null;

    public function getQuestionnaireJSON()
    {

        $json_string = "";
        $string_start = "{pages:[";
        $string_end = "]}";
        $page_start = "{type:\"panel\", elements:[";
        $lastPageName = "";
        $lastPageTitle = "";

        $questions = UserFeedbackQuestion::orderBy('id', 'asc')->get();
        $json_string .= $string_start.$page_start;

        $output = new ConsoleOutput();

        for ($i = 0; $i < count($questions); $i++) {
            if ($questions[$i]->new_page == 1) {
                $json_string .= $this->getPageEndString($lastPageName, $lastPageTitle).",";
                $lastPageName = $questions[$i]->question;
                $lastPageTitle = $questions[$i]->question;
                $json_string .= $page_start;
            }

            switch ($questions[$i]->type) {
                case constant("TYPE_SINGLE_QUESTION"):
                case constant("TYPE_GROUP_TITLE"):
                case constant("TYPE_TEXT"):
                    $json_string .= $questions[$i]->json;

                    $a = 1;
                    while (1) {
                        if ($i+$a >= count($questions)) {
                            $output->writeln(json_encode($i." + ".$a. " count"));
                            break 1;
                        }

                        if ($questions[$i+$a]->type == constant("TYPE_GROUP_QUESTION")) {
                            $output->writeln(json_encode($i." + ".$a. " groupQuestion"));
                            $a += 1;
                            continue 1;
                        }

                        if ($questions[$i+$a]->new_page != 1) {
                            $output->writeln(json_encode($i." + ".$a. " !new_page"));
                            $json_string .= ",";
                            break 1;
                        } else {
                            $output->writeln(json_encode($i." + ".$a. " new_page"));
                            break 1;
                        }
                    }

                    break;
                case constant("TYPE_GROUP_QUESTION"):
                    //nothing to do?
                    break;
            }
        }

        $json_string .= $this->getPageEndString($lastPageName, $lastPageTitle);
        $json_string .= $string_end;

        return new JsonResponse($json_string);
    }

    private function getPageEndString($pageName, $pageTitle)
    {
        return "],name:\"".$pageName."\", title:\"".$pageTitle."\"}";
    }

    public function getFeedback($feedback_id)
    {
        $this->feedback_id = $feedback_id;
        return $this->getFeedbacks();
    }

    public function getFeedbacks()
    {

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

    public function putFeedback()
    {
        $content = Input::get();
        $userId = JWTAuth::parseToken()->authenticate()->id;
        $date = date("Y-m-d H:i:s");

        $feedbackId = Uuid::uuid();
        $missionId = $content['missionId'];
        $content = $content['survey'];
/*
        $output = new ConsoleOutput();
        $output->writeln(json_encode($content));
*/
        $this->setMissionFeedbackDone($missionId);

        foreach ($content as $key => $value) {
            if (is_array($value)) {
                foreach ($value as $subKey => $subValue) {
                    $user_feedback = new UserFeedback();
                    $user_feedback->user = $userId;
                    $user_feedback->feedbackId = $feedbackId;
                    $user_feedback->year = $date;
                    $user_feedback->questionId = $subKey;
                    $user_feedback->answer = $subValue;
                    $user_feedback->save();
                }
            } else {
                $user_feedback = new UserFeedback();
                $user_feedback->user = $userId;
                $user_feedback->feedbackId = $feedbackId;
                $user_feedback->year = $date;
                $user_feedback->questionId = $key;
                $user_feedback->answer = $value;
                $user_feedback->save();
            }
        }

        $this->sendEmailToMissionControl($feedbackId);

        return response("User Feedback inserted for User: ". $userId);
    }

    private function setMissionFeedbackDone($missionId)
    {
        $mission = Mission::where('id', $missionId)
            ->get();

        $mission[0]->feedback_done = true;
        $mission[0]->save();
    }

    private function sendEmailToMissionControl($feedbackId)
    {

        //TODO: change emails for production
        $email = "aw@stiftungswo.ch;mp@stiftungswo.ch;mbr@stiftungswo.ch;lg@stiftungswo.ch;dj@stiftungswo.ch;ls@stiftungswo.ch;";
        $subject = "Feedback von einem Zivi erstellt";
        $headers = 'Content-type: text/text; charset=utf-8; From: swo@stiftungswo.ch';
        $emailText = 'Liebe Einsatzleitung,
          
Ein Zivi hat gerade eben das Feedback zu seinem Einsatz abgegeben. 
          
Du findest die Gesamt-Evaluation unter folgendem Link: http://izivi.stiftungswo.ch/user_feedback_overview/'.$feedbackId.'
          
Liebe Grüsse aus Schwerzenbach
          
Dein SWO-Team
Bahnstrasse 9
8603 Schwerzenbach

Phone:  +41 (0)43 355 58 44
E-Mail:  swo@stiftungswo.ch
http://www.stiftungswo.ch';

        mail($email, $subject, $emailText, 'Content-type: text/text; charset=utf-8');
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
            if ($this->feedback_id!=null) {
                $results[$i] = DB::table('user_feedbacks')
                    ->where('answer', '=', $i)
                    ->where('questionId', '=', $questionId)
                    ->where('feedbackId', '=', $this->feedback_id)
                    ->get()->count();
            } else {
                $results[$i] = DB::table('user_feedbacks')
                    ->where('answer', '=', $i)
                    ->where('questionId', '=', $questionId)
                    ->whereDate('year', '>=', $this->date_from)
                    ->whereDate('year', '<=', $this->date_to)
                    ->get()->count();
            }
        }

        return $results;
    }

    private function getFeedbacksTypeText($questionId)
    {
        if ($this->feedback_id!=null) {
            $results = DB::table('user_feedbacks')->select('answer')
                ->where('questionId', '=', $questionId)
                ->where('feedbackId', '=', $this->feedback_id)
                ->get();
        } else {
            $results = DB::table('user_feedbacks')->select('answer')
                ->where('questionId', '=', $questionId)
                ->whereDate('year', '>=', $this->date_from)
                ->whereDate('year', '<=', $this->date_to)
                ->get();
        }

        $answerTexts = "";
        foreach ($results as $key => $value) {
            $answerTexts .= $value->answer . "\n\r";
        }

        return $answerTexts;
    }
}
