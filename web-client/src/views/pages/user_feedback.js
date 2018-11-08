import * as React from 'react';
import { api } from '../../utils/api';
import { Link, Redirect, Route, Switch } from 'react-router-dom';
import { UserFeedbackForm } from './user_feedback_form';
import Card from '../tags/card';
import Header from '../tags/header';
import Toast from '../../utils/toast';
import { UserFeedbackFinish } from './UserFeedbackFinish';

export default class UserFeedbackNew extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      pages: [],
      user_feedback_questions: [],
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleFieldChange = this.handleFieldChange.bind(this);
  }

  componentDidMount() {
    api()
      .get('user_feedback_questions')
      .then(response => {
        this.generateInitialState(response.data.user_feedback_questions);
      });
  }

  generateInitialState(user_feedback_questions) {
    // find all questions with new page attribute
    let pages = [];
    let user_questions = [];
    let current_page = [];
    user_feedback_questions.forEach(question => {
      if (question.new_page && current_page.length > 0) {
        pages.push(current_page);
        current_page = [];
      }

      current_page.push(question);
      question.page = pages.length;
      user_questions.push(question);
    });
    pages.push(current_page);

    this.setState({ pages, user_feedback_questions: user_questions });
  }

  handleChange(question_id, value) {
    let { user_feedback_questions } = this.state;
    const indexOfQuestion = user_feedback_questions.findIndex(question => question.id === question_id);
    user_feedback_questions[indexOfQuestion].answer = value;
    this.setState({ user_feedback_questions });
  }

  handleFieldChange(question_id, event) {
    this.handleChange(question_id, event.target.value);
  }

  submitAnswers() {
    const {
      match: { params },
    } = this.props;
    const { user_feedback_questions, pages } = this.state;

    api()
      .post('user/feedback', {
        missionId: params.missionId,
        answers: user_feedback_questions.filter(question => question.answer),
      })
      .then(() => {
        Toast.showSuccess('Speichern erfolgreich', 'Feedback wurde erfolgreich gespeichert.');
        this.props.history.push('/user_feedback/' + params.missionId + '/' + pages.length);
      })
      .catch(error => {
        Toast.showError('Speichern fehlgeschlagen', 'Feedback konnte nicht gespeichert werden', error);
      });
  }

  render() {
    const { pages, user_feedback_questions } = this.state;
    const {
      match: { params },
    } = this.props;

    return (
      <Header>
        <div className={'page page__user_list'}>
          <Card>
            <h1>Feedback zu Einsatz abgeben</h1>
            <p>
              <b>Hinweis: </b>
              Alle Fragen, welche mit (*) enden, sind erforderlich und müssen ausgefüllt werden.
            </p>
            <Route
              path={'/user_feedback/:missionId/:index'}
              children={({ match }) => {
                return (
                  <div className="progress">
                    <div
                      className="progress-bar"
                      role="progressbar"
                      aria-valuenow={match.params.index}
                      aria-valuemin="0"
                      aria-valuemax={pages.length}
                      style={{ width: (Number(match.params.index) / pages.length) * 100 + '%' }}
                    >
                      <span className="sr-only">70% Complete</span>
                    </div>
                  </div>
                );
              }}
            />
            <Switch>
              {pages.map((question_array, index) => (
                <Route
                  key={index}
                  path={'/user_feedback/:missionId/' + index}
                  render={() => (
                    <UserFeedbackForm
                      questions={question_array}
                      handleFieldChange={this.handleFieldChange}
                      handleChange={this.handleChange}
                    />
                  )}
                />
              ))}
              <Route path={'/user_feedback/' + params.missionId + '/' + pages.length} render={() => <UserFeedbackFinish />} />
              <Redirect to={'/user_feedback/' + params.missionId + '/0'} />
            </Switch>
            <Route
              path={'/user_feedback/:missionId/:index'}
              children={({ match }) => {
                return (
                  <div className={'btn btn-group'}>
                    {0 < Number(match.params.index) &&
                      Number(match.params.index) < pages.length && (
                        <Link
                          className={'btn btn-primary'}
                          to={'/user_feedback/' + match.params.missionId + '/' + (Number(match.params.index) - 1)}
                        >
                          Zurück
                        </Link>
                      )}
                    {Number(match.params.index) < pages.length - 1 &&
                      (user_feedback_questions.some(
                        question => question.page === Number(match.params.index) && question.required && !question.answer
                      ) ? (
                        <button className={'btn btn-primary'} disabled={true}>
                          Vorwärts
                        </button>
                      ) : (
                        <Link
                          className={'btn btn-primary'}
                          to={'/user_feedback/' + match.params.missionId + '/' + (Number(match.params.index) + 1)}
                        >
                          Vorwärts
                        </Link>
                      ))}

                    {Number(match.params.index) === pages.length - 1 && (
                      <button
                        onClick={() => this.submitAnswers()}
                        className={'btn btn-primary'}
                        disabled={user_feedback_questions.some(question => question.required && !question.answer)}
                      >
                        Feedback absenden
                      </button>
                    )}
                  </div>
                );
              }}
            />
          </Card>
        </div>
      </Header>
    );
  }
}
