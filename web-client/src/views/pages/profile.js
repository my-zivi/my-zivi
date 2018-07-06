import React, { Component } from 'react';
import Card from '../tags/card';
import InputField from '../tags/InputFields/InputField';
import InputCheckbox from '../tags/InputFields/InputCheckbox';
import DatePicker from '../tags/InputFields/DatePicker';
import PhoneInput from '../tags/InputFields/PhoneInput';
import Missions from '../tags/Profile/Missions';
import AdminRestrictedFields from '../tags/Profile/AdminRestrictedFields';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import Toast from '../../utils/toast';
import moment from 'moment-timezone';
import { api, apiURL } from '../../utils/api';
import Auth from '../../utils/auth';

export default class User extends Component {
  constructor(props, { router }) {
    super(props);

    this.state = {
      result: [],
      regionalCenters: [],
      specifications: [],
      lastDateValue: null,
      reportSheets: [],
      phonenumberValid: {
        phone_mobile: undefined,
        phone_private: undefined,
        phone_business: undefined,
      },
      loading: {},
    };

    this.adminFields = new AdminRestrictedFields();
    this.missionTag = new Missions();
    this.router = router;
  }

  componentDidMount() {
    this.getUser();
    this.getRegionalCenters();
    this.getSpecifications();
    this.getReportSheets();
  }

  componentWillReceiveProps(nextProps) {
    this.props = nextProps;
    this.componentDidMount();
  }

