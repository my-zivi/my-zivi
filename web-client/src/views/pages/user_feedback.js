import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import Header from '../tags/header';
import Component from 'inferno-component';

export default class UserFeedback extends Component {
  sendDataToServer(survey) {
    survey.sendResult('70a0b637-c72c-4162-8e4d-15fe62e11b9e');
  }

  componentDidMount() {
    Survey.Survey.cssType = 'bootstrap';

    var surveyJSON = {
      pages: [
        {
          name: 'page1',
          elements: [
            {
              type: 'radiogroup',
              name: 'Wie wurdest du auf die SWO aufmerksam ?',
              title: 'SWO als Einsatzbetrieb',
              isRequired: true,
              choices: ['Kollegen', 'EIS', 'Website SWO ', 'Thomas Winter', 'Früherer Einsatz', 'Anderes'],
            },
            { type: 'rating', name: 'Hattest du genügend Informationen zum Einsatzbetrieb ?', isRequired: true },
          ],
        },
      ],
    };

    var survey = new Survey.Model(surveyJSON);
    $('#surveyContainer').Survey({
      model: survey,
      onComplete: this.sendDataToServer,
    });
  }

  render() {
    return (
      <div>
        <div id="surveyContainer" />
      </div>
    );
  }
}
