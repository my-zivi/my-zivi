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
      loading: false,
      error: null,
    };
  }

  sendDataToServer(survey) {
    //var resultAsString = JSON.stringify(survey.data);
    //alert(resultAsString); //send Ajax request to your web server.
    //survey.sendResult('70a0b637-c72c-4162-8e4d-15fe62e11b9e');
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

  componentDidMount() {
    Survey.Survey.cssType = 'bootstrap';

    var surveyJSON = {
      pages: [
        {
          elements: [
            {
              type: 'panel',
              elements: [
                {
                  type: 'radiogroup',
                  choices: [
                    { value: '1', text: 'Kollegen' },
                    { value: '2', text: 'EIS' },
                    { value: '3', text: 'Website SWO ' },
                    { value: '4', text: 'Thomas Winter' },
                    { value: '5', text: 'Früherer Einsatz' },
                    { value: '6', text: 'Anderes' },
                  ],
                  isRequired: true,
                  name: '1',
                  title: 'Wie wurdest du auf die SWO aufmerksam?',
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '2',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Hattest du genügend Informationen zum Einsatzbetrieb ?',
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '3',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Wie zufrieden warst du mit der Anmeldung über iZivi ?',
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '4',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Wie zufrieden warst du mit der Spesenabrechnung?',
                },
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '5',
                  rows: [
                    { value: '6', text: '- Aktive Naturschutzarbeit' },
                    { value: '7', text: '- Ort des Einsatzbetriebes' },
                    { value: '8', text: '- Möglichkeit einer kurzen Einsatzdauer' },
                    { value: '9', text: '- Empfehlung' },
                    { value: '10', text: '- Früherer Einsatz bei der SWO' },
                  ],
                  title: 'Wie wichtig waren folgende Gründe bei deiner Wahl des Einsatzbetriebes?',
                },
              ],
              name: 'SWO als Einsatzbetrieb',
              title: 'SWO als Einsatzbetrieb',
            },
          ],
          name: 'User_Feedback_SWO',
        },
        {
          elements: [
            {
              type: 'panel',
              elements: [
                { type: 'rating', isRequired: true, name: '11', rateValues: ['1', '2', '3', '4'], title: 'Wie streng war die Arbeit?' },
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '12',
                  rows: [
                    { value: '13', text: '- die Arbeitstechniken?' },
                    { value: '14', text: '- der Umgang mit Maschinen?' },
                    { value: '15', text: '- Sinn und Zweck der Projekte?' },
                  ],
                  title: 'Wie gut erklärt wurde (n) ...',
                },
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '16',
                  rows: [
                    { value: '17', text: '- Arbeitshilfsmittel? (Handwerkzeug, Fahrzeuge etc.)' },
                    { value: '18', text: '- zur Verfügung gestellten Arbeitskleider?' },
                  ],
                  title: 'Wie beurteilst du den Zustand der...',
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '19',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Wie war die Stimmung in der Gruppe während der Arbeit?',
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '20',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Wie fandest du die Gruppengrösse?',
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '21',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Wie sinnvoll hast du die Projekte empfunden?',
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '22',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Wie beurteilst du die Sicherheit während der Arbeit?',
                },
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '23',
                  rows: [{ value: '24', text: '- während der Arbeit?' }, { value: '25', text: '- während der Pausen?' }],
                  title: "Waren rauchende Zivi's für dich ein Problem ...",
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '26',
                  rateValues: [{ value: '1', text: 'Ja' }, { value: '2', text: 'Nein' }],
                  title: 'Bist du selbst Raucher?',
                },
              ],
              name: 'Arbeit',
              title: 'Arbeit',
            },
          ],
          name: 'Arbeit',
        },
        {
          elements: [
            {
              type: 'panel',
              elements: [
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '27',
                  rows: [
                    { value: '28', text: '- Die Anwesenheit eines Einsatzleiters war motivierend.' },
                    { value: '29', text: '- Eine höhere Präsenz der Einsatzleiter wäre wünschenswert.' },
                    { value: '30', text: '- Eine intensivere persönliche Betreuung wäre gut.' },
                    { value: '31', text: '- Der Einsatzleiter stand bei Fragen jeweils zur Verfügung.' },
                    { value: '32', text: '- Der Einsatzleiter konnte meine Fragen gut beantworten.' },
                    { value: '33', text: '- Der Einsatzleiter wirkte in der Regel fachlich kompetent.' },
                    { value: '34', text: '- Ich bekam ein faires Feedback auf meine Arbeit.' },
                    { value: '35', text: '- Der Einsatzleiter gab realistische Tagesziele vor.' },
                  ],
                  title: 'Wie stark stimmst du folgenden Aussagen zu?',
                },
              ],
              name: '27',
              title: 'Einsatzleitung',
            },
          ],
          name: 'Einsatzleitung',
        },
        {
          elements: [
            {
              type: 'panel',
              elements: [
                {
                  type: 'panel',
                  elements: [
                    {
                      type: 'radiogroup',
                      choices: [{ value: '1', text: 'Ja' }, { value: '2', text: 'Nein' }],
                      isRequired: true,
                      name: '150',
                      title: 'War einer meiner Einsatzleiter',
                    },
                    {
                      type: 'matrix',
                      columns: ['1', '2', '3', '4'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '36',
                      rows: [{ value: '37', text: '- Fachliche Kompetenz' }, { value: '38', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                      visible: false,
                      visibleIf: '{150} = 1',
                    },
                    {
                      type: 'rating',
                      isRequired: true,
                      name: '39',
                      rateValues: ['1', '2', '3', '4'],
                      title: '- Wie war die Stimmung während der Arbeit',
                      visible: false,
                      visibleIf: '{150} = 1',
                    },
                    {
                      type: 'text',
                      isRequired: true,
                      name: '40',
                      title: '- Was kann konkret verbessert werden:',
                      visible: false,
                      visibleIf: '{150} = 1',
                    },
                  ],
                  name: 'Manuel Brändli',
                  title: 'Manuel Brändli',
                },
                {
                  type: 'panel',
                  elements: [
                    {
                      type: 'radiogroup',
                      choices: [{ value: '1', text: 'Ja' }, { value: '2', text: 'Nein' }],
                      isRequired: true,
                      name: '151',
                      title: 'War einer meiner Einsatzleiter',
                    },
                    {
                      type: 'matrix',
                      columns: ['1', '2', '3', '4'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '41',
                      rows: [{ value: '42', text: '- Fachliche Kompetenz' }, { value: '43', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                      visible: false,
                      visibleIf: '{151} = 1',
                    },
                    {
                      type: 'rating',
                      isRequired: true,
                      name: '44',
                      rateValues: ['1', '2', '3', '4'],
                      title: '- Wie war die Stimmung während der Arbeit',
                      visible: false,
                      visibleIf: '{151} = 1',
                    },
                    {
                      type: 'text',
                      isRequired: true,
                      name: '45',
                      title: '- Was kann konkret verbessert werden:',
                      visible: false,
                      visibleIf: '{151} = 1',
                    },
                  ],
                  name: 'Andreas Wolf',
                  title: 'Andreas Wolf',
                },
                {
                  type: 'panel',
                  elements: [
                    {
                      type: 'radiogroup',
                      choices: [{ value: '1', text: 'Ja' }, { value: '2', text: 'Nein' }],
                      isRequired: true,
                      name: '152',
                      title: 'War einer meiner Einsatzleiter',
                    },
                    {
                      type: 'matrix',
                      columns: ['1', '2', '3', '4'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '46',
                      rows: [{ value: '47', text: '- Fachliche Kompetenz' }, { value: '48', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                      visible: false,
                      visibleIf: '{152} = 1',
                    },
                    {
                      type: 'rating',
                      isRequired: true,
                      name: '49',
                      rateValues: ['1', '2', '3', '4'],
                      title: '- Wie war die Stimmung während der Arbeit',
                      visible: false,
                      visibleIf: '{152} = 1',
                    },
                    {
                      type: 'text',
                      isRequired: true,
                      name: '50',
                      title: '- Was kann konkret verbessert werden:',
                      visible: false,
                      visibleIf: '{152} = 1',
                    },
                  ],
                  name: 'Marc Pfeuti',
                  title: 'Marc Pfeuti',
                },
                {
                  type: 'panel',
                  elements: [
                    {
                      type: 'radiogroup',
                      choices: [{ value: '1', text: 'Ja' }, { value: '2', text: 'Nein' }],
                      isRequired: true,
                      name: '153',
                      title: 'War einer meiner Einsatzleiter',
                    },
                    {
                      type: 'matrix',
                      columns: ['1', '2', '3', '4'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '51',
                      rows: [{ value: '52', text: '- Fachliche Kompetenz' }, { value: '53', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                      visible: false,
                      visibleIf: '{153} = 1',
                    },
                    {
                      type: 'rating',
                      isRequired: true,
                      name: '54',
                      rateValues: ['1', '2', '3', '4'],
                      title: '- Wie war die Stimmung während der Arbeit',
                      visible: false,
                      visibleIf: '{153} = 1',
                    },
                    {
                      type: 'text',
                      isRequired: true,
                      name: '55',
                      title: '- Was kann konkret verbessert werden:',
                      visible: false,
                      visibleIf: '{153} = 1',
                    },
                  ],
                  name: 'Lothar Schroeder',
                  title: 'Lothar Schroeder',
                },
                {
                  type: 'panel',
                  elements: [
                    {
                      type: 'radiogroup',
                      choices: [{ value: '1', text: 'Ja' }, { value: '2', text: 'Nein' }],
                      isRequired: true,
                      name: '154',
                      title: 'War einer meiner Einsatzleiter',
                    },
                    {
                      type: 'matrix',
                      columns: ['1', '2', '3', '4'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '56',
                      rows: [{ value: '57', text: '- Fachliche Kompetenz' }, { value: '58', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                      visible: false,
                      visibleIf: '{154} = 1',
                    },
                    {
                      type: 'rating',
                      isRequired: true,
                      name: '59',
                      rateValues: ['1', '2', '3', '4'],
                      title: '- Wie war die Stimmung während der Arbeit',
                      visible: false,
                      visibleIf: '{154} = 1',
                    },
                    {
                      type: 'text',
                      isRequired: true,
                      name: '60',
                      title: '- Was kann konkret verbessert werden:',
                      visible: false,
                      visibleIf: '{154} = 1',
                    },
                  ],
                  name: 'Daniel Jerjen',
                  title: 'Daniel Jerjen',
                },
                {
                  type: 'panel',
                  elements: [
                    {
                      type: 'radiogroup',
                      choices: [{ value: '1', text: 'Ja' }, { value: '2', text: 'Nein' }],
                      isRequired: true,
                      name: '155',
                      title: 'War einer meiner Einsatzleiter',
                    },
                    {
                      type: 'matrix',
                      columns: ['1', '2', '3', '4'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '61',
                      rows: [{ value: '62', text: '- Fachliche Kompetenz' }, { value: '63', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                      visible: false,
                      visibleIf: '{155} = 1',
                    },
                    {
                      type: 'rating',
                      isRequired: true,
                      name: '64',
                      rateValues: ['1', '2', '3', '4'],
                      title: '- Wie war die Stimmung während der Arbeit',
                      visible: false,
                      visibleIf: '{155} = 1',
                    },
                    {
                      type: 'text',
                      isRequired: true,
                      name: '65',
                      title: '- Was kann konkret verbessert werden:',
                      visible: false,
                      visibleIf: '{155} = 1',
                    },
                  ],
                  name: 'Lukas Geser',
                  title: 'Lukas Geser',
                },
              ],
              name: 'Bewertung der Einsatzleiter',
              title: 'Bewertung der Einsatzleiter',
            },
          ],
          name: 'Bewertung der Einsatzleiter',
        },
        {
          elements: [
            {
              type: 'panel',
              elements: [
                {
                  type: 'rating',
                  isRequired: true,
                  name: '66',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Würdest du die SWO als Einsatzbetrieb weiterempfehlen?',
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '67',
                  rateValues: ['1', '2', '3', '4'],
                  title: 'Würdest du wieder einmal Zivildienst bei der SWO leisten?',
                },
                { type: 'text', isRequired: true, name: '68', title: 'Höhepunkt(e) meines Zivildiensteinsatzes:' },
                { type: 'text', isRequired: true, name: '69', title: 'Tiefpunkt(e) meines Zivildiensteinsatzes:' },
                { type: 'text', isRequired: true, name: '70', title: 'Verbesserungsvorschläge:' },
                { type: 'text', isRequired: true, name: '71', title: 'Weitere Kommentare:' },
              ],
              name: 'Weiteres',
              title: 'Weiteres',
            },
          ],
          name: 'Weiteres',
        },
      ],
    };

    var survey = new Survey.Model(surveyJSON);
    $('#surveyContainer').Survey({
      model: survey,
      onComplete: survey => {
        this.sendDataToServer(survey);
      },
    });
  }

  render() {
    return (
      <Header>
        <div className="page page__user_feedback">
          <Card>
            <div>
              <div id="surveyContainer" />
            </div>
          </Card>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}

/*
Example with only three different questions, for testing purpose!
{pages:[{name:"User_Feedback_SWO",elements:[{type:"panel",name:"SWOalsEinsatzbetrieb",elements:[{type:"radiogroup",name:"1",title:"WiewurdestduaufdieSWOaufmerksam?",isRequired:true,choices:[{value:"1.1",text:"Kollegen"},{value:"1.2",text:"EIS"},{value:"1.3",text:"WebsiteSWO"},{value:"1.4",text:"ThomasWinter"},{value:"1.5",text:"FrühererEinsatz"},{value:"1.6",text:"Anderes"}]}]},{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"12",rows:[{value:"13",text:"-dieArbeitstechniken?"},{value:"14",text:"-derUmgangmitMaschinen?"},{value:"15",text:"-SinnundZweckderProjekte?"}],title:"Wieguterklärtwurde(n)..."}]}]}
*/
