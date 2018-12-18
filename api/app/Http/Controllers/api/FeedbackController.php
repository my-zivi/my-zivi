<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Mail\NewUserFeedback;
use App\Mission;
use App\UserFeedback;
use App\UserFeedbackQuestion;
use Faker\Provider\Uuid;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Mail;

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

    public function index()
    {
        return UserFeedbackQuestion::all();
    }

    public function postFeedback()
    {
        $content = Input::get();
        $userId = Auth::id();
        $date = date("Y-m-d H:i:s");

        $feedbackId = Uuid::uuid();
        $missionId = $content['missionId'];
        $this->setMissionFeedbackDone($missionId);

        \Log::debug("Mission " . $missionId . " has been marked as done");

        foreach ($content['answers'] as $answer) {
            $user_feedback = new UserFeedback();
            $user_feedback->user = $userId;
            $user_feedback->feedbackId = $feedbackId;
            $user_feedback->year = $date;
            $user_feedback->questionId = $answer['id'];
            $user_feedback->answer = $answer['answer'];
            $user_feedback->save();
        }

        \Log::debug("Feedback " . $feedbackId . " has been saved. Try to send email.");

        $this->sendEmailToMissionControl($feedbackId);

        \Log::debug("Email for feedback " . $feedbackId . " has been sent");

        return response("User Feedback inserted for User: " . $userId);
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


    private function setMissionFeedbackDone($missionId)
    {
        $mission = Mission::where('id', $missionId)
            ->get();

        $mission[0]->feedback_done = true;
        $mission[0]->save();
    }

    private function sendEmailToMissionControl($feedbackId)
    {

        $email = env('API_MAIL_FEEDBACK', null);
        \Log::debug("Recipient for email is " . $email);

        if ($email) {
            Mail::to($email)->send(new NewUserFeedback($feedbackId));
        } else {
            \Log::warning("env variable API_MAIL_FEEDBACK is not set.");
        }
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
            if ($this->feedback_id != null) {
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
        if ($this->feedback_id != null) {
            $results = DB::table('user_feedbacks')->select('answer', 'year')
                ->where('questionId', '=', $questionId)
                ->where('feedbackId', '=', $this->feedback_id)
                ->get();
        } else {
            $results = DB::table('user_feedbacks')->select('answer', 'year')
                ->where('questionId', '=', $questionId)
                ->whereDate('year', '>=', $this->date_from)
                ->whereDate('year', '<=', $this->date_to)
                ->get();
        }

        $answerTexts = "";
        foreach ($results as $key => $value) {
            $answerTexts .= "==== " . $value->year . " ====\n" . $value->answer . "\n\n";
        }

        return $answerTexts;
    }
}
