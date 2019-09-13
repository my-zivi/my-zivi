import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { CheckboxField } from '../../../form/CheckboxField';
import { NumberField, PasswordField, SelectField, TextField } from '../../../form/common';
import { DatePickerField } from '../../../form/DatePickerField';
import { WiredField } from '../../../form/formik';
import { LoadingInformation } from '../../../layout/LoadingInformation';
import { RegionalCenterStore } from '../../../stores/regionalCenterStore';

interface PersonalDetailsPageProps {
  regionalCenterStore?: RegionalCenterStore;
}

@inject('regionalCenterStore')
@observer
export class PersonalDetailsPage extends React.Component<PersonalDetailsPageProps, { loading: boolean }> {
  static Title = 'Persönliche Informationen';

  constructor(props: PersonalDetailsPageProps) {
    super(props);

    this.props.regionalCenterStore!.fetchAll().then(() => this.setState({ loading: false }));
    this.state = { loading: true };
  }

  render() {
    if (this.state.loading) {
      return <LoadingInformation message="Lade Formular" className="mb-3" />;
    }

    return (
      <>
        <h3 className={'mb-3'}>{PersonalDetailsPage.Title}</h3>
        <WiredField
          horizontal={true}
          component={NumberField}
          name={'zdp'}
          label={'Zivildienstnummer (ZDP)'}
          placeholder={'Dies ist deine Zivildienst-Nummer, welche du auf deinem Aufgebot wiederfindest'}
        />
        <WiredField
          horizontal={true}
          component={SelectField}
          name={'regional_center_id'}
          label={'Regionalzentrum'}
          options={this.props.regionalCenterStore!.entities.map(({ id, name }) => ({ id, name }))}
        />
        <WiredField horizontal={true} component={TextField} name={'first_name'} label={'Vorname'} placeholder={'Dein Vorname'}/>
        <WiredField horizontal={true} component={TextField} name={'last_name'} label={'Nachname'} placeholder={'Dein Nachname'}/>
        <WiredField
          horizontal={true}
          component={TextField}
          name={'email'}
          label={'Email'}
          placeholder={'Wird für das zukünftige Login sowie das Versenden von Systemnachrichten benötigt'}
        />
        <WiredField horizontal={true} component={DatePickerField} name={'birthday'} label={'Geburtstag'} placeholder={'dd.mm.yyyy'}/>
        <WiredField
          horizontal={true}
          component={PasswordField}
          name={'password'}
          label={'Passwort (mind. 6 Zeichen)'}
          placeholder={'Passwort mit mindestens 7 Zeichen'}
        />
        <WiredField
          horizontal={true}
          component={PasswordField}
          name={'password_confirm'}
          label={'Passwort Bestätigung'}
          placeholder={'Wiederhole dein gewähltes Passwort'}
        />
        <WiredField
          horizontal={true}
          component={CheckboxField}
          name={'newsletter'}
          label={'Ja, ich möchte den SWO Newsletter erhalten'}
        />
      </>
    );
  }
}
