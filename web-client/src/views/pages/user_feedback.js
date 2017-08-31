import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

export default class UserFeedback extends Component {
  constructor(props) {
    super(props);

    this.state = {
      surveyJSON: [],
      loading: false,
      error: null,
    };
  }

  sendDataToServer(survey) {
    this.setState({ loading: true, error: null });

    var missionId = this.props.params.missionId;

    axios
      .put(
        ApiService.BASE_URL + 'user/feedback',
        { survey: survey.data, missionId: missionId },
        { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } }
      )
      .then(() => {
        this.setState({ loading: false });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getQuestionnaireJSON() {
    this.setState({ loading: true, error: null });

    axios
      .get(ApiService.BASE_URL + 'questionnaire', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        var newState = {
          surveyJSON: response.data,
          loading: false,
        };

        /*
			// Survey example data with 3 questions
			var surveyJSON = {pages:[{name:"User_Feedback_SWO",elements:[ {type:"panel",name:"SWOalsEinsatzbetrieb",elements:[{type:"radiogroup",name:"1",title:"WiewurdestduaufdieSWOaufmerksam?",isRequired:true,choices:[{value:"1.1",text:"Kollegen"},{value:"1.2",text:"EIS"},{value:"1.3",text:"WebsiteSWO"},{value:"1.4",text:"ThomasWinter"},{value:"1.5",text:"FrühererEinsatz"},{value:"1.6",text:"Anderes"}]}]}, {type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"12",rows:[{value:"13",text:"-dieArbeitstechniken?"},{value:"14",text:"-derUmgangmitMaschinen?"},{value:"15",text:"-SinnundZweckderProjekte?"}],title:"Wieguterklärtwurde(n)..."}]}]}
			*/

        Survey.Survey.cssType = 'bootstrap';
        var survey = new Survey.Model(response.data);
        $('#surveyContainer').Survey({
          model: survey,
          onComplete: survey => {
            this.sendDataToServer(survey);
          },
        });

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
            <div class="container">
              <div id="surveyContainer" />
            </div>
          </Card>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
