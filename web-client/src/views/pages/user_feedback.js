import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import Header from '../tags/header';
import Component from 'inferno-component';

export default class UserFeedback extends Component {
  sendDataToServer(survey) {
    var resultAsString = JSON.stringify(survey.data);
    alert(resultAsString); //send Ajax request to your web server.
    //survey.sendResult('70a0b637-c72c-4162-8e4d-15fe62e11b9e');
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
                    { value: '1.1', text: 'Kollegen' },
                    { value: '1.2', text: 'EIS' },
                    { value: '1.3', text: 'Website SWO ' },
                    { value: '1.4', text: 'Thomas Winter' },
                    { value: '1.5', text: 'Früherer Einsatz' },
                    { value: '1.6', text: 'Anderes' },
                  ],
                  isRequired: true,
                  name: '1',
                  title: 'Wie wurdest du auf die SWO aufmerksam?',
                },
                { type: 'rating', isRequired: true, name: '2', title: 'Hattest du genügend Informationen zum Einsatzbetrieb ?' },
                { type: 'rating', isRequired: true, name: '3', title: 'Wie zufrieden warst du mit der Anmeldung über iZivi ?' },
                { type: 'rating', isRequired: true, name: '4', title: 'Wie zufrieden warst du mit der Spesenabrechnung?' },
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4', '5'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '5',
                  rows: [
                    { value: '5.1', text: '- Aktive Naturschutzarbeit' },
                    { value: '5.2', text: '- Ort des Einsatzbetriebes' },
                    { value: '5.3', text: '- Möglichkeit einer kurzen Einsatzdauer' },
                    { value: '5.4', text: '- Empfehlung' },
                    { value: '5.5', text: '- Früherer Einsatz bei der SWO' },
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
                { type: 'rating', isRequired: true, name: '6', title: 'Wie streng war die Arbeit?' },
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4', '5'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '7',
                  rows: [
                    { value: '7.1', text: '- die Arbeitstechniken?' },
                    { value: '7.2', text: '- der Umgang mit Maschinen?' },
                    { value: '7.3', text: '- Sinn und Zweck der Projekte?' },
                  ],
                  title: 'Wie gut erklärt wurde (n) ...',
                },
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4', '5'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '8',
                  rows: [
                    { value: '8.1', text: '- Arbeitshilfsmittel? (Handwerkzeug, Fahrzeuge etc.)' },
                    { value: '8.2', text: '- zur Verfügung gestellten Arbeitskleider?' },
                  ],
                  title: 'Wie beurteilst du den Zustand der...',
                },
                { type: 'rating', isRequired: true, name: '9', title: 'Wie war die Stimmung in der Gruppe während der Arbeit?' },
                { type: 'rating', isRequired: true, name: '10', title: 'Wie fandest du die Gruppengrösse?' },
                { type: 'rating', isRequired: true, name: '11', title: 'Wie sinnvoll hast du die Projekte empfunden?' },
                { type: 'rating', isRequired: true, name: '12', title: 'Wie beurteilst du die Sicherheit während der Arbeit?' },
                {
                  type: 'matrix',
                  columns: ['1', '2', '3', '4', '5'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '13',
                  rows: [{ value: '13.1', text: '- während der Arbeit?' }, { value: '13.2', text: '- während der Pausen?' }],
                  title: "Waren rauchende Zivi's für dich ein Problem ...",
                },
                {
                  type: 'rating',
                  isRequired: true,
                  name: '14',
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
                  columns: ['1', '2', '3', '4', '5'],
                  isAllRowRequired: true,
                  isRequired: true,
                  name: '15',
                  rows: [
                    { value: '15.1', text: '- Die Anwesenheit eines Einsatzleiters war motivierend.' },
                    { value: '15.2', text: '- Eine höhere Präsenz der Einsatzleiter wäre wünschenswert.' },
                    { value: '15.3', text: '- Eine intensivere persönliche Betreuung wäre gut.' },
                    { value: '15.4', text: '- Der Einsatzleiter stand bei Fragen jeweils zur Verfügung.' },
                    { value: '15.5', text: '- Der Einsatzleiter konnte meine Fragen gut beantworten.' },
                    { value: '15.6', text: '- Der Einsatzleiter wirkte in der Regel fachlich kompetent.' },
                    { value: '15.7', text: '- Ich bekam ein faires Feedback auf meine Arbeit.' },
                    { value: '15.8', text: '- Der Einsatzleiter gab realistische Tagesziele vor.' },
                  ],
                  title: 'Wie stark stimmst du folgenden Aussagen zu?',
                },
              ],
              name: '15',
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
                      type: 'matrix',
                      columns: ['1', '2', '3', '4', '5'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '16',
                      rows: [{ value: '16.1', text: '- Fachliche Kompetenz' }, { value: '16.2', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                    },
                    { type: 'text', isRequired: true, name: '17', title: '- Wie war die Stimmung während der Arbeit' },
                    { type: 'text', isRequired: true, name: '18', title: '- Was kann konkret verbessert werden:' },
                  ],
                  name: 'Manuel Brändli',
                  title: 'Manuel Brändli',
                },
                {
                  type: 'panel',
                  elements: [
                    {
                      type: 'matrix',
                      columns: ['1', '2', '3', '4', '5'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '19',
                      rows: [{ value: '19.1', text: '- Fachliche Kompetenz' }, { value: '19.2', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                    },
                    { type: 'text', isRequired: true, name: '20', title: '- Wie war die Stimmung während der Arbeit' },
                    { type: 'text', isRequired: true, name: '21', title: '- Was kann konkret verbessert werden:' },
                  ],
                  name: 'Andreas Wolf',
                  title: 'Andreas Wolf',
                },
                {
                  type: 'panel',
                  elements: [
                    {
                      type: 'matrix',
                      columns: ['1', '2', '3', '4', '5'],
                      isAllRowRequired: true,
                      isRequired: true,
                      name: '22',
                      rows: [{ value: '22.1', text: '- Fachliche Kompetenz' }, { value: '22.2', text: '- Soziale Kompetenz' }],
                      title: 'Kompetenzen',
                    },
                    { type: 'text', isRequired: true, name: '23', title: '- Wie war die Stimmung während der Arbeit' },
                    { type: 'text', isRequired: true, name: '24', title: '- Was kann konkret verbessert werden:' },
                  ],
                  name: 'Marc Pfeuti',
                  title: 'Marc Pfeuti',
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
                { type: 'rating', isRequired: true, name: '25', title: 'Würdest du die SWO als Einsatzbetrieb weiterempfehlen?' },
                { type: 'rating', isRequired: true, name: '26', title: 'Würdest du wieder einmal Zivildienst bei der SWO leisten?' },
                { type: 'text', isRequired: true, name: '27', title: 'Höhepunkt(e) meines Zivildiensteinsatzes:' },
                { type: 'text', isRequired: true, name: '28', title: 'Tiefpunkt(e) meines Zivildiensteinsatzes:' },
                { type: 'text', isRequired: true, name: '29', title: 'Verbesserungsvorschläge:' },
                { type: 'text', isRequired: true, name: '30', title: 'Weitere Kommentare:' },
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
