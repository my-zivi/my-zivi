import { Component } from 'inferno';
import Card from '../tags/card';
import InputField from '../tags/InputFields/InputField';
import InputCheckbox from '../tags/InputFields/InputCheckbox';
import DatePicker from '../tags/InputFields/DatePicker';
import RegionalCenters from '../tags/Profile/RegionalCenters';
import Missions from '../tags/Profile/Missions';
import AdminRestrictedFields from '../tags/Profile/AdminRestrictedFields';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import Toast from '../../utils/toast';
import moment from 'moment-timezone';
import { api, apiURL } from '../../utils/api';
import Auth from '../../utils/auth';
import axios from 'axios';

export default class User extends Component {
  constructor(props, { router }) {
    super(props);

    this.state = {
      result: [],
      regionalCenters: [],
      specifications: [],
      lastDateValue: null,
      reportSheets: [],
    };

    this.regionalCenterTag = new RegionalCenters();
    this.adminFields = new AdminRestrictedFields();
    this.missionTag = new Missions();
    this.router = router;
  }

  componentDidMount() {
    this.getUser();
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

    const route = this.props.match.params.userid ? 'user/' + this.props.match.params.userid : 'user';
    api()
      .get(route)
      .then(response => {
        var newState = {
          result: response.data,
          loading: false,
        };
        for (var i = 0; i < response.data.missions.length; i++) {
          var key = response.data.missions[i].id;

          newState['result'][key + '_specification'] = response.data.missions[i].specification;
          newState['result'][key + '_mission_type'] = response.data.missions[i].mission_type;
          newState['result'][key + '_start'] = response.data.missions[i].start;
          newState['result'][key + '_end'] = response.data.missions[i].end;
          newState['result'][key + '_first_time'] = response.data.missions[i].first_time;
          newState['result'][key + '_long_mission'] = response.data.missions[i].long_mission;
          newState['result'][key + '_probation_period'] = response.data.missions[i].probation_period;
        }

        this.setState(newState);

        for (var i = 0; i < response.data.missions.length; i++) {
          this.missionTag.getMissionDays(this, response.data.missions[i].id);
        }
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getSpecifications() {
    api()
      .get('specification/me')
      .then(response => {
        this.setState({
          specifications: response.data,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getReportSheets() {
    this.setState({ loading: true, error: null });

    let apiRoute = this.props.match.params.userid === undefined ? 'me' : this.props.match.params.userid;

    api()
      .get('reportsheet/user/' + apiRoute)
      .then(response => {
        this.setState({ loading: false, reportSheets: response.data });
      })
      .catch(error => {
        this.setState({ loading: false, error: error });
      });
  }

  addReportSheet(missionId) {
    this.setState({ loading: true, error: null });

    api()
      .put('reportsheet', {
        user: this.props.match.params.userid ? this.props.match.params.userid : null,
        mission: missionId,
      })
      .then(response => {
        Toast.showSuccess('Hinzufügen erfolgreich', 'Meldeblatt hinzugefügt');
        this.getReportSheets();
      })
      .catch(error => {
        this.setState({ loading: false });
        Toast.showError('Hinzufügen fehlgeschlagen', 'Meldeblatt konnte nicht hinzugefügt werden', error, this.context);
      });
  }

  handleChange(e) {
    if (e.target.type === 'checkbox') {
      this.changeResult(e.target.name, !this.state.result[e.target.name]);
    } else {
      this.changeResult(e.target.name, e.target.value);
    }
  }

  handleDateChange(e) {
    let value = e.target.value;

    if (value) {
      value = DatePicker.dateFormat_CH2EN(value);
    } else if (this.state.lastDateValue) {
      value = this.state.lastDateValue;
    } else {
      return;
    }

    this.changeResult(e.target.name, value);
  }

  changeResult(key, value) {
    this.setState({
      result: {
        ...this.state.result,
        [key]: value,
      },
    });
  }

  handleIBANChange(e) {
    this.handleChange(e);
    if (this.validateIBAN(e.target.value)) {
      this.fetchBIC(e.target.value);
    }
  }

  validateIBAN(value) {
    var regex = new RegExp('^CH\\d{2,2}\\s{0,1}(\\w{4,4}\\s{0,1}){4,7}\\w{0,2}$', 'g');

    if (regex.test(value)) {
      return true;
    } else {
      return false;
    }
  }

  fetchBIC(iban) {
    this.setState({ bic_fetching: true });
    axios
      .get(`https://openiban.com/validate/${iban}?getBIC=true`)
      .then(res => {
        console.log(res);
        this.setState({
          result: {
            ...this.state.result,
            bank_bic: res.data.bankData.bic,
          },
        });
      })
      .catch(err => {
        console.error(err);
        //todo print into status field?
      })
      .finally(() => this.setState({ bic_fetching: false }));
  }

  save() {
    let apiRoute = this.props.match.params.userid === undefined ? 'me' : this.props.match.params.userid;

    this.setState({ loading: true, error: null });
    api()
      .post('user/' + apiRoute, this.state.result)
      .then(response => {
        Toast.showSuccess('Speichern erfolgreich', 'Profil gespeichert');
        this.setState({ loading: false });
      })
      .catch(error => {
        this.setState({ loading: false });
        Toast.showError('Speichern fehlgeschlagen', 'Profil konnte nicht gespeichert werden', error, this.context);
      });
  }

  redirectToChangePassword(e) {
    this.router.history.push('/changePassword');
  }

  getPasswordChangeButton() {
    return (
      <div>
        <button type="button" name="resetPassword" class="btn btn-primary" onClick={e => this.redirectToChangePassword(e)}>
          <span class="glyphicon glyphicon-wrench" /> Passwort ändern
        </button>
        <hr />
      </div>
    );
  }

  render() {
    let result = this.state.result;
    let howerText_IBAN = 'Du kannst die Nummer mit oder ohne Abständen eingeben.';
    let howerText_Post = 'Postkonto Nummer';
    let howerText_Berufserfahrung =
      'Wir profitieren gerne von deiner Erfahrung. Wenn wir genau wissen, wann wer mit welchen Erfahrungen einen Einsatz tätigt, können wir z.T. Projekte speziell planen.';
    let howerText_health_insurance = 'Krankenkassen Name und Ort';

    let missions = this.missionTag.getMissions(this);

    return (
      <Header>
        <div className="page page__user_list">
          <Card>
            <h1>Profil</h1>
            <div class="container">
              <form
                class="form-horizontal"
                action="javascript:;"
                onSubmit={() => {
                  this.save();
                }}
              >
                <hr />
                {this.getPasswordChangeButton()}
                <input name="id" value="00000" type="hidden" />
                <input name="action" value="saveEmployee" type="hidden" />

                <h3>Persönliche Informationen</h3>
                <InputField id="zdp" label="ZDP" value={result.zdp} disabled="true" />
                <InputField id="first_name" label="Vorname" value={result.first_name} onChange={this.handleChange.bind(this)} />
                <InputField id="last_name" label="Nachname" value={result.last_name} onChange={this.handleChange.bind(this)} />

                <InputField id="address" label="Strasse" value={result.address} onChange={this.handleChange.bind(this)} />
                <InputField id="city" label="Ort" value={result.city} onChange={this.handleChange.bind(this)} />
                <InputField id="zip" label="PLZ" value={result.zip} onChange={this.handleChange.bind(this)} />

                <DatePicker id="birthday" label="Geburtstag" value={result.birthday} onChange={this.handleDateChange.bind(this)} />

                <InputField id="hometown" label="Heimatort" value={result.hometown} onChange={this.handleChange.bind(this)} />

                <InputField inputType="email" id="email" label="E-Mail" value={result.email} onChange={this.handleChange.bind(this)} />
                <InputField
                  inputType="tel"
                  id="phone_mobile"
                  label="Tel. Mobil"
                  value={result.phone_mobile}
                  onChange={this.handleChange.bind(this)}
                />
                <InputField
                  inputType="tel"
                  id="phone_private"
                  label="Tel. Privat"
                  value={result.phone_private}
                  onChange={this.handleChange.bind(this)}
                />
                <InputField
                  inputType="tel"
                  id="phone_business"
                  label="Tel. Geschäft"
                  value={result.phone_business}
                  onChange={this.handleChange.bind(this)}
                />

                <hr />
                <h3>Bank-/Postverbindung</h3>

                <div class={'form-group ' + (this.validateIBAN(result.bank_iban) ? '' : 'has-warning')} id="ibanFormGroup">
                  <label class="control-label col-sm-3" for="bank_iban">
                    IBAN-Nr.
                  </label>
                  <div class="col-sm-8">
                    <input
                      type="text"
                      id="bank_iban"
                      name="bank_iban"
                      value={result.bank_iban}
                      className="form-control"
                      onInput={e => this.handleIBANChange(e)}
                    />
                  </div>
                  <div id="_helpiban" className="col-sm-1 hidden-xs">
                    <a data-toggle="popover" title="IBAN-Nr" data-content={howerText_IBAN}>
                      <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </a>
                  </div>
                </div>
                <div class="form-group" id="bicFormGroup">
                  <label class="control-label col-sm-3" for="bank_bic">
                    BIC/SWIFT
                  </label>
                  <div class="col-sm-7">
                    <input
                      type="text"
                      id="bank_bic"
                      name="bank_bic"
                      value={result.bank_bic}
                      className="form-control"
                      onInput={e => this.handleChange(e)}
                    />
                  </div>
                  <div className="col-sm-1">
                    {this.state.bic_fetching ? (
                      <a title="BIC suchen">
                        <span style="font-size:2em;" className="glyphicon glyphicon-refresh gly-spin" aria-hidden="true" />
                      </a>
                    ) : (
                      <a title="BIC suchen">
                        <span
                          style="font-size:2em;"
                          className="glyphicon glyphicon-search"
                          onClick={() => this.fetchBIC(this.state.result.bank_iban)}
                          aria-hidden="true"
                        />
                      </a>
                    )}
                  </div>
                  <div id="_helpbic" className="col-sm-1 hidden-xs">
                    <a
                      data-toggle="popover"
                      title="BIC/SWIFT"
                      data-content="Der BIC/SWIFT code, der Deine Bank identifizert. Du findest diesen meist auf der Website Deiner Bank."
                    >
                      <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </a>
                  </div>
                </div>
                <hr />
                <h3>Krankenkasse</h3>
                <div class="form-group" id="healthInsuranceFormGroup">
                  <label class="control-label col-sm-3" for="health_insurance">
                    Krankenkasse (Name und Ort)
                  </label>
                  <div class="col-sm-8">
                    <input
                      type="text"
                      id="health_insurance"
                      name="health_insurance"
                      value={result.health_insurance}
                      className="form-control"
                      onInput={e => this.handleIBANChange(e)}
                    />
                  </div>
                  <div id="_helpiban" className="col-sm-1 hidden-xs">
                    <a data-toggle="popover" title="Krankenkasse" data-content={howerText_health_insurance}>
                      <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </a>
                  </div>
                </div>
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
                      value={result.work_experience}
                      onInput={e => this.handleChange(e)}
                    />
                  </div>
                  <div id="_helpberufserfahrung" className="col-sm-1 hidden-xs">
                    <a data-toggle="popover" title="Berufserfahrung" data-content={howerText_Berufserfahrung}>
                      <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </a>
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-3" for="hometown">
                    Regionalzentrum
                  </label>
                  <div class="col-sm-9">
                    <select id="regional_center" name="regional_center" class="form-control" onChange={e => this.handleChange(e)}>
                      {this.regionalCenterTag.renderRegionalCenters(this.state)}
                    </select>
                  </div>
                </div>

                <InputCheckbox
                  id="driving_licence"
                  value={result.driving_licence}
                  label="Führerausweis"
                  onChange={this.handleChange.bind(this)}
                />
                <InputCheckbox id="ga_travelcard" value={result.ga_travelcard} label="GA" onChange={this.handleChange.bind(this)} />
                <InputCheckbox
                  id="half_fare_travelcard"
                  value={result.half_fare_travelcard}
                  label="Halbtax"
                  onChange={this.handleChange.bind(this)}
                />
                <InputField
                  id="other_fare_network"
                  label="Andere Abos"
                  value={result.other_fare_network}
                  onChange={this.handleChange.bind(this)}
                />

                {Auth.isAdmin() ? this.adminFields.getAdminRestrictedFields(this, result) : null}

                <button type="submit" class="btn btn-primary">
                  <span class="glyphicon glyphicon-floppy-disk" /> Speichern
                </button>
              </form>
              <br />
              <hr />
              <br />

              <h3>Einsätze</h3>
              <div class="table-responsive">
                <table class="table table-condensed">
                  <thead>
                    <tr>
                      <th>Pflichtenheft</th>
                      <th>Start</th>
                      <th>Ende</th>
                      <th />
                      <th />
                      <th />
                    </tr>
                  </thead>
                  <tbody>{missions}</tbody>
                </table>
              </div>
              <br />
              <button class="btn btn-success" data-toggle="modal" data-target="#einsatzModal">
                Neue Einsatzplanung hinzufügen
              </button>
              {this.missionTag.renderMissions(this, null, Auth.isAdmin())}

              <br />
              <br />
              <hr />
              <br />

              <h3>Meldeblätter</h3>
              <div class="table-responsive">
                <table class="table table-condensed">
                  <thead>
                    <tr>
                      <th>Von</th>
                      <th>Bis</th>
                      <th>Anzahl Tage</th>
                      <th>Status</th>
                      <th />
                      {Auth.isAdmin() ? <th /> : null}
                    </tr>
                  </thead>
                  <tbody>
                    {this.state.reportSheets.length
                      ? this.state.reportSheets.map(obj => (
                          <tr>
                            <td>{moment(obj.start, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
                            <td>{moment(obj.end, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
                            <td>{obj.days}</td>
                            <td>
                              {obj.state > 0 ? (
                                obj.state === 3 ? (
                                  <a data-toggle="popover" title="" data-content="Erledigt">
                                    <span class="glyphicon glyphicon-ok" style="color:green" />
                                  </a>
                                ) : (
                                  <a data-toggle="popover" title="" data-content="In Bearbeitung">
                                    <span class="glyphicon glyphicon-hourglass" style="color:orange" />
                                  </a>
                                )
                              ) : (
                                ''
                              )}
                            </td>
                            <td>
                              {obj.state === 3 ? (
                                <a
                                  name="showReportSheet"
                                  class="btn btn-xs btn-link"
                                  href={apiURL('pdf/zivireportsheet', { reportSheetId: obj.id }, true)}
                                  target="_blank"
                                >
                                  <span class="glyphicon glyphicon-print" aria-hidden="true" /> Drucken
                                </a>
                              ) : null}
                            </td>
                            {Auth.isAdmin() ? (
                              <td>
                                <button
                                  name="editReportSheet"
                                  class="btn btn-link btn-xs btn-warning"
                                  onClick={() => this.router.history.push('/expense/' + obj.id)}
                                >
                                  <span class="glyphicon glyphicon-edit" aria-hidden="true" /> Bearbeiten
                                </button>
                              </td>
                            ) : null}
                          </tr>
                        ))
                      : null}
                  </tbody>
                </table>
              </div>
            </div>
            <br />
            <br />
          </Card>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
