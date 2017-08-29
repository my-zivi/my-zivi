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
define("TYPE_SINGLE_QUESTION_2", 5);
define("TYPE_SINGLE_QUESTION_6", 6);

class FeedbackController extends Controller
{
    private $date_from = null;
    private $date_to = null;
    private $feedback_id = null;
    private $questions = array();
    private $index = 0;
    private $output;

    public function getQuestionnaireJSON()
    {

        $this->output = new ConsoleOutput();

        $json_string = "";
        $string_start = '{"pages":[';
        $string_end = '], "requiredText": "", "showProgressBar": "top", "showQuestionNumbers": "off" }';
        $page_start = '{"elements": [{"type":"panel", "elements":[';
        $lastPageName = "Organisation"; //TODO hardcoded
        $lastPageTitle = "Organisation";

        $this->questions = UserFeedbackQuestion::orderBy('id', 'ASC')->get();
        $json_string .= $string_start.$page_start;

        for ($this->index = 0; $this->index < count($this->questions); $this->index++) {
            if ($this->questions[$this->index]->new_page == 1) {
                $json_string = substr($json_string, 0, -1); // remove last comma
                $json_string .= $this->getPageEndString($lastPageName, $lastPageTitle).",";
                $lastPageName = $this->questions[$this->index]->question;
                $lastPageTitle = $this->questions[$this->index]->question;
                $json_string .= $page_start;
            }

            $json_string .= $this->getJSONbyQuestionType();
        }

        $json_string = substr($json_string, 0, -1); // remove last comma
        $json_string .= $this->getPageEndString($lastPageName, $lastPageTitle);
        $json_string .= $string_end;

        return new JsonResponse($json_string);
    }

    private function getJSONbyQuestionType()
    {
        $returnString = "";

        switch ($this->questions[$this->index]->type) {
            case constant("TYPE_SINGLE_QUESTION"):
                $returnString .= '{ "type":"rating", "isRequired":"true", "name":"'.$this->questions[$this->index]->id.'", "rateValues":["1","2","3","4"], "title":"'.$this->questions[$this->index]->question.'" },';
                break;

            case constant("TYPE_GROUP_QUESTION"):
                $returnString .= '{ "type":"rating", "isRequired":"true", "name":"'.$this->questions[$this->index]->id.'", "rateValues":["1","2","3","4"], "title":"'.$this->questions[$this->index]->question.'", "indent": "2" },';
                break;

            case constant("TYPE_SINGLE_QUESTION_2"):
                $returnString .= '{ "type":"rating", "isRequired":"true", "name":"'.$this->questions[$this->index]->id.'", "rateValues":[{"value":"1","text":"Ja"},{"value":"2","text":"Nein"}], "title":"'.$this->questions[$this->index]->question.'" },';
                break;

            case constant("TYPE_SINGLE_QUESTION_6"):
                $returnString .= '{ "type":"radiogroup", "isRequired":"true", "name":"'.$this->questions[$this->index]->id.'", "choices":[{"value":"1","text":"Kollegen"},{"value":"2","text":"EIS"},{"value":"3","text":"Website SWO"},{"value":"4","text":"Thomas Winter"},{"value":"5","text":"Früherer Einsatz"},{"value":"6","text":"Anderes"}], "title":"'.$this->questions[$this->index]->question.'" },'; //TODO remove hardcoded texts
                break;

            case constant("TYPE_GROUP_TITLE"):
                $returnString .= '{ "type": "html", "html": "<h4>'.$this->questions[$this->index]->question.'</h4><p class=\'btn-group\'>'.$this->questions[$this->index]->opt1.' - '.$this->questions[$this->index]->opt2.'</p>", "name": "question" },';
                break;

            case constant("TYPE_TEXT"):
                $returnString .= '{ "type":"text", "isRequired":true, "name":"'.$this->questions[$this->index]->id.'", "title":"'.$this->questions[$this->index]->question.'", "visible":"false", "visibleIf":"{151} = 1"},';
                break;
        }

        $this->output->writeln(json_encode($this->index));
        return $returnString;
    }

    private function getPageEndString($pageName, $pageTitle)
    {
        return '], "name":"'.$pageName.'", "title":"'.$pageTitle.'" }]}';
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
                case 2:
                    $questions[$i]->answers = null;
                    break;
                case 4:
                    $questions[$i]->answers = $this->getFeedbacksTypeText($questions[$i]->id);
                    break;
                default:
                    $questions[$i]->answers = $this->getFeedbacksTypeRange($questions[$i]->id);
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
