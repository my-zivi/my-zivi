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

    console.log('answers = ', answers);
    console.log('questions = ', questions);

    for (var x = 0; x < questions.length; x++) {
      if (x == 0) {
        feedbacks.push(
          <div>
            <h3>SWO als Einsatzbetrieb</h3>
          </div>
        );
      }
      if (x == 11) {
        feedbacks.push(
          <div>
            <h3>Arbeit</h3>
          </div>
        );
      }
      if (x == 27) {
        feedbacks.push(
          <div>
            <h3>Einsatzleitung</h3>
          </div>
        );
      }
      if (x == 36) {
        feedbacks.push(
          <div>
            <h3>Bewertung der Einsatzleiter</h3>
          </div>
        );
      }
      if (x == 66) {
        feedbacks.push(
          <div>
            <h3>Weiteres</h3>
          </div>
        );
      }
      //console.log("questions[", x, "] = ", questions[x])
      feedbacks.push(
        <div>
          <label>
            {questions[x].question}
            <br />
            <input
              type="text"
              value={answers[x] ? answers[x].answer : null}
              name={x}
              defaultChecked={true}
              onchange={e => {
                this.handleChange(e);
              }}
            />
          </label>
        </div>
      );
    }

    return (
      <Header>
        <div className="page page__user_feedback_overview">
          <Card>{feedbacks}</Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
