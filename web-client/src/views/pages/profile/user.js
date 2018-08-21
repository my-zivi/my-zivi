import React, { Component } from 'react';
import { api } from '../../../utils/api';
import Auth from '../../../utils/auth';
import DatePicker from '../../tags/InputFields/DatePicker';
import InputCheckbox from '../../tags/InputFields/InputCheckbox';
import InputField from '../../tags/InputFields/InputField';
import PhoneInput from '../../tags/InputFields/PhoneInput';
import ProfileAdminFields from './profile_admin_fields';
import RegionalCenters from './regional_centers';
import Toast from '../../../utils/toast';

export default class User extends Component {
  constructor(props) {
    super(props);

    this.state = {
      formErrors: [],
      user: {},
    };

    this.addFormError = this.addFormError.bind(this);
    this.changeResult = this.changeResult.bind(this);
    this.deleteFormError = this.deleteFormError.bind(this);
    this.fieldHasError = this.fieldHasError.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  changeResult(key, value) {
    const { user } = this.state;

    this.setState({
      user: {
        ...user,
        [key]: value,
      },
    });
  }

  componentDidMount() {
    this.getUser();
  }

  fieldHasError(field) {
    return this.state.formErrors.includes(field);
  }

  getUser() {
    this.props.onLoading('user', true);
    const route = this.props.userIdParam ? 'user/' + this.props.userIdParam : 'user';

    api()
      .get(route)
      .then(response => {
        this.setState({
          user: response.data,
        });
        this.props.onLoading('user', false);
      })
      .catch(error => {
        this.props.onError(error);
      });
  }

  handleChange(e) {
    if (e.target.type === 'checkbox') {
      this.changeResult(e.target.name, !this.state.user[e.target.name]);
    } else {
      this.changeResult(e.target.name, e.target.value);
    }
  }

  onSubmit(e) {
    e.preventDefault();
    this.props.onLoading('user', true);

    const apiRoute = this.props.userIdParam ? this.props.userIdParam : 'me';
    const { user } = this.state;

    api()
      .post('user/' + apiRoute, user)
      .then(response => {
        Toast.showSuccess('Speichern erfolgreich', 'Profil aktualisiert');
        this.props.onLoading('user', false);
      })
      .catch(error => {
        this.props.onLoading('user', false);
        Toast.showError('Speichern fehlgeschlagen', 'Profil konnte nicht gespeichert werden', error);
      });
  }

  addFormError(field) {
    const { formErrors } = this.state;

    if (!formErrors.includes(field)) {
      this.setState({
        formErrors: [...formErrors, field],
      });
    }
  }

  deleteFormError(field) {
    const { formErrors } = this.state;

    if (formErrors.includes(field)) {
      this.setState({
        formErrors: formErrors.filter(item => {
          return item !== field;
        }),
      });
    }
  }

  validateIBAN(value) {
    var regex = new RegExp('^CH\\d{2,2}\\s{0,1}(\\w{4,4}\\s{0,1}){4,7}\\w{0,2}$', 'g');
    return regex.test(value);
  }

  render() {
    const { user } = this.state;
    const { userIdParam } = this.props;
    const howerText_health_insurance = 'Krankenkassen Name und Ort';
    const howerText_IBAN =
      'Die IBAN-Nr. wird zur Überweisung für die von der "Vollzugsstelle für Zivildienst" festgelegten Entschädigungen und Spesen benützt. Inkorrekte Angaben führen somit zu Verspätung der Auszahlungen. Du kannst die Nummer mit oder ohne Abständen eingeben.';
    const howerText_work_experience =
      'Wir profitieren gerne von deiner Berufserfahrung und können diese bei Möglichkeit in unsere Projekte einfliessen lassen.';

    return (
      <div>
        <h3>Persönliche Informationen</h3>
        <p>
          Bitte fülle die folgenden Felder zu deiner Person wahrheitsgetreu aus. Dadurch erleichterst du dir und uns den administrativen
          Aufwand. Wir verwenden diese Informationen ausschliesslich zur Erstellung der Einsatzplanung und zur administrativen Abwicklung.
        </p>
        <p>
          Bitte lies dir auch die näheren Informationen zu den jeweiligen Feldern unter dem{' '}
          <span style={{ fontSize: '1em' }} className="glyphicon glyphicon-question-sign" aria-hidden="true" /> Icon jeweils durch.
        </p>
        <p>
          <b>Wichtig:</b> Vergiss nicht zu speichern (Daten speichern) bevor du die Seite verlässt oder eine Einsatzplanung erfasst.
        </p>
        <br />
        <form className={'form-horizontal'} onSubmit={e => this.onSubmit(e)}>
          <InputField id={'zdp'} label={'ZDP'} value={user.zdp} disabled={true} />
          <InputField id={'first_name'} label={'Vorname'} value={user.first_name} onInput={this.handleChange} />
          <InputField id={'last_name'} label={'Nachname'} value={user.last_name} onInput={this.handleChange} />

          <InputField id={'address'} label={'Strasse'} value={user.address} onInput={this.handleChange} />
          <InputField id={'zip'} label={'PLZ'} value={user.zip} onInput={this.handleChange} />
          <InputField id={'city'} label={'Ort'} value={user.city} onInput={this.handleChange} />
          <InputField id={'hometown'} label={'Heimatort'} value={user.hometown} onInput={this.handleChange} />
          <DatePicker id={'birthday'} label={'Geburtstag'} value={user.birthday} onChange={this.handleChange} />

          <hr />
          <h3>Kontaktmöglichkeiten</h3>

          <p>Telefonnummer bitte im Format "044 123 45 67" angeben.</p>
          <br />

          <InputField inputType={'email'} id={'email'} label={'E-Mail'} value={user.email} onInput={this.handleChange} />

          <PhoneInput
            id={'phone_mobile'}
            label={'Mobiltelefonnummer'}
            value={user.phone_mobile}
            addFormError={this.addFormError}
            deleteFormError={this.deleteFormError}
            onChange={this.handleChange}
            changeResult={this.changeResult}
            fieldHasError={this.fieldHasError}
          />

          <PhoneInput
            id={'phone_private'}
            label={'Telefon privat'}
            value={user.phone_private}
            addFormError={this.addFormError}
            deleteFormError={this.deleteFormError}
            onChange={this.handleChange}
            changeResult={this.changeResult}
            fieldHasError={this.fieldHasError}
          />

          <PhoneInput
            id={'phone_business'}
            label={'Telefon Geschäftlich'}
            value={user.phone_business}
            addFormError={this.addFormError}
            deleteFormError={this.deleteFormError}
            onChange={this.handleChange}
            changeResult={this.changeResult}
            fieldHasError={this.fieldHasError}
          />

          <hr />

          <h3>Bank-/Postverbindung</h3>
          <div className={'form-group ' + (this.validateIBAN(user.bank_iban) ? '' : 'has-warning')} id="ibanFormGroup">
            <label className={'control-label col-sm-3'} htmlFor={'bank_iban'}>
              IBAN-Nummer
            </label>

            <div className={'col-sm-8'}>
              <input
                type={'text'}
                id={'bank_iban'}
                name={'bank_iban'}
                value={user.bank_iban || ''}
                className={'form-control'}
                onChange={e => this.handleChange(e)}
              />
            </div>

            <div id={'_helpiban'} className={'col-sm-1 hidden-xs'}>
              <span data-toggle="popover" title={'IBAN-Nummer'} data-content={howerText_IBAN}>
                <span style={{ fontSize: '2em' }} className={'glyphicon glyphicon-question-sign'} aria-hidden={'true'} />
              </span>
            </div>
          </div>

          <div className={'form-group'} id={'bicFormGroup'}>
            <label className={'control-label col-sm-3'} htmlFor={'bank_bic'}>
              BIC / SWIFT
            </label>

            <div className={'col-sm-8'}>
              <input
                type={'text'}
                id={'bank_bic'}
                name={'bank_bic'}
                value={user.bank_bic || ''}
                className={'form-control'}
                onChange={e => this.handleChange(e)}
              />
            </div>

            <div id={'_helpbic'} className={'col-sm-1 hidden-xs'}>
              <span
                data-toggle="popover"
                title={'BIC / SWIFT'}
                data-content="Der BIC/SWIFT code, der Deine Bank identifizert. Du findest diesen meist auf der Website Deiner Bank."
              >
                <span style={{ fontSize: '2em' }} className={'glyphicon glyphicon-question-sign'} aria-hidden={'true'} />
              </span>
            </div>
          </div>

          <hr />
          <h3>Krankenkasse</h3>
          <div className={'form-group'} id={'healthInsuranceFormGroup'}>
            <label className={'control-label col-sm-3'} htmlFor={'health_insurance'}>
              Krankenkasse (Name und Ort)
            </label>

            <div className={'col-sm-8'}>
              <input
                type={'text'}
                id={'health_insurance'}
                name={'health_insurance'}
                value={user.health_insurance || ''}
                className={'form-control'}
                onChange={e => this.handleChange(e)}
              />
            </div>

            <div id={'_help_health_insurance'} className={'col-sm-1 hidden-xs'}>
              <span data-toggle="popover" title={'Krankenkasse'} data-content={howerText_health_insurance}>
                <span style={{ fontSize: '2em' }} className={'glyphicon glyphicon-question-sign'} aria-hidden={'true'} />
              </span>
            </div>
          </div>
          <hr />

          <h3>Diverse Informationen</h3>
          <div className={'form-group'}>
            <label className={'control-label col-sm-3'} htmlFor={'work_experience'}>
              Berufserfahrung
            </label>

            <div className={'col-sm-8'}>
              <textarea
                rows={'4'}
                id={'work_experience'}
                name={'work_experience'}
                className={'form-control'}
                value={user.work_experience}
                onChange={e => this.handleChange(e)}
              />
            </div>

            <div id={'_help_work_experience'} className={'col-sm-1 hidden-xs'}>
              <span data-toggle="popover" title={'Berufserfahrung'} data-content={howerText_work_experience}>
                <span style={{ fontSize: '2em' }} className={'glyphicon glyphicon-question-sign'} aria-hidden={'true'} />
              </span>
            </div>
          </div>

          <RegionalCenters
            onLoading={this.props.onLoading}
            onError={this.props.onError}
            onChange={this.handleChange}
            selectedCenter={user.regional_center}
          />
          <InputCheckbox id={'ga_travelcard'} value={user.ga_travelcard} label={'GA'} onChange={this.handleChange} />

          <InputCheckbox id={'driving_licence'} value={user.driving_licence} label={'Führerausweis'} onChange={this.handleChange} />

          <InputCheckbox id={'half_fare_travelcard'} value={user.half_fare_travelcard} label={'Halbtax'} onChange={this.handleChange} />

          <InputField id={'other_fare_network'} label={'Andere Abos'} value={user.other_fare_network} onInput={this.handleChange} />

          {Auth.isAdmin() &&
            userIdParam && <ProfileAdminFields internalNote={user.internal_note || ''} userRole={user.role} onChange={this.handleChange} />}

          <button type={'submit'} className={'btn btn-primary'} disabled={this.state.formErrors.length > 0}>
            <span className={'glyphicon glyphicon-floppy-disk'} /> Speichern
          </button>
        </form>
      </div>
    );
  }
}
