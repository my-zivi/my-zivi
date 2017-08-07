import Inferno from 'inferno';
import { Link } from 'inferno-router';
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

export default class User extends Component {
  constructor(props, { router }) {
    super(props);

    this.state = {
      result: [],
      cantons: [],
      regianlCenters: [],
      specifications: [],
      lastDateValue: null,
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
        this.setState({
          result: response.data,
          loading: false,
          lastDateValue: response.data['birthday'],
        });

        console.log('response: ' + response.data['birthday']);
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getSpecifications() {
    axios
      .get(ApiService.BASE_URL + 'specification', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.setState({
          specifications: response.data,
        });
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

  addNewMission() {
    var newMission = {
      user: this.state.result.id,
      specification: this.state.result.newmission_specification,
      start: this.state.result.newmission_start,
      end: this.state.result.newmission_end,
      first_time: this.state.result.newmission_first_time,
      long_mission: this.state.result.newmission_long_mission,
      probation_period: this.state.result.newmission_probation_period,
    };

    this.setState({ loading: true, error: null });
    axios
      .put(ApiService.BASE_URL + 'mission/', newMission, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        $('[data-dismiss=modal]').trigger({ type: 'click' });
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

  render() {
    var jwtDecode = require('jwt-decode');
    var decodedToken = jwtDecode(localStorage.getItem('jwtToken'));
    var isAdmin = decodedToken.isAdmin;

    let result = this.state.result;
    let howerText_IBAN = 'IBAN nummer';
    let howerText_Post = 'Postkonto Nummer';
    let howerText_Berufserfahrung =
      'Wir profitieren gerne von deiner Erfahrung. Wenn wir genau wissen, wann wer mit welchen Erfahrungen einen Einsatz tätigt, können wir z.T. Projekte speziell planen.';
    let howerText_Tage =
      'Zeigt dir die Anzahl Tage an welche für den Einsatz voraussichtlich angerechnet werden. Falls während dem Einsatz Betriebsferien liegen werden die entsprechenden Tage abgezogen falls die Dauer zu kurz ist um diese mit Ferientagen kompensieren zu können. Feiertage innerhalb von Betriebsferien gelten auf alle Fälle als Dienstage.';

    var specification_options = [];
    specification_options.push(<option value="" />);
    for (var i = 0; i < this.state.specifications.length; i++) {
      if (this.state.specifications[i].active) {
        specification_options.push(<option value={this.state.specifications[i].fullId}>{this.state.specifications[i].name}</option>);
      }
    }

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
            <td>{m[i].start}</td>
            <td>{m[i].end}</td>
            <td>
              <button class="btn btn-xs">drucken</button>
            </td>
            <td>{deleteButton}</td>
          </tr>
        );
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

              <div id="einsatzModal" class="modal fade" role="dialog">
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
                          this.addNewMission();
                        }}
                      >
                        <div class="form-group">
                          <label class="control-label col-sm-3" for="newmission_specification">
                            Pflichtenheft
                          </label>
                          <div class="col-sm-9">
                            <select
                              id="newmission_specification"
                              name="newmission_specification"
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
                        <DatePicker id="newmission_start" label="Einsatzbeginn" callback={this.handleDateChange} callbackOrigin={this} />
                        <DatePicker id="newmission_end" label="Einsatzende" callback={this.handleDateChange} callbackOrigin={this} />
                        <InputFieldWithHelpText
                          id="newmission_days"
                          label="Tage"
                          popoverText={howerText_Tage}
                          self={this}
                          disabled="true"
                        />
                        <InputCheckbox id="newmission_first_time" label="Erster SWO Einsatz" self={this} />
                        <InputCheckbox id="newmission_long_mission" label="Langer Einsatz oder Teil davon" self={this} />
                        <InputCheckbox id="newmission_probation_period" label="Probeeinsatz" self={this} />
                        <hr />
                        <h4>Schnuppertag</h4>
                        <p>
                          Tragen Sie nachfolgend ein, ob Sie bei der SWO einen Schnuppertag geleistet haben. Dieser wird dem Einsatz
                          allenfalls angerechnet.
                        </p>
                        <DatePicker id="newmission_trial_mission_date" label="Datum" self={this} />
                        <div class="form-group">
                          <label class="control-label col-sm-3" for="newmission_trial_mission_comment">
                            Bemerkungen zum Schnuppertag
                          </label>
                          <div class="col-sm-9">
                            <textarea
                              rows="4"
                              id="newmission_trial_mission_comment"
                              name="newmission_trial_mission_comment"
                              class="form-control"
                              onChange={e => this.handleTextareaChange(e)}
                            >
                              {result.internal_note}
                            </textarea>
                          </div>
                        </div>
                        <hr />
                        <h4>Status</h4>
                        Provisorisch
                        <hr />
                        <button class="btn btn-primary" type="submit">
                          Daten speichern
                        </button>
                      </form>
                    </div>
                  </div>
                </div>
              </div>
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
