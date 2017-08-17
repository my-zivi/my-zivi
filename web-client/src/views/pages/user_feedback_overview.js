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

  render() {
    var feedbacks = [];
    var answers = this.state.feedbacks;

    if (answers[0]) {
      var totalFeedbacks =
        answers[0]['answers']['1'] +
        answers[0]['answers']['2'] +
        answers[0]['answers']['3'] +
        answers[0]['answers']['4'] +
        answers[0]['answers']['5'] +
        answers[0]['answers']['6'];
    }

    for (var x = 0; x < answers.length; x++) {
      var answerOne = 0;
      var answerTwo = 0;
      var answerThree = 0;
      var answerFour = 0;
      var answerFive = 0;
      var answerSix = 0;

      var totalAnswers = 0;

      var answerOnePerc = 0;
      var answerTwoPerc = 0;
      var answerThreePerc = 0;
      var answerFourPerc = 0;
      var answerFivePerc = 0;
      var answerSixPerc = 0;

      if (answers[x].type == 1) {
        answerOne = answers[x]['answers']['1'] ? answers[x]['answers']['1'] : 0;
        answerTwo = answers[x]['answers']['2'] ? answers[x]['answers']['2'] : 0;
        answerThree = answers[x]['answers']['3'] ? answers[x]['answers']['3'] : 0;
        answerFour = answers[x]['answers']['4'] ? answers[x]['answers']['4'] : 0;
        answerFive = answers[x]['answers']['5'] ? answers[x]['answers']['5'] : 0;
        answerSix = answers[x]['answers']['6'] ? answers[x]['answers']['6'] : 0;

        totalAnswers = answerOne + answerTwo + answerThree + answerFour + answerFive + answerSix;

        if (answerOne == 0) {
          answerOnePerc = 0;
        } else {
          answerOnePerc = answerOne / totalAnswers;
        }
        if (answerTwo == 0) {
          answerTwoPerc = 0;
        } else {
          answerTwoPerc = answerTwo / totalAnswers;
        }
        if (answerThree == 0) {
          answerThreePerc = 0;
        } else {
          answerThreePerc = answerThree / totalAnswers;
        }
        if (answerFour == 0) {
          answerFourPerc = 0;
        } else {
          answerFourPerc = answerFour / totalAnswers;
        }
        if (answerFive == 0) {
          answerFivePerc = 0;
        } else {
          answerFivePerc = answerFive / totalAnswers;
        }
        if (answerSix == 0) {
          answerSixPerc = 0;
        } else {
          answerSixPerc = answerSix / totalAnswers;
        }
      }

      //Initialize different titles
      if (x == 0) {
        feedbacks.push(
          <div>
            <div class="row">
              <div class="col-xs-12 chapter">
                <h3>SWO als Einsatzbetrieb</h3>
              </div>
            </div>
            <div class="row">
              <div class="col-xs-12">
                <br />
              </div>
            </div>
          </div>
        );
      }
      if (x == 11) {
        feedbacks.push(
          <div>
            <div class="row">
              <div class="col-xs-12 chapter">
                <h3>Arbeit</h3>
              </div>
            </div>
            <div class="row">
              <div class="col-xs-12">
                <br />
              </div>
            </div>
          </div>
        );
      }
      if (x == 26) {
        feedbacks.push(
          <div>
            <div class="row">
              <div class="col-xs-12 chapter">
                <h3>Einsatzleitung</h3>
              </div>
            </div>
            <div class="row">
              <div class="col-xs-12">
                <br />
              </div>
            </div>
          </div>
        );
      }
      if (x == 35) {
        feedbacks.push(
          <div>
            <div class="row">
              <div class="col-xs-12 chapter">
                <h3>Bewertung der Einsatzleiter</h3>
              </div>
            </div>
            <div class="row">
              <div class="col-xs-12">
                <br />
              </div>
            </div>
          </div>
        );
      }
      if (x == 65) {
        feedbacks.push(
          <div>
            <div class="row">
              <div class="col-xs-12 chapter">
                <h3>Weiteres</h3>
              </div>
            </div>
            <div class="row">
              <div class="col-xs-12">
                <br />
              </div>
            </div>
          </div>
        );
      }

      //Initialize different questiontypes
      if (answers[x].pos == 1) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-7">
              <label>{answers[x].question}</label>
            </div>
            <div class="col-xs-5">
              <div class="row">
                <div class="col-xs-2">
                  <label>Kollegen</label>
                </div>
                <div class="col-xs-2">
                  <label>EIS</label>
                </div>
                <div class="col-xs-2">
                  <label>Website SWO</label>
                </div>
                <div class="col-xs-2">
                  <label>Thomas Winter</label>
                </div>
                <div class="col-xs-2">
                  <label>Früherer Einsatz</label>
                </div>
                <div class="col-xs-2">
                  <label>Anderes</label>
                </div>
              </div>
              <div class="row">
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info">
                    <div class="progress-bar" style={'height: ' + (100 - answerOnePerc * 100) + '%;'}>
                      {answerOnePerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info">
                    <div class="progress-bar" style={'height: ' + (100 - answerTwoPerc * 100) + '%;'}>
                      {answerTwoPerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info">
                    <div class="progress-bar" style={'height: ' + (100 - answerThreePerc * 100) + '%;'}>
                      {answerThreePerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info">
                    <div class="progress-bar" style={'height: ' + (100 - answerFourPerc * 100) + '%;'}>
                      {answerFourPerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info">
                    <div class="progress-bar" style={'height: ' + (100 - answerFivePerc * 100) + '%;'}>
                      {answerFivePerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info">
                    <div class="progress-bar" style={'height: ' + (100 - answerSixPerc * 100) + '%;'}>
                      {answerSixPerc * 100}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        );
      } else if (answers[x].type == 0) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-8">
              <label>
                <h4>{answers[x].question}</h4>
              </label>
            </div>
            <div class="col-xs-4" />
          </div>
        );
      } else if (answers[x].pos == 26) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-8">
              <label>{answers[x].question}</label>
            </div>
            <div class="col-xs-1">
              <label>{answers[x].opt1}</label>
            </div>
            <div class="col-xs-2">
              <div class="row">
                <div class="col-xs-3">
                  <div class="progress vertical progress-striped progress-bar-danger">
                    <div class="progress-bar" style={'height: ' + (100 - answerOnePerc * 100) + '%;'}>
                      {answerOnePerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-3" />
                <div class="col-xs-3" />
                <div class="col-xs-3">
                  <div class="progress vertical progress-striped progress-bar-warning">
                    <div class="progress-bar" style={'height: ' + (100 - answerTwoPerc * 100) + '%;'}>
                      {answerTwoPerc * 100}
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-xs-1">
              <label>{answers[x].opt2}</label>
            </div>
          </div>
        );
      } else if (answers[x].type == 1) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-8">
              <label>{answers[x].question}</label>
            </div>
            <div class="col-xs-1">
              <label>{answers[x].opt1}</label>
            </div>
            <div class="col-xs-2">
              <div class="row">
                <div class="col-xs-3">
                  <div class="progress vertical progress-striped progress-bar-danger">
                    <div class="progress-bar" style={'height: ' + (100 - answerOnePerc * 100) + '%;'}>
                      {answerOnePerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-3">
                  <div class="progress vertical progress-striped progress-bar-warning">
                    <div class="progress-bar" style={'height: ' + (100 - answerTwoPerc * 100) + '%;'}>
                      {answerTwoPerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-3">
                  <div class="progress vertical progress-striped progress-bar-info">
                    <div class="progress-bar" style={'height: ' + (100 - answerThreePerc * 100) + '%;'}>
                      {answerThreePerc * 100}
                    </div>
                  </div>
                </div>
                <div class="col-xs-3">
                  <div class="progress vertical progress-striped progress-bar-success">
                    <div class="progress-bar" style={'height: ' + (100 - answerFourPerc * 100) + '%;'}>
                      {answerFourPerc * 100}
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-xs-1">
              <label>{answers[x].opt2}</label>
            </div>
          </div>
        );
      } else if (answers[x].type == 2) {
        feedbacks.push(
          <div class="row">
            <div class="col-xs-6">
              <label>{answers[x].question}</label>
            </div>
            <div class="col-xs-6">
              <textarea class="form-control" rows="10" cols="50" value={answers[x] ? answers[x]['answers'] : null} name={x} />
            </div>
          </div>
        );
      }
    }

    return (
      <Header>
        <div className="page page__user_feedback_overview">
          <Card>
            <div class="container title">
              <div class="row">
                <div class="col-xs-12">
                  <h4>Anzahl Feedbacks in diesem Jahr: {totalFeedbacks}</h4>
                </div>
              </div>
            </div>
            <div class="container feedback">{feedbacks}</div>
          </Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
