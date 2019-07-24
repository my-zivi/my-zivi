import { FormikProps } from 'formik';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { RouteComponentProps, withRouter } from 'react-router';
import Button from 'reactstrap/lib/Button';
import Col from 'reactstrap/lib/Col';
import Form from 'reactstrap/lib/Form';
import Row from 'reactstrap/lib/Row';
import { CheckboxField } from '../../form/CheckboxField';
import { NumberField, SelectField, TextField } from '../../form/common';
import { DatePickerField } from '../../form/DatePickerField';
import { WiredField } from '../../form/formik';
import { FormView, FormViewProps } from '../../form/FormView';
import { SolidHorizontalRow } from '../../layout/SolidHorizontalRow';
import { MainStore } from '../../stores/mainStore';
import { RegionalCenterStore } from '../../stores/regionalCenterStore';
import { ServiceSpecificationStore } from '../../stores/serviceSpecificationStore';
import { UserStore } from '../../stores/userStore';
import { User } from '../../types';
import { empty } from '../../utilities/helpers';
// import { ReportSheetSubform } from './ReportSheetSubform';
import { userSchema } from './schemas';
import { ServiceSubform } from './service_subform/ServiceSubform';

type Props = {
  mainStore?: MainStore;
  user: User;
  userStore?: UserStore;
  serviceSpecificationStore?: ServiceSpecificationStore;
  regionalCenterStore?: RegionalCenterStore;
} & FormViewProps<User> &
  RouteComponentProps;

@inject('mainStore', 'userStore', 'serviceSpecificationStore', 'regionalCenterStore')
@observer
class UserFormInner extends React.Component<Props> {
  componentWillMount() {
    void this.props.serviceSpecificationStore!.fetchAll();
    void this.props.regionalCenterStore!.fetchAll();
  }

  render() {
    const { onSubmit, user, title, mainStore } = this.props;

    return (
      <>
        <FormView<User>
          card
          loading={empty(user) || this.props.loading}
          initialValues={user}
          onSubmit={(updatedUser: User): Promise<void> => onSubmit(updatedUser as User)}
          title={title}
          validationSchema={userSchema}
          render={(formikProps: FormikProps<User>) => (
            <Form>
              <h3>Persönliche Informationen</h3>
              <p>
                Bitte fülle die folgenden Felder zu deiner Person wahrheitsgetreu aus. Dadurch erleichterst du dir und uns den
                administrativen Aufwand. <br />
                Wir verwenden diese Informationen ausschliesslich zur Erstellung der Einsatzplanung und zur administrativen Abwicklung.
              </p>
              <p>Bitte lies dir auch die näheren Informationen zu den jeweiligen Feldern unter dem Icon jeweils durch.</p>
              <p>Wichtig: Vergiss nicht zu speichern (Daten speichern) bevor du die Seite verlässt oder eine Einsatzplanung erfasst.</p>

              <SolidHorizontalRow />

              <WiredField disabled horizontal component={TextField} name={'zdp'} label={'ZDP'} />
              <WiredField horizontal component={TextField} name={'first_name'} label={'Vorname'} />
              <WiredField horizontal component={TextField} name={'last_name'} label={'Nachname'} />
              <WiredField horizontal component={TextField} name={'address'} label={'Strasse'} />
              <WiredField horizontal component={NumberField} name={'zip'} label={'PLZ'} />
              <WiredField horizontal component={TextField} name={'city'} label={'Ort'} />
              <WiredField horizontal component={TextField} name={'hometown'} label={'Heimatort'} />
              <WiredField horizontal component={DatePickerField} name={'birthday'} label={'Geburtstag'} />

              <SolidHorizontalRow />
              <h3>Kontaktmöglichkeit</h3>
              <p>Telefonnummer bitte im Format "044 123 45 67" angeben.</p>

              <WiredField horizontal component={TextField} name={'email'} label={'E-Mail'} />
              <WiredField horizontal component={TextField} name={'phone'} label={'Telefon'} />

              <SolidHorizontalRow />
              <h3>Bank-/Postverbindung</h3>

              <WiredField horizontal component={TextField} name={'bank_iban'} label={'IBAN-Nummer'} />

              <SolidHorizontalRow />
              <h3>Krankenkasse</h3>

              <WiredField horizontal component={TextField} name={'health_insurance'} label={'Krankenkasse (Name und Ort)'} />

              <SolidHorizontalRow />
              <h3>Diverse Informationen</h3>

              <WiredField horizontal multiline={true} component={TextField} name={'work_experience'} label={'Berufserfahrung'} />
              <WiredField
                horizontal
                component={SelectField}
                name={'regional_center_id'}
                label={'Regionalzentrum'}
                options={this.props.regionalCenterStore!.entities.map(({ id, name }) => ({ id, name }))}
              />
              <WiredField horizontal component={CheckboxField} name={'driving_licence_b'} label={'Führerausweis Kat. B'} />
              <WiredField horizontal component={CheckboxField} name={'driving_licence_be'} label={'Führerausweis Kat. BE'} />
              <WiredField horizontal component={CheckboxField} name={'chainsaw_workshop'} label={'Motorsägekurs bereits absolviert'} />

              {mainStore!.isAdmin() && (
                <>
                  <WiredField
                    horizontal
                    component={SelectField}
                    name={'role'}
                    label={'Benutzerrolle'}
                    options={[
                      {id: 'admin', name: 'Admin'},
                      {id: 'civil_servant', name: 'Zivildienstleistender'},
                    ]}
                  />
                  <WiredField horizontal multiline={true} component={TextField} name={'internal_note'} label={'Interne Bemerkung'} />
                </>
              )}

              <Row>
                <Col md={2}>
                  <Button block color={'primary'} onClick={formikProps.submitForm}>Speichern</Button>
                </Col>
              </Row>
            </Form>
          )}
        >
          <SolidHorizontalRow />
          <ServiceSubform user={user} />

          <SolidHorizontalRow />
          {/*<ReportSheetSubform user={user} />*/}
        </FormView>
      </>
    );
  }
}

export const UserForm = withRouter(UserFormInner);
