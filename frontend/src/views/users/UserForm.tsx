import Button from 'reactstrap/lib/Button';
import Col from 'reactstrap/lib/Col';
import Form from 'reactstrap/lib/Form';
import Row from 'reactstrap/lib/Row';
import { NumberField, TextField, SelectField } from '../../form/common';
import * as React from 'react';
import { DatePickerField } from '../../form/DatePickerField';
import { empty } from '../../utilities/helpers';
import { Field, FormikProps } from 'formik';
import { FormView, FormViewProps } from '../../form/FormView';
import { inject, observer } from 'mobx-react';
import { MainStore } from '../../stores/mainStore';
import { User } from '../../types';
import { RouteComponentProps, withRouter } from 'react-router';
import { SolidHorizontalRow } from '../../layout/SolidHorizontalRow';
import { userSchema } from './schemas';
import { UserStore } from 'src/stores/userStore';
import { CheckboxField } from 'src/form/CheckboxField';
import { MissionSubform } from './MissionSubform';
import { SpecificationStore } from 'src/stores/specificationStore';

type Props = {
  mainStore?: MainStore;
  user: User;
  userStore?: UserStore;
  specificationStore?: SpecificationStore;
} & FormViewProps<User> &
  RouteComponentProps;

@inject('mainStore', 'userStore', 'specificationStore')
@observer
class UserFormInner extends React.Component<Props> {
  componentWillMount = () => {
    this.props.specificationStore!.fetchAll();
  };

  public render() {
    const { onSubmit, user, title, mainStore } = this.props;

    return (
      <>
        <FormView
          card
          loading={empty(user) || this.props.loading}
          initialValues={user}
          onSubmit={onSubmit}
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

              <Field disabled horizontal component={TextField} name={'zdp'} label={'ZDP'} />
              <Field horizontal component={TextField} name={'first_name'} label={'Vorname'} />
              <Field horizontal component={TextField} name={'last_name'} label={'Nachname'} />
              <Field horizontal component={TextField} name={'address'} label={'Strasse'} />
              <Field horizontal component={NumberField} name={'zip'} label={'PLZ'} />
              <Field horizontal component={TextField} name={'city'} label={'Ort'} />
              <Field horizontal component={TextField} name={'hometown'} label={'Heimatort'} />
              <Field horizontal component={DatePickerField} name={'birthday'} label={'Geburtstag'} />

              <SolidHorizontalRow />
              <h3>Kontaktmöglichkeit</h3>
              <p>Telefonnummer bitte im Format "044 123 45 67" angeben.</p>

              <Field horizontal component={TextField} name={'email'} label={'E-Mail'} />
              <Field horizontal component={TextField} name={'phone'} label={'Telefon'} />

              <SolidHorizontalRow />
              <h3>Bank-/Postverbindung</h3>

              <Field horizontal component={TextField} name={'bank_iban'} label={'IBAN-Nummer'} />
              <Field horizontal component={TextField} name={'bank_bic'} label={'BIC / SWIFT'} />

              <SolidHorizontalRow />
              <h3>Krankenkasse</h3>

              <Field horizontal component={TextField} name={'health_insurance'} label={'Krankenkasse (Name und Ort)'} />

              <SolidHorizontalRow />
              <h3>Diverse Informationen</h3>

              <Field horizontal multiline={true} component={TextField} name={'work_experience'} label={'Berufserfahrung'} />
              <Field horizontal component={SelectField} name={'regional_center_id'} label={'Regionalzentrum'} options={[]} />
              <Field horizontal component={CheckboxField} name={'driving_licence_b'} label={'Führerausweis Kat. B'} />
              <Field horizontal component={CheckboxField} name={'driving_licence_be'} label={'Führerausweis Kat. BE'} />
              <Field horizontal component={CheckboxField} name={'chainsaw_workshop'} label={'Motorsägekurs bereits absolviert'} />

              {mainStore!.isAdmin() && (
                <>
                  <Field horizontal component={SelectField} name={'work_experience'} label={'Benutzerrolle'} options={[]} />
                  <Field horizontal multiline={true} component={TextField} name={'internal_note'} label={'Interne Bemerkung'} />
                </>
              )}

              <Row>
                <Col md={2}>
                  <Button block color={'primary'} onClick={formikProps.submitForm}>
                    Speichern
                  </Button>
                </Col>
              </Row>
            </Form>
          )}
        >
          <SolidHorizontalRow />
          <MissionSubform user={user} />
        </FormView>
      </>
    );
  }
}

export const UserForm = withRouter(UserFormInner);
