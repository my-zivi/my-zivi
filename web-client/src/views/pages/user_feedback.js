import React, { Component } from 'react';
import Card from '../tags/card';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import Toast from '../../utils/toast';
import { api } from '../../utils/api';

export default class UserFeedback extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: false,
      error: null,
    };
  }

  sendDataToServer(survey) {
    this.setState({ loading: true, error: null });

    var missionId = this.props.match.params.missionId;

    api()
      .put('user/feedback', {
        survey: survey.data,
        missionId: missionId,
      })
      .then(() => {
        this.setState({ loading: false });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getQuestionnaireJSON() {
    this.setState({ loading: true, error: null });

    api()
      .get('questionnaire')
      .then(response => {
        var newState = {
          loading: false,
        };

        window.Survey.Survey.cssType = 'bootstrap';
        window.Survey.defaultBootstrapCss.navigationButton = 'btn btn-success';

        let surveyJSON = this.tryGetObject(response.data);

        if (surveyJSON) {
          var survey = new window.Survey.Model(surveyJSON);
          window.$('#surveyContainer').Survey({
            model: survey,
            completeText: 'Danke für dein Feedback!',
            onComplete: survey => {
              this.sendDataToServer(survey);
            },
          });
        } else {
          Toast.showError(
            'Problem in der Konfiguration',
            'Die Datenbank-Konfiguration des Fragebogens stimmt nicht. Bitte melde dich bei einem Admin.',
            null,
            null
          );
        }

        this.setState(newState);
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  componentDidMount() {
    this.getQuestionnaireJSON();
  }

  render() {
    return (
      <Header>
        <div className="page page__user_feedback">
          <Card>
            <h1>Einsatz-Feedback</h1>
            <br />
            <div className="container">
              <div id="surveyContainer" />
            </div>
          </Card>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }

  tryGetObject(o) {
    if (o && typeof o === 'object') {
      return o;
    }

    return false;
  }
}

/*
// Survey example data with 3 questions
var surveyJSON = {pages:[{name:"User_Feedback_SWO",elements:[ {type:"panel",name:"SWOalsEinsatzbetrieb",elements:[{type:"radiogroup",name:"1",title:"WiewurdestduaufdieSWOaufmerksam?",isRequired:true,choices:[{value:"1.1",text:"Kollegen"},{value:"1.2",text:"EIS"},{value:"1.3",text:"WebsiteSWO"},{value:"1.4",text:"ThomasWinter"},{value:"1.5",text:"FrühererEinsatz"},{value:"1.6",text:"Anderes"}]}]}, {type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"12",rows:[{value:"13",text:"-dieArbeitstechniken?"},{value:"14",text:"-derUmgangmitMaschinen?"},{value:"15",text:"-SinnundZweckderProjekte?"}],title:"Wieguterklärtwurde(n)..."}]}]}
*/
