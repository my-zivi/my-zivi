import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/InputFields/DatePicker';
import moment from 'moment-timezone';

export default class UserFeedbackOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: false,
      error: null,
      feedbacks: [],
      questions: [],
      date_from: moment().subtract(1, 'year'),
      date_to: moment(),
    };
  }

  componentDidMount() {
    this.getFeedbackAnswers();
    DatePicker.initializeDatePicker();
  }

  dbDate(sec) {
    return moment(sec).format('YYYY-MM-DD HH:mm:ss');
  }

  getFeedbackAnswers() {
    this.setState({ loading: true, error: null });

    var request;
    if (this.props.params.feedback_id) {
      request = ApiService.BASE_URL + 'user/feedback/' + this.props.params.feedback_id;
    } else {
      request =
        ApiService.BASE_URL +
        'user/feedback?date_from=' +
        this.dbDate(this.state.date_from) +
        '&date_to=' +
        this.dbDate(this.state.date_to);
    }

    axios
      .get(request, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({ loading: false });
        this.setState({
          feedbacks: response.data,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleDateChange(e, origin) {
    let lastValue = origin.state[e.target.name];
    let value = e.target.value;

    if (value !== undefined && value != null && value != '') {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    origin.state[e.target.name] = value;
    origin.setState(this.state);

    if (!moment(value).isSame(lastValue, 'day')) {
      origin.getFeedbackAnswers();
    }
  }

  getChapter(title) {
    return (
      <div>
        <div class="row chapter">
          <div class="col-xs-12">
            <h3>{title}</h3>
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

  getType1RowContent(numberOfAnswers, answers, totalAnswers, colSize = 3) {
    let cols = [];

    for (var i = 1; i <= numberOfAnswers; i++) {
      let answerPerc = 0;
      let answerClasses;

      if (numberOfAnswers == 2) {
        answerClasses = ['', 'progress-bar-danger', 'progress-bar-success'];

        if (i == 2) {
          cols.push(<div class={'col-xs-6'} />);
        }
      } else if (numberOfAnswers == 6) {
        answerClasses = [
          '',
          'progress-bar-info',
          'progress-bar-info',
          'progress-bar-info',
          'progress-bar-info',
          'progress-bar-info',
          'progress-bar-info',
        ];
      } else {
        answerClasses = ['', 'progress-bar-danger', 'progress-bar-warning', 'progress-bar-info', 'progress-bar-success'];
      }

      if (answers[i] == 0) {
        answerPerc = 0;
      } else {
        answerPerc = answers[i] / totalAnswers;
      }

      cols.push(
        <div class={'col-xs-' + colSize}>
          <div class={'progress vertical progress-striped ' + answerClasses[i]}>
            <div class="progress-bar" style={'height: ' + (100 - answerPerc * 100) + '%;'}>
              {Math.round(answerPerc * 100)}
            </div>
          </div>
        </div>
      );
    }

    return cols;
  }

  render() {
    let TYPE_SINGLE_QUESTION = 1;
    let TYPE_GROUP_TITLE = 2;
    let TYPE_GROUP_QUESTION = 3;
    let TYPE_TEXT = 4;
    let TYPE_SINGLE_QUESTION_2 = 5;
    let TYPE_SINGLE_QUESTION_6 = 6;

    let feedbacks = [];
    let answers = this.state.feedbacks;
    let totalFeedbacks = 0;

    if (answers[1] !== undefined && answers[1] != null && answers[1]['answers'] !== undefined) {
      totalFeedbacks =
        answers[1]['answers']['1'] +
        answers[1]['answers']['2'] +
        answers[1]['answers']['3'] +
        answers[1]['answers']['4'] +
        answers[1]['answers']['5'] +
        answers[1]['answers']['6'];
    }

    for (var x = 0; x < answers.length; x++) {
      if (answers[x].new_page == 1) {
        feedbacks.push(this.getChapter(answers[x].custom_info));
      }

      // These questions have multiple answers
      if (
        answers[x].type == TYPE_SINGLE_QUESTION ||
        answers[x].type == TYPE_GROUP_QUESTION ||
        answers[x].type == TYPE_SINGLE_QUESTION_2 ||
        answers[x].type == TYPE_SINGLE_QUESTION_6
      ) {
        let rawContent = [];
        let totalAnswers = 0;
        let answersCleaned = [];
        let answersPerc = [];

        for (var i = 1; i <= 6; i++) {
          answersCleaned[i] = answers[x]['answers'][i] ? answers[x]['answers'][i] : 0;
          totalAnswers += answersCleaned[i];
        }

        if (answers[x].type == TYPE_SINGLE_QUESTION_6) {
          let custom_info = this.tryParseJSON('{' + answers[x].custom_info.substring(0, answers[x].custom_info.length - 1) + '}');

          let rows = [];
          if (custom_info && custom_info.choices) {
            custom_info.choices.forEach(function(element) {
              rows.push(
                <div class="col-xs-2">
                  <label>{element.text}</label>
                </div>
              );
            });
          }

          feedbacks.push(
            <div class="row">
              <div class="col-xs-6">
                <label>{answers[x].question}</label>
              </div>
              <div class="col-xs-6">
                <div class="row question6row">{rows}</div>
                <div class="row">{this.getType1RowContent(6, answersCleaned, totalAnswers, 2)}</div>
              </div>
            </div>
          );
        } else if (answers[x].type == TYPE_SINGLE_QUESTION_2) {
          feedbacks.push(
            <div class="row">
              <div class="col-xs-8">
                <label>{answers[x].question}</label>
              </div>
              <div class="col-xs-1">
                <label>{answers[x].opt1}</label>
              </div>
              <div class="col-xs-2">
                <div class="row">{this.getType1RowContent(2, answersCleaned, totalAnswers)}</div>
              </div>
              <div class="col-xs-1">
                <label>{answers[x].opt2}</label>
              </div>
            </div>
          );
        } else {
          feedbacks.push(
            <div class="row">
              <div class="col-xs-8">
                <label>{answers[x].question}</label>
              </div>
              <div class="col-xs-1">
                <label>{answers[x].opt1}</label>
              </div>
              <div class="col-xs-2">
                <div class="row">{this.getType1RowContent(4, answersCleaned, totalAnswers)}</div>
              </div>
              <div class="col-xs-1">
                <label>{answers[x].opt2}</label>
              </div>
            </div>
          );
        }
      } else if (answers[x].type == TYPE_GROUP_TITLE) {
        if (answers[x].question == '') {
          continue;
        }

        feedbacks.push(
          <div>
            <br />
            <br />
            <div class="row">
              <div class="col-xs-8">
                <label>
                  <h4>{answers[x].question}</h4>
                </label>
              </div>
              <div class="col-xs-1">
                <label>{answers[x].opt1}</label>
              </div>
              <div class="col-xs-2" />
              <div class="col-xs-1">
                <label>{answers[x].opt2}</label>
              </div>
            </div>
          </div>
        );
      } else if (answers[x].type == TYPE_TEXT) {
        feedbacks.push(
          <div>
            <div class="row">
              <div class="col-xs-6">
                <label>{answers[x].question}</label>
              </div>
              <div class="col-xs-6">
                <textarea class="form-control" rows="10" cols="50" value={answers[x] ? answers[x]['answers'] : null} name={x} />
              </div>
            </div>
            <br />
            <br />
          </div>
        );
      }
    }

    return (
      <Header>
        <div className="page page__user_feedback_overview">
          <Card>
            {this.props.params.feedback_id == null && (
              <div class="container top">
                <div class="row">
                  <div class="col-sm-4">
                    <DatePicker
                      id="date_from"
                      label="Von"
                      value={this.state.date_from}
                      callback={this.handleDateChange}
                      callbackOrigin={this}
                    />
                  </div>
                  <div class="col-sm-4">
                    <DatePicker
                      id="date_to"
                      label="Bis"
                      value={this.state.date_to}
                      callback={this.handleDateChange}
                      callbackOrigin={this}
                    />
                  </div>
                  <div class="col-sm-4">
                    <h5>Anzahl Feedbacks: {totalFeedbacks}</h5>
                  </div>
                </div>
              </div>
            )}
            <div class="container feedback">
              <div class="innerContainer">{feedbacks}</div>
            </div>
          </Card>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }

  tryParseJSON(jsonString) {
    try {
      var o = JSON.parse(jsonString);

      // Handle non-exception-throwing cases:
      // Neither JSON.parse(false) or JSON.parse(1234) throw errors, hence the type-checking,
      // but... JSON.parse(null) returns null, and typeof null === "object",
      // so we must check for that, too. Thankfully, null is falsey, so this suffices:
      if (o && typeof o === 'object') {
        return o;
      }
    } catch (e) {}

    return false;
  }
}
