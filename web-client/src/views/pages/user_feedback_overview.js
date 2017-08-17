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
                  <div class="progress vertical progress-striped progress-bar-info" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerOnePerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerTwoPerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerThreePerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerFourPerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerFivePerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
                  </div>
                </div>
                <div class="col-xs-2">
                  <div class="progress vertical progress-striped progress-bar-info" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerSixPerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
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
              <label>{answers[x].question}</label>
            </div>
            <div class="col-xs-4" />
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
                  <label>{answers[x]['answers']['1']}</label>
                  <div class="progress vertical progress-striped progress-bar-danger" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerOnePerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
                  </div>
                </div>
                <div class="col-xs-3">
                  <label>{answers[x]['answers']['2']}</label>
                  <div class="progress vertical progress-striped progress-bar-warning" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerTwoPerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
                  </div>
                </div>
                <div class="col-xs-3">
                  <label>{answers[x]['answers']['3']}</label>
                  <div class="progress vertical progress-striped progress-bar-info" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerThreePerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
                  </div>
                </div>
                <div class="col-xs-3">
                  <label>{answers[x]['answers']['4']}</label>
                  <div class="progress vertical progress-striped progress-bar-success" style="height: 50px; width: 20px;">
                    <div
                      class="progress-bar"
                      style={'height: ' + (100 - answerFourPerc * 100) + '%; width: 100%;  background-color: white;'}
                    />
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
              <textarea rows="10" cols="75" value={answers[x] ? answers[x]['answers'] : null} name={x} />
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
