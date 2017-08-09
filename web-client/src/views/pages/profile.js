import Inferno from 'inferno';
import { Link } from 'inferno-router';
import { connect } from 'inferno-mobx';

import Card from '../tags/card';
import InputField from '../tags/InputField';
import InputFieldWithHelpText from '../tags/InputFieldWithHelpText';
import InputCheckbox from '../tags/InputCheckbox';
import DatePicker from '../tags/DatePicker';
import Cantons from '../tags/Cantons';
import RegionalCenters from '../tags/RegionalCenters';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

@connect(['accountStore'])
export default class User extends Component {
  constructor(props, { router }) {
    super(props);

    this.state = {
      result: [],
      cantons: [],
      regianlCenters: [],
      specifications: [],
      lastDateValue: null,
      specifications: [],
      reportSheets: [],
    };

    this.cantonTag = new Cantons();
    this.regionalCenterTag = new RegionalCenters();
    this.router = router;
  }

  componentDidMount() {
    this.getUser();
    this.cantonTag.getCantons(this);
    this.regionalCenterTag.getRegionalCenters(this);
    this.getSpecifications();
    this.getReportSheets();
  }

  componentWillReceiveProps(nextProps) {
    this.props = nextProps;
    this.componentDidMount();
  }

  getUser() {
    this.setState({ loading: true, error: null });

    axios
      .get(ApiService.BASE_URL + 'user' + (this.props.params.userid ? '/' + this.props.params.userid : ''), {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        var newState = {
          result: response.data,
          loading: false,
          lastDateValue: response.data['birthday'],
        };
        for (var i = 0; i < response.data.missions.length; i++) {
          var key = response.data.missions[i].id;

          newState['result'][key + '_specification'] = response.data.missions[i].specification;
          newState['result'][key + '_start'] = response.data.missions[i].start;
          newState['result'][key + '_end'] = response.data.missions[i].end;
          newState['result'][key + '_first_time'] = response.data.missions[i].first_time;
          newState['result'][key + '_long_mission'] = response.data.missions[i].long_mission;
          newState['result'][key + '_probation_period'] = response.data.missions[i].probation_period;
        }

        this.setState(newState);

        for (var i = 0; i < response.data.missions.length; i++) {
          this.getMissionDays(response.data.missions[i].id);
        }
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getMissionDays(missionKey) {
    this.state.result[missionKey + '_days'] = '';
    this.setState(this.state);

    axios
      .get(
        ApiService.BASE_URL +
          'diensttage?start=' +
          this.state.result[missionKey + '_start'] +
          '&end=' +
          this.state.result[missionKey + '_end'],
        { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } }
      )
      .then(response => {
        this.state.result[missionKey + '_days'] = response.data;
        this.setState(this.state);
      });
  }

  getSpecifications() {
    this.setState({ loading: true, error: null });

    axios
      .get(ApiService.BASE_URL + 'specification', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.setState({
          loading: false,
          specifications: response.data,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getReportSheets() {
    this.setState({ loading: true, error: null });

    let apiRoute = this.props.params.userid === undefined ? 'me' : this.props.params.userid;

    axios
      .get(ApiService.BASE_URL + 'reportsheet/user/' + apiRoute, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({ loading: false, reportSheets: response.data });
      })
      .catch(error => {
        this.setState({ loading: false, error: error });
      });
  }

  getMissionDraft(missionKey) {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'mission/' + missionKey + '/draft', {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
        responseType: 'blob',
      })
      .then(response => {
        this.setState({
          loading: false,
        });
        let blob = new Blob([response.data], { type: 'application/pdf' });
        window.location = window.URL.createObjectURL(blob);
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChange(e) {
    let value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.state['result'][e.target.name] = value;
    this.setState(this.state);
  }

  handleDateChange(e, origin) {
    let value = e.target.value;

    if (value === undefined || value == null || value == '') {
      value = origin.state.lastDateValue;
    } else {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    origin.state['result'][e.target.name] = value;
    origin.setState(this.state);
  }

  handleSelectChange(e) {
    var targetSelect = document.getElementById(e.target.id);
    let value = targetSelect.options[targetSelect.selectedIndex].value;
    this.state['result'][e.target.name] = value;
    this.setState(this.state);
  }

  handleTextareaChange(e) {
    let value = document.getElementById(e.target.id).value;
    this.state['result'][e.target.name] = value;
    this.setState(this.state);
  }

  save() {
    this.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'user/' + this.state.result.id, this.state.result, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({ loading: false });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  redirectToChangePassword(e) {
    this.router.push('/changePassword');
  }

  saveMission(missionKey) {
    var newMission = {
      user: this.state.result.id,
      specification: this.state.result[missionKey + '_specification'],
      start: this.state.result[missionKey + '_start'],
      end: this.state.result[missionKey + '_end'],
      first_time: this.state.result[missionKey + '_first_time'],
      long_mission: this.state.result[missionKey + '_long_mission'],
      probation_period: this.state.result[missionKey + '_probation_period'],
    };

    this.setState({ loading: true, error: null });
    if (missionKey == 'newmission') {
      axios
        .put(ApiService.BASE_URL + 'mission/', newMission, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
        .then(response => {
          $('[data-dismiss=modal]').trigger({ type: 'click' });
          this.getUser();
        })
        .catch(error => {
          this.setState({ error: error });
        });
    } else {
      axios
        .post(ApiService.BASE_URL + 'mission/' + missionKey, newMission, {
          headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
        })
        .then(response => {
          $('[data-dismiss=modal]').trigger({ type: 'click' });
          this.getUser();
        })
        .catch(error => {
          this.setState({ error: error });
        });
    }
  }

  setReceivedDraft(missionKey) {
    this.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'mission/' + missionKey + '/receivedDraft', null, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.getUser();
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  deleteMission(mission) {
    this.setState({ loading: true, error: null });
    axios
      .delete(ApiService.BASE_URL + 'mission/' + mission.id, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.getUser();
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  showReportSheet(id) {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'pdf/zivireportsheet?reportSheetId=' + id, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
        responseType: 'blob',
      })
      .then(response => {
        this.setState({ loading: false });
        let blob = new Blob([response.data], { type: 'application/pdf' });
        window.location = window.URL.createObjectURL(blob);
      })
      .catch(error => {
        this.setState({ loading: false, error: error });
      });
  }

  getEditModal(mission, isAdmin) {
    let missionKey = mission != null ? mission.id : 'newmission';

    let howerText_Tage =
      'Zeigt dir die Anzahl Tage an welche für den Einsatz voraussichtlich angerechnet werden. Falls während dem Einsatz Betriebsferien liegen werden die entsprechenden Tage abgezogen falls die Dauer zu kurz ist um diese mit Ferientagen kompensieren zu können. Feiertage innerhalb von Betriebsferien gelten auf alle Fälle als Dienstage.';

    var specification_options = [];
    specification_options.push(<option value="" />);
    for (var i = 0; i < this.state.specifications.length; i++) {
      if (this.state.specifications[i].active) {
        specification_options.push(<option value={'' + this.state.specifications[i].fullId}>{this.state.specifications[i].name}</option>);
      }
    }

    var aufgebotErhaltenButton = [];
    if (mission != null && mission.draft == null && isAdmin) {
      aufgebotErhaltenButton.push(
        <button
          class="btn btn-primary"
          type="button"
          onClick={() => {
            this.setReceivedDraft(missionKey);
          }}
        >
          Aufgebot erhalten
        </button>
      );
    }

    return (
      <div id={'einsatzModal' + (mission != null ? mission.id : '')} class="modal fade" role="dialog">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button id="einsatzModalClose" type="button" class="close" data-dismiss="modal">
                &times;
              </button>
              <h4 class="modal-title">Zivildiensteinsatz</h4>
            </div>
            <div class="modal-body">
              <form
                class="form-horizontal"
                action="javascript:;"
                onsubmit={() => {
                  this.saveMission(missionKey);
                }}
              >
                <div class="form-group">
                  <label class="control-label col-sm-3" for={missionKey + '_specification'}>
                    Pflichtenheft
                  </label>
                  <div class="col-sm-9">
                    <select
                      value={'' + this.state['result'][missionKey + '_specification']}
                      id={missionKey + '_specification'}
                      name={missionKey + '_specification'}
                      class="form-control"
                      onChange={e => this.handleSelectChange(e)}
                      required
                    >
                      {specification_options}
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label class="control-label col-sm-3" for="newmission_mission_type">
                    Einsatzart
                  </label>
                  <div class="col-sm-9">
                    <select
                      id="newmission_mission_type"
                      name="newmission_mission_type"
                      class="form-control"
                      onChange={e => this.handleSelectChange(e)}
                    >
                      <option value="0" />
                      <option value="1">Erster Einsatz</option>
                      <option value="2">Letzter Einsatz</option>
                    </select>
                  </div>
                </div>
                <DatePicker
                  value={this.state['result'][missionKey + '_start']}
                  id={missionKey + '_start'}
                  label="Einsatzbeginn"
                  callback={(e, origin) => {
                    this.handleDateChange(e, origin);
                    this.getMissionDays(missionKey);
                  }}
                  callbackOrigin={this}
                />
                <DatePicker
                  value={this.state['result'][missionKey + '_end']}
                  id={missionKey + '_end'}
                  label="Einsatzende"
                  callback={(e, origin) => {
                    this.handleDateChange(e, origin);
                    this.getMissionDays(missionKey);
                  }}
                  callbackOrigin={this}
                />
                <InputFieldWithHelpText
                  value={this.state['result'][missionKey + '_days']}
                  id={missionKey + '_days'}
                  label="Tage"
                  popoverText={howerText_Tage}
                  self={this}
                  disabled="true"
                />
                <InputCheckbox
                  value={this.state['result'][missionKey + '_first_time']}
                  id={missionKey + '_first_time'}
                  label="Erster SWO Einsatz"
                  self={this}
                />
                <InputCheckbox
                  value={this.state['result'][missionKey + '_long_mission']}
                  id={missionKey + '_long_mission'}
                  label="Langer Einsatz oder Teil davon"
                  self={this}
                />
                <InputCheckbox
                  value={this.state['result'][missionKey + '_probation_period']}
                  id={missionKey + '_probation_period'}
                  label="Probeeinsatz"
                  self={this}
                />
                <hr />
                <h4>Schnuppertag</h4>
                <p>
                  Tragen Sie nachfolgend ein, ob Sie bei der SWO einen Schnuppertag geleistet haben. Dieser wird dem Einsatz allenfalls
                  angerechnet.
                </p>
                <DatePicker
                  value={this.state[missionKey + '_trial_mission_date']}
                  id={missionKey + '_trial_mission_date'}
                  label="Datum"
                  self={this}
                />
                <div class="form-group">
                  <label class="control-label col-sm-3" for={missionKey + '_trial_mission_comment'}>
                    Bemerkungen zum Schnuppertag
                  </label>
                  <div class="col-sm-9">
                    <textarea
                      rows="4"
                      value={this.state['result'][missionKey + '_trial_mission_comment']}
                      id={missionKey + '_trial_mission_comment'}
                      name={missionKey + '_trial_mission_comment'}
                      class="form-control"
                      onChange={e => this.handleTextareaChange(e)}
                    />
                  </div>
                </div>
                <hr />
                <h4>Status</h4>
                {mission == null || mission.draft == null ? 'Provisorisch' : 'Aufgeboten, Aufgebot erhalten am ' + mission.draft}
                <hr />
                <button class="btn btn-primary" type="submit">
                  Daten speichern
                </button>
                &nbsp;
                {aufgebotErhaltenButton}
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }

  render() {
    var jwtDecode = require('jwt-decode');
    var decodedToken = jwtDecode(localStorage.getItem('jwtToken'));
    var isAdmin = decodedToken.isAdmin;

    let result = this.state.result;
    let howerText_IBAN = 'IBAN nummer';
    let howerText_Post = 'Postkonto Nummer';
    let howerText_Berufserfahrung =
      'Wir profitieren gerne von deiner Erfahrung. Wenn wir genau wissen, wann wer mit welchen Erfahrungen einen Einsatz tätigt, können wir z.T. Projekte speziell planen.';

    var missions = [];
    if (this.state.result.missions != null) {
      var m = this.state.result.missions;
      for (var i = 0; i < m.length; i++) {
        var name = m[i].specification;
        for (var s = 0; s < this.state.specifications.length; s++) {
          if (m[i].specification == this.state.specifications[s].fullId) {
            name = name + ' ' + this.state.specifications[s].name;
            break;
          }
        }
        let curMission = m[i];
        var deleteButton = [];
        if (isAdmin) {
          deleteButton.push(
            <button
              class="btn btn-xs"
              onClick={() => {
                if (confirm('Möchten Sie diesen Einsatz wirklich löschen?')) {
                  this.deleteMission(curMission);
                }
              }}
            >
              löschen
            </button>
          );
        }
        missions.push(
          <tr>
            <td>{name}</td>
            <td>{moment(m[i].start, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
            <td>{moment(m[i].end, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
            <td>
              <button class="btn btn-xs" data-toggle="modal" data-target={'#einsatzModal' + m[i].id}>
                bearbeiten
              </button>
            </td>
            <td>
              <button
                class="btn btn-xs"
                onClick={() => {
                  this.getMissionDraft(curMission.id);
                }}
              >
                drucken
              </button>
            </td>
            <td>{deleteButton}</td>
          </tr>
        );
        missions.push(this.getEditModal(m[i], isAdmin));
      }
    }

    return (
      <Header>
        <div className="page page__user_list">
          <Card>
            <h1>Profil</h1>
            <div class="container">
              <form class="form-horizontal">
                <hr />
                {this.passwordChangeButton()}
                <input name="id" value="00000" type="hidden" />
                <input name="action" value="saveEmployee" type="hidden" />

                <h3>Persönliche Informationen</h3>
                <InputField id="zdp" label="ZDP" value={result.zdp} disabled="true" />
                <InputField id="first_name" label="Vorname" value={result.first_name} self={this} />
                <InputField id="last_name" label="Nachname" value={result.last_name} self={this} />

                <InputField id="address" label="Strasse" value={result.address} self={this} />
                <InputField id="city" label="Ort" value={result.city} self={this} />
                <InputField id="zip" label="PLZ" value={result.zip} self={this} />

                <DatePicker
                  id="birthday"
                  label="Geburtstag"
                  value={result.birthday}
                  callback={this.handleDateChange}
                  callbackOrigin={this}
                />

                <InputField id="hometown" label="Heimatort" value={result.hometown} self={this} />

                <InputField inputType="email" id="email" label="E-Mail" value={result.email} self={this} />
                <InputField inputType="tel" id="phone_mobile" label="Tel. Mobil" value={result.phone_mobile} self={this} />
                <InputField inputType="tel" id="phone_private" label="Tel. Privat" value={result.phone_private} self={this} />
                <InputField inputType="tel" id="phone_business" label="Tel. Geschäft" value={result.phone_business} self={this} />

                <div class="form-group">
                  <label class="control-label col-sm-3" for="canton">
                    Kanton
                  </label>
                  <div class="col-sm-9">
                    <select id="canton" name="canton" class="form-control" onChange={e => this.handleSelectChange(e)}>
                      {this.cantonTag.renderCantons(this.state)}
                    </select>
                  </div>
                </div>

                <hr />
                <h3>Bank-/Postverbindung</h3>
                <InputFieldWithHelpText id="bank_iban" label="IBAN-Nr." value={result.bank_iban} popoverText={howerText_IBAN} self={this} />
                <InputFieldWithHelpText
                  id="post_account"
                  label="Postkonto-Nr."
                  value={result.post_account}
                  popoverText={howerText_Post}
                  self={this}
                />

                <hr />
                <h3>Krankenkasse</h3>
                <InputField id="health_insurance" label="Krankenkasse (Name und Ort)" value={result.health_insurance} self={this} />
                <hr />

                <h3>Diverse Informationen</h3>
                <div class="form-group">
                  <label class="control-label col-sm-3" for="berufserfahrung">
                    Berufserfahrung
                  </label>
                  <div class="col-sm-8">
                    <textarea
                      rows="4"
                      id="work_experience"
                      name="work_experience"
                      class="form-control"
                      onChange={e => this.handleTextareaChange(e)}
                    >
                      {result.work_experience}
                    </textarea>
                  </div>
                  <div id="_helpberufserfahrung" className="col-sm-1 hidden-xs">
                    <a href="#" data-toggle="popover" title="Berufserfahrung" data-content={howerText_Berufserfahrung}>
                      <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </a>
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-3" for="hometown">
                    Regionalzentrum
                  </label>
                  <div class="col-sm-9">
                    <select id="regional_center" name="regional_center" class="form-control" onChange={e => this.handleSelectChange(e)}>
                      {this.regionalCenterTag.renderRegionalCenters(this.state)}
                    </select>
                  </div>
                </div>

                <InputCheckbox id="driving_licence" value={result.driving_licence} label="Führerausweis" self={this} />
                <InputCheckbox id="travel_card" value={result.travel_card} label="GA" self={this} />

                <div class="form-group">
                  <label class="control-label col-sm-3" for="internal_comment">
                    Int. Bemerkung
                  </label>
                  <div class="col-sm-9">
                    <textarea
                      rows="4"
                      id="internal_note"
                      name="internal_note"
                      class="form-control"
                      onChange={e => this.handleTextareaChange(e)}
                    >
                      {result.internal_note}
                    </textarea>
                  </div>
                </div>

                <button
                  type="submit"
                  class="btn btn-primary"
                  onclick={() => {
                    this.save();
                  }}
                >
                  Absenden
                </button>
              </form>

              <hr />
              <h3>Zivieinsätze</h3>
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th>Pflichtenheft</th>
                    <th>Start</th>
                    <th>Ende</th>
                    <th />
                    <th />
                  </tr>
                </thead>
                <tbody>{missions}</tbody>
              </table>
              <button class="btn btn-primary" data-toggle="modal" data-target="#einsatzModal">
                Neue Einsatzplanung hinzufügen
              </button>

              {this.getEditModal(null, isAdmin)}

              <hr />
              <h3>Meldeblätter</h3>
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th>Von</th>
                    <th>Bis</th>
                    <th>Tage</th>
                    <th />
                    <th />
                  </tr>
                </thead>
                <tbody>
                  {this.state.reportSheets.length
                    ? this.state.reportSheets.map(obj => (
                        <tr>
                          <td>{moment(obj.start, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
                          <td>{moment(obj.end, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
                          <td>{moment(obj.end, 'YYYY-MM-DD').diff(moment(obj.start, 'YYYY-MM-DD'), 'days')}</td>
                          {this.props.accountStore.isLoggedIn ? (
                            <td>
                              <button name="showReportSheet" class="btn btn-xs" onClick={() => this.showReportSheet(obj.id)}>
                                Spesenrapport anzeigen
                              </button>
                            </td>
                          ) : null}
                          {this.props.accountStore.isAdmin ? (
                            <td>
                              <button name="editReportSheet" class="btn btn-xs" onClick={() => this.router.push('/expense/' + obj.id)}>
                                Spesen bearbeiten
                              </button>
                            </td>
                          ) : null}
                        </tr>
                      ))
                    : null}
                </tbody>
              </table>
            </div>
          </Card>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }

  componentDidUpdate() {
    DatePicker.initializeDatePicker();
  }

  passwordChangeButton() {
    if (!this.props.params.userid) {
      return (
        <div>
          <button name="resetPassword" class="btn btn-primary" onClick={e => this.redirectToChangePassword(e)}>
            Passwort ändern
          </button>
          <hr />
        </div>
      );
    }
    return;
  }
}
