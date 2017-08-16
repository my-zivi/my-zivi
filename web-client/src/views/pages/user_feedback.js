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

    axios
      .put(ApiService.BASE_URL + 'user/feedback', survey.data, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(() => {
        console.log('put user/feedback works');
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
          name: 'User_Feedback_SWO',
          elements: [
            {
              type: 'panel',
              name: 'SWO als Einsatzbetrieb',
              elements: [
                {
                  type: 'radiogroup',
                  name: '1',
                  title: 'Wie wurdest du auf die SWO aufmerksam?',
                  isRequired: true,
                  choices: [
                    { value: '1.1', text: 'Kollegen' },
                    { value: '1.2', text: 'EIS' },
                    { value: '1.3', text: 'Website SWO ' },
                    { value: '1.4', text: 'Thomas Winter' },
                    { value: '1.5', text: 'Früherer Einsatz' },
                    { value: '1.6', text: 'Anderes' },
                  ],
                },
              ],
            },
            {
              type: 'matrix',
              columns: ['1', '2', '3', '4', '5'],
              isAllRowRequired: true,
              isRequired: true,
              name: '12',
              rows: [
                {
                  value: '13',
                  text: '- die Arbeitstechniken?',
                },
                {
                  value: '14',
                  text: '- der Umgang mit Maschinen?',
                },
                {
                  value: '15',
                  text: '- Sinn und Zweck der Projekte?',
                },
              ],
              title: 'Wie gut erklärt wurde (n) ...',
            },
          ],
        },
      ],
    };

    //{pages:[{elements:[{type:"panel",elements:[{type:"radiogroup",name:"1",title:"Wie wurdest du auf die SWO aufmerksam?",isRequired:true,choices:[{value:"1.1",text:"Kollegen"},{value:"1.2",text:"EIS"},{value:"1.3",text:"Website SWO "},{value:"1.4",text:"Thomas Winter"},{value:"1.5",text:"Früherer Einsatz"},{value:"1.6",text:"Anderes"}]},{type:"rating",name:"2",title:"Hattest du genügend Informationen zum Einsatzbetrieb ?",isRequired:true},{type:"rating",name:"3",title:"Wie zufrieden warst du mit der Anmeldung über iZivi ?",isRequired:true},{type:"rating",name:"4",title:"Wie zufrieden warst du mit der Spesenabrechnung?",isRequired:true},{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"5",rows:[{value:"6",text:"- Aktive Naturschutzarbeit"},{value:"7",text:"- Ort des Einsatzbetriebes"},{value:"8",text:"- Möglichkeit einer kurzen Einsatzdauer"},{value:"9",text:"- Empfehlung"},{value:"10",text:"- Früherer Einsatz bei der SWO"}],title:"Wie wichtig waren folgende Gründe bei deiner Wahl des Einsatzbetriebes?"}],name:"SWO als Einsatzbetrieb",title:"SWO als Einsatzbetrieb"}],name:"User_Feedback_SWO"},{elements:[{type:"panel",elements:[{type:"rating",name:"11",title:"Wie streng war die Arbeit?",isRequired:true},{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"12",rows:[{value:"13",text:"- die Arbeitstechniken?"},{value:"14",text:"- der Umgang mit Maschinen?"},{value:"15",text:"- Sinn und Zweck der Projekte?"}],title:"Wie gut erklärt wurde (n) ..."},{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"16",rows:[{value:"17",text:"- Arbeitshilfsmittel? (Handwerkzeug, Fahrzeuge etc.)"},{value:"18",text:"- zur Verfügung gestellten Arbeitskleider?"}],title:"Wie beurteilst du den Zustand der..."},{type:"rating",name:"19",title:"Wie war die Stimmung in der Gruppe während der Arbeit?",isRequired:true},{type:"rating",name:"20",title:"Wie fandest du die Gruppengrösse?",isRequired:true},{type:"rating",name:"21",title:"Wie sinnvoll hast du die Projekte empfunden?",isRequired:true},{type:"rating",name:"22",title:"Wie beurteilst du die Sicherheit während der Arbeit?",isRequired:true},{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"23",rows:[{value:"24",text:"- während der Arbeit?"},{value:"25",text:"- während der Pausen?"}],title:"Waren rauchende Zivi's für dich ein Problem ..."},{type:"rating",name:"26",title:"Bist du selbst Raucher?",isRequired:true,rateValues:[{value:"1",text:"Ja"},{value:"2",text:"Nein"}]}],name:"Arbeit",title:"Arbeit"}],name:"Arbeit"},{elements:[{type:"panel",elements:[{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"27",rows:[{value:"28",text:"- Die Anwesenheit eines Einsatzleiters war motivierend."},{value:"29",text:"- Eine höhere Präsenz der Einsatzleiter wäre wünschenswert."},{value:"30",text:"- Eine intensivere persönliche Betreuung wäre gut."},{value:"31",text:"- Der Einsatzleiter stand bei Fragen jeweils zur Verfügung."},{value:"32",text:"- Der Einsatzleiter konnte meine Fragen gut beantworten."},{value:"33",text:"- Der Einsatzleiter wirkte in der Regel fachlich kompetent."},{value:"34",text:"- Ich bekam ein faires Feedback auf meine Arbeit."},{value:"35",text:"- Der Einsatzleiter gab realistische Tagesziele vor."}],title:"Wie stark stimmst du folgenden Aussagen zu?"}],name:"27",title:"Einsatzleitung"}],name:"Einsatzleitung"},{elements:[{type:"panel",elements:[{type:"panel",elements:[{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"36",rows:[{value:"37",text:"- Fachliche Kompetenz"},{value:"38",text:"- Soziale Kompetenz"}],title:"Kompetenzen"},{type:"text",isRequired:true,name:"39",title:"- Wie war die Stimmung während der Arbeit"},{type:"text",isRequired:true,name:"40",title:"- Was kann konkret verbessert werden:"}],name:"Manuel Brändli",title:"Manuel Brändli"},{type:"panel",elements:[{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"41",rows:[{value:"42",text:"- Fachliche Kompetenz"},{value:"43",text:"- Soziale Kompetenz"}],title:"Kompetenzen"},{type:"text",isRequired:true,name:"44",title:"- Wie war die Stimmung während der Arbeit"},{type:"text",isRequired:true,name:"45",title:"- Was kann konkret verbessert werden:"}],name:"Andreas Wolf",title:"Andreas Wolf"},{type:"panel",elements:[{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"46",rows:[{value:"47",text:"- Fachliche Kompetenz"},{value:"48",text:"- Soziale Kompetenz"}],title:"Kompetenzen"},{type:"text",isRequired:true,name:"49",title:"- Wie war die Stimmung während der Arbeit"},{type:"text",isRequired:true,name:"50",title:"- Was kann konkret verbessert werden:"}],name:"Marc Pfeuti",title:"Marc Pfeuti"},{type:"panel",elements:[{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"51",rows:[{value:"52",text:"- Fachliche Kompetenz"},{value:"53",text:"- Soziale Kompetenz"}],title:"Kompetenzen"},{type:"text",isRequired:true,name:"54",title:"- Wie war die Stimmung während der Arbeit"},{type:"text",isRequired:true,name:"55",title:"- Was kann konkret verbessert werden:"}],name:"Lothar Schroeder",title:"Lothar Schroeder"}],name:"Bewertung der Einsatzleiter",title:"Bewertung der Einsatzleiter"},{type:"panel",elements:[{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"56",rows:[{value:"57",text:"- Fachliche Kompetenz"},{value:"58",text:"- Soziale Kompetenz"}],title:"Kompetenzen"},{type:"text",isRequired:true,name:"59",title:"- Wie war die Stimmung während der Arbeit"},{type:"text",isRequired:true,name:"60",title:"- Was kann konkret verbessert werden:"}],name:"Daniel Jerjen",title:"Daniel Jerjen"},{type:"panel",elements:[{type:"matrix",columns:["1","2","3","4","5"],isAllRowRequired:true,isRequired:true,name:"61",rows:[{value:"62",text:"- Fachliche Kompetenz"},{value:"63",text:"- Soziale Kompetenz"}],title:"Kompetenzen"},{type:"text",isRequired:true,name:"64",title:"- Wie war die Stimmung während der Arbeit"},{type:"text",isRequired:true,name:"65",title:"- Was kann konkret verbessert werden:"}],name:"Lukas Geser",title:"Lukas Geser"}],name:"Bewertung der Einsatzleiter"},{elements:[{type:"panel",elements:[{type:"rating",name:"66",title:"Würdest du die SWO als Einsatzbetrieb weiterempfehlen?",isRequired:true},{type:"rating",name:"67",title:"Würdest du wieder einmal Zivildienst bei der SWO leisten?",isRequired:true},{type:"text",isRequired:true,name:"68",title:"Höhepunkt(e) meines Zivildiensteinsatzes:"},{type:"text",isRequired:true,name:"69",title:"Tiefpunkt(e) meines Zivildiensteinsatzes:"},{type:"text",isRequired:true,name:"70",title:"Verbesserungsvorschläge:"},{type:"text",isRequired:true,name:"71",title:"Weitere Kommentare:"}],name:"Weiteres",title:"Weiteres"}],name:"Weiteres"}]}

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
      <div>
        <div id="surveyContainer" />
      </div>
    );
  }
}

/*
{pages: [{name: "User_Feedback_SWO",elements: [{type: "panel",name: "SWO als Einsatzbetrieb",elements: [{
                                    type: "radiogroup",
                                    name: "1",
                                    title: "Wie wurdest du auf die SWO aufmerksam?",
                                    isRequired: true,
                                    choices: [{value: "1.1",text: "Kollegen"},{value: "1.2",text: "EIS"},{value: "1.3",text: "Website SWO "},{value: "1.4",text: "Thomas Winter"},{value: "1.5",text: "Früherer Einsatz"},{value: "1.6",text: "Anderes"}]}]}]}]}
*/