  getUser() {
    this.setState({ loading: { ...this.state.loading, user: true }, error: null });

    const route = this.props.match.params.userid ? 'user/' + this.props.match.params.userid : 'user';
    api()
      .get(route)
      .then(response => {
        let newState = {
          result: response.data,
          loading: { ...this.state.loading, user: false },
        };
        for (let i = 0; i < response.data.missions.length; i++) {
          let key = response.data.missions[i].id;

          newState['result'][key + '_specification'] = response.data.missions[i].specification;
          newState['result'][key + '_mission_type'] = response.data.missions[i].mission_type;
          newState['result'][key + '_start'] = response.data.missions[i].start;
          newState['result'][key + '_end'] = response.data.missions[i].end;
          newState['result'][key + '_first_time'] = response.data.missions[i].first_time;
          newState['result'][key + '_long_mission'] = response.data.missions[i].long_mission;
          newState['result'][key + '_probation_period'] = response.data.missions[i].probation_period;
        }

        this.setState(newState);

        for (let i = 0; i < response.data.missions.length; i++) {
          this.missionTag.getMissionDays(this, response.data.missions[i].id);
        }
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getRegionalCenters() {
    this.setState({ loading: { ...this.state.loading, regionalCenters: true }, error: null });
    api()
      .get('regionalcenter')
      .then(response => {
        this.setState({
          regionalCenters: response.data,
          loading: { ...this.state.loading, regionalCenters: false },
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getSpecifications() {
    this.setState({ loading: { ...this.state.loading, specifications: true }, error: null });
    api()
      .get('specification/me')
      .then(response => {
        this.setState({
          specifications: response.data,
          loading: { ...this.state.loading, specifications: false },
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getReportSheets() {
    this.setState({ loading: { ...this.state.loading, reportSheets: true }, error: null });

    let apiRoute = this.props.match.params.userid === undefined ? 'me' : this.props.match.params.userid;

    api()
      .get('reportsheet/user/' + apiRoute)
      .then(response => {
        this.setState({ loading: { ...this.state.loading, reportSheets: false }, reportSheets: response.data });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  addReportSheet(missionId) {
    this.setState({ loading: { ...this.state.loading, reportSheet: true }, error: null });

    api()
      .put('reportsheet', {
        user: this.props.match.params.userid ? this.props.match.params.userid : null,
        mission: missionId,
      })
      .then(response => {
        this.setState({ loading: { ...this.state.loading, reportSheet: false } });
        Toast.showSuccess('Hinzufügen erfolgreich', 'Meldeblatt hinzugefügt');
        this.getReportSheets();
      })
      .catch(error => {
        this.setState({ loading: { ...this.state.loading, reportSheet: false } });
        Toast.showError('Hinzufügen fehlgeschlagen', 'Meldeblatt konnte nicht hinzugefügt werden', error, path =>
          this.props.history.push(path)
        );
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

  handlePhonenumberChange(value, valid, fieldName) {
    this.setState({
      result: {
        ...this.state.result,
        [fieldName]: valid !== false ? value : this.state.result[fieldName],
      },
      phonenumberValid: {
        ...this.state.phonenumberValid,
        [fieldName]: valid,
      },
    });
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
  }

  validateIBAN(value) {
    var regex = new RegExp('^CH\\d{2,2}\\s{0,1}(\\w{4,4}\\s{0,1}){4,7}\\w{0,2}$', 'g');

    if (regex.test(value)) {
      return true;
    } else {
      return false;
    }
  }

  save() {
    let apiRoute = this.props.match.params.userid === undefined ? 'me' : this.props.match.params.userid;

    this.setState({ loading: { ...this.state.loading, save: true }, error: null });
    api()
      .post('user/' + apiRoute, this.state.result)
      .then(response => {
        Toast.showSuccess('Speichern erfolgreich', 'Profil gespeichert');
        this.setState({ loading: { ...this.state.loading, save: false } });
      })
      .catch(error => {
        this.setState({ loading: { ...this.state.loading, save: false } });
        Toast.showError('Speichern fehlgeschlagen', 'Profil konnte nicht gespeichert werden', error, path => this.props.history.push(path));
      });
  }

  redirectToChangePassword(e) {
    this.props.history.push('/changePassword');
  }

  getPasswordChangeButton() {
    return (
      <div>
        <button type="button" name="resetPassword" className="btn btn-primary" onClick={e => this.redirectToChangePassword(e)}>
          <span className="glyphicon glyphicon-wrench" /> Passwort ändern
        </button>
        <hr />
      </div>
    );
  }

  getPhonenumberClass(fieldName) {
    let isValid = this.state.phonenumberValid[fieldName];

    if (isValid === true) {
      return 'has-success';
    } else if (isValid === false) {
      return 'has-error';
    } else {
      return '';
    }
  }

  render() {
    let result = this.state.result;
    let howerText_IBAN = 'Du kannst die Nummer mit oder ohne Abständen eingeben.';
    let howerText_Berufserfahrung =
      'Wir profitieren gerne von deiner Erfahrung. Wenn wir genau wissen, wann wer mit welchen Erfahrungen einen Einsatz tätigt, können wir z.T. Projekte speziell planen.';
    let howerText_health_insurance = 'Krankenkassen Name und Ort';

    let missions = this.missionTag.getMissions(this);

    let arePhonenumbersInvalid = Object.values(this.state.phonenumberValid).some(v => v === false);

    return (
      <Header>
        <div className="page page__user_list">
          <Card>
            <h1>Profil</h1>
            <div className="container">
              <form
                className="form-horizontal"
                onSubmit={e => {
                  e.preventDefault();
                  this.save();
                }}
              >
                <hr />
                {this.getPasswordChangeButton()}
                <input name="id" value="00000" type="hidden" />
                <input name="action" value="saveEmployee" type="hidden" />

                <h3>Persönliche Informationen</h3>
                <InputField id="zdp" label="ZDP" value={result.zdp} disabled="true" />
                <InputField id="first_name" label="Vorname" value={result.first_name} onInput={this.handleChange.bind(this)} />
                <InputField id="last_name" label="Nachname" value={result.last_name} onInput={this.handleChange.bind(this)} />

                <InputField id="address" label="Strasse" value={result.address} onInput={this.handleChange.bind(this)} />
                <InputField id="city" label="Ort" value={result.city} onInput={this.handleChange.bind(this)} />
                <InputField id="zip" label="PLZ" value={result.zip} onInput={this.handleChange.bind(this)} />

                <DatePicker id="birthday" label="Geburtstag" value={result.birthday} onChange={this.handleDateChange.bind(this)} />

                <InputField id="hometown" label="Heimatort" value={result.hometown} onInput={this.handleChange.bind(this)} />

                <InputField inputType="email" id="email" label="E-Mail" value={result.email} onInput={this.handleChange.bind(this)} />
                <PhoneInput
                  id="phone_mobile"
                  label="Tel. Mobil"
                  value={result.phone_mobile}
                  groupClass={this.getPhonenumberClass('phone_mobile')}
                  onInput={(value, valid) => this.handlePhonenumberChange(value, valid, 'phone_mobile')}
                />
                <PhoneInput
                  id="phone_private"
                  label="Tel. Privat"
                  value={result.phone_private}
                  groupClass={this.getPhonenumberClass('phone_private')}
                  onInput={(value, valid) => this.handlePhonenumberChange(value, valid, 'phone_private')}
                />
                <PhoneInput
                  id="phone_business"
                  label="Tel. Geschäft"
                  value={result.phone_business}
                  groupClass={this.getPhonenumberClass('phone_business')}
                  onInput={(value, valid) => this.handlePhonenumberChange(value, valid, 'phone_business')}
                />

                <hr />
                <h3>Bank-/Postverbindung</h3>

                <div className={'form-group ' + (this.validateIBAN(result.bank_iban) ? '' : 'has-warning')} id="ibanFormGroup">
                  <label className="control-label col-sm-3" htmlFor="bank_iban">
                    IBAN-Nr.
                  </label>
                  <div className="col-sm-8">
                    <input
                      type="text"
                      id="bank_iban"
                      name="bank_iban"
                      value={result.bank_iban || ''}
                      className="form-control"
                      onChange={e => this.handleIBANChange(e)}
                    />
                  </div>
                  <div id="_helpiban" className="col-sm-1 hidden-xs">
                    <span data-toggle="popover" title="IBAN-Nr" data-content={howerText_IBAN}>
                      <span style={{ fontSize: '2em' }} className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </span>
                  </div>
                </div>
                <div className="form-group" id="bicFormGroup">
                  <label className="control-label col-sm-3" htmlFor="bank_bic">
                    BIC/SWIFT
                  </label>
                  <div className="col-sm-8">
                    <input
                      type="text"
                      id="bank_bic"
                      name="bank_bic"
                      value={result.bank_bic || ''}
                      className="form-control"
                      onChange={e => this.handleChange(e)}
                    />
                  </div>
                  <div id="_helpbic" className="col-sm-1 hidden-xs">
                    <span
                      data-toggle="popover"
                      title="BIC/SWIFT"
                      data-content="Der BIC/SWIFT code, der Deine Bank identifizert. Du findest diesen meist auf der Website Deiner Bank."
                    >
                      <span style={{ fontSize: '2em' }} className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </span>
                  </div>
                </div>
                <hr />
                <h3>Krankenkasse</h3>
                <div className="form-group" id="healthInsuranceFormGroup">
                  <label className="control-label col-sm-3" htmlFor="health_insurance">
                    Krankenkasse (Name und Ort)
                  </label>
                  <div className="col-sm-8">
                    <input
                      type="text"
                      id="health_insurance"
                      name="health_insurance"
                      value={result.health_insurance || ''}
                      className="form-control"
                      onChange={e => this.handleIBANChange(e)}
                    />
                  </div>
                  <div id="_helpiban" className="col-sm-1 hidden-xs">
                    <span data-toggle="popover" title="Krankenkasse" data-content={howerText_health_insurance}>
                      <span style={{ fontSize: '2em' }} className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </span>
                  </div>
                </div>
                <hr />

                <h3>Diverse Informationen</h3>
                <div className="form-group">
                  <label className="control-label col-sm-3" htmlFor="berufserfahrung">
                    Berufserfahrung
                  </label>
                  <div className="col-sm-8">
                    <textarea
                      rows="4"
                      id="work_experience"
                      name="work_experience"
                      className="form-control"
                      value={result.work_experience || ''}
                      onInput={e => this.handleChange(e)}
                    />
                  </div>
                  <div id="_helpberufserfahrung" className="col-sm-1 hidden-xs">
                    <span data-toggle="popover" title="Berufserfahrung" data-content={howerText_Berufserfahrung}>
                      <span style={{ fontSize: '2em' }} className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </span>
                  </div>
                </div>

                <div className="form-group">
                  <label className="control-label col-sm-3" htmlFor="hometown">
                    Regionalzentrum
                  </label>
                  <div className="col-sm-9">
                    <select
                      id="regional_center"
                      name="regional_center"
                      className="form-control"
                      onChange={e => this.handleChange(e)}
                      value={+this.state.result.regional_center || 0}
                    >
                      <option value="" />
                      {this.state.regionalCenters.map(({ id, name }) => (
                        <option key={id} value={id}>
                          {name}
                        </option>
                      ))}
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
                  onInput={this.handleChange.bind(this)}
                />

                {Auth.isAdmin() ? this.adminFields.getAdminRestrictedFields(this, result) : null}

                <button type="submit" className="btn btn-primary" disabled={arePhonenumbersInvalid}>
                  <span className="glyphicon glyphicon-floppy-disk" /> Speichern
                </button>
                {arePhonenumbersInvalid && <span>Nicht alle Telefonnummern sind valide!</span>}
              </form>
              <br />
              <hr />
              <br />

              <h3>Einsätze</h3>
              <div className="table-responsive">
                <table className="table table-condensed">
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
              <button className="btn btn-success" data-toggle="modal" data-target="#einsatzModal">
                Neue Einsatzplanung hinzufügen
              </button>
              {this.missionTag.renderMissions(this, null, Auth.isAdmin())}

              <br />
              <br />
              <hr />
              <br />

              <h3>Meldeblätter</h3>
              <div className="table-responsive">
                <table className="table table-condensed">
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
                          <tr key={obj.id}>
                            <td>{moment(obj.start, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
                            <td>{moment(obj.end, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
                            <td>{obj.days}</td>
                            <td>
                              {obj.state > 0 ? (
                                obj.state === 3 ? (
                                  <span data-toggle="popover" title="" data-content="Erledigt">
                                    <span className="glyphicon glyphicon-ok" style={{ color: 'green' }} />
                                  </span>
                                ) : (
                                  <span data-toggle="popover" title="" data-content="In Bearbeitung">
                                    <span className="glyphicon glyphicon-hourglass" style={{ color: 'orange' }} />
                                  </span>
                                )
                              ) : (
                                ''
                              )}
                            </td>
                            <td>
                              {obj.state === 3 ? (
                                <a
                                  name="showReportSheet"
                                  className="btn btn-xs btn-link"
                                  href={apiURL('pdf/zivireportsheet', { reportSheetId: obj.id }, true)}
                                  target="_blank"
                                >
                                  <span className="glyphicon glyphicon-print" aria-hidden="true" /> Drucken
                                </a>
                              ) : null}
                            </td>
                            {Auth.isAdmin() ? (
                              <td>
                                <button
                                  name="editReportSheet"
                                  className="btn btn-link btn-xs btn-warning"
                                  onClick={() => this.router.history.push('/expense/' + obj.id)}
                                >
                                  <span className="glyphicon glyphicon-edit" aria-hidden="true" /> Bearbeiten
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
          <LoadingView loading={Object.values(this.state.loading).some(a => a)} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
