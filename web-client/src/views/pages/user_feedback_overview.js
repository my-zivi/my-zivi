import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

export default class UserFeedbackOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {
      year: new Date().getFullYear(),
      loading: false,
      error: null,
      feedbacks: [],
      questions: [],
    };
  }

  componentDidMount() {
    this.getFeedbackAnswers();
    this.getFeedbackQuestions();
  }

  getFeedbackAnswers() {
    this.setState({ loading: true, error: null });

    axios
      .get(ApiService.BASE_URL + 'user/feedback', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.setState({ loading: false });
        //console.log("response feedbacks = ", response.data)
        this.setState({
          feedbacks: response.data,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getFeedbackQuestions() {
    this.setState({ loading: true, error: null });

    axios
      .get(ApiService.BASE_URL + 'user/feedback/question', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.setState({ loading: false });
        //console.log("response questions = ", response.data)
        this.setState({
          questions: response.data,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  render() {
    var feedbacks = [];
    var answers = this.state.feedbacks;
    var questions = this.state.questions;

    for (var x = 0; x < questions.length; x++) {
      //Initialize different titles
      if (x == 0) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-12" style="background-color: #cccccc;">
              <h4>SWO als Einsatzbetrieb</h4>
            </div>
          </div>
        );
      }
      if (x == 11) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-12" style="background-color: #cccccc;">
              <h4>Arbeit</h4>
            </div>
          </div>
        );
      }
      if (x == 27) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-12" style="background-color: #cccccc;">
              <h4>Einsatzleitung</h4>
            </div>
          </div>
        );
      }
      if (x == 36) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-12" style="background-color: #cccccc;">
              <h4>Bewertung der Einsatzleiter</h4>
            </div>
          </div>
        );
      }
      if (x == 66) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-12" style="background-color: #cccccc;">
              <h4>Weiteres</h4>
            </div>
          </div>
        );
      }

      //Initialize different questiontypes
      if (questions[x].pos == 1) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-8">
              <label>{questions[x].question}</label>
            </div>
            <div class="col-xs-4">
              <div class="row">
                <div class="col-xs-2">
                  <label>Kollegen {answers[x] ? answers[x].answer : null}</label>
                </div>
                <div class="col-xs-2">
                  <label>EIS {answers[x] ? answers[x].answer : null}</label>
                </div>
                <div class="col-xs-2">
                  <label>Website SWO {answers[x] ? answers[x].answer : null}</label>
                </div>
                <div class="col-xs-2">
                  <label>Thomas Winter {answers[x] ? answers[x].answer : null}</label>
                </div>
                <div class="col-xs-2">
                  <label>Früherer Einsatz {answers[x] ? answers[x].answer : null}</label>
                </div>
                <div class="col-xs-2">
                  <label>Anderes {answers[x] ? answers[x].answer : null}</label>
                </div>
              </div>
            </div>
          </div>
        );
      } else if (questions[x].type == 0) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-8">
              <label>{questions[x].question}</label>
            </div>
            <div class="col-xs-4" />
          </div>
        );
      } else if (questions[x].type == 1) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-8">
              <label>{questions[x].question}</label>
            </div>
            <div class="col-xs-1">
              <label>{questions[x].opt1}</label>
            </div>
            <div class="col-xs-2">
              <div class="row">
                <div class="col-xs-3">
                  <label>{answers[x]['answers'][0]}</label>
                  <div class="progress">
                    <div class="progress-bar progress-bar-danger" style="height: 20%;" />
                  </div>
                </div>
                <div class="col-xs-3">
                  <label>{answers[x]['answers'][1]}</label>
                  <div class="progress">
                    <div class="progress-bar progress-bar-warning" style="height: 30%;" />
                  </div>
                </div>
                <div class="col-xs-3">
                  <label>{answers[x]['answers'][2]}</label>
                  <div class="progress">
                    <div class="progress-bar progress-bar-info" style="height: 40%;" />
                  </div>
                </div>
                <div class="col-xs-3">
                  <label>{answers[x]['answers'][3]}</label>
                  <div class="progress">
                    <div class="progress-bar progress-bar-success" style="height: 50%;" />
                  </div>
                </div>
              </div>
            </div>
            <div class="col-xs-1">
              <label>{questions[x].opt2}</label>
            </div>
          </div>
        );
      } else if (questions[x].type == 2) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-8">
              <label>{questions[x].question}</label>
            </div>
            <div class="col-xs-4">
              <textarea rows="5" cols="42" value={answers[x] ? answers[x].answer : null} name={x} />
            </div>
          </div>
        );
      }
    }

    return (
      <Header>
        <div className="page page__user_feedback_overview">
          <Card>
            <div class="container" style="background-color: #ebebeb;">
              {feedbacks}
            </div>
          </Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
