import * as React from 'react';
import IziviContent from '../layout/IziviContent';
import { Component, ReactNode } from 'react';
import Container from 'reactstrap/lib/Container';
import { WiredField } from '../form/formik';
import { PasswordField, TextField } from '../form/common';
import { Formik, FormikActions } from 'formik';
import Button from 'reactstrap/lib/Button';
import * as yup from 'yup';
import Form from 'reactstrap/lib/Form';
import { CheckboxField } from '../form/CheckboxField';
import { ApiStore } from '../stores/apiStore';
import { MainStore } from '../stores/mainStore';
import { inject, observer } from 'mobx-react';
import { RouteComponentProps } from 'react-router';

const loginSchema = yup.object({
  zdp: yup.number().required(),
  firstname: yup.string().required(),
  lastname: yup.string().required(),
  email: yup
    .string()
    .email()
    .required(),
  password: yup
    .string()
    .required()
    .min(7, 'hi'),
  password_confirm: yup
    .string()
    .required()
    .test('passwords-match', 'Passwörter müssen übereinstimmen', function(value) {
      return this.parent.password === value;
    }),
  community_pw: yup.string().required(),
});

const template = {
  zdp: '',
  firstname: '',
  lastname: '',
  email: '',
  password: '',
  password_confirm: '',
  community_pw: '',
  newsletter: true,
};

type FormValues = typeof template;

interface RegisterProps extends RouteComponentProps {
  apiStore?: ApiStore;
  mainStore?: MainStore;
}

@inject('apiStore', 'mainStore')
@observer
class Register extends Component<RegisterProps> {
  login = async (values: FormValues, actions: FormikActions<FormValues>) => {
    try {
      console.log(values);
      await this.props.apiStore!.postRegister(values);
      this.props.history.push(this.getReferrer());
    } catch ({ error }) {
      if (error.toString().includes('400')) {
        this.props.mainStore!.displayError('Ungültiger Benutzername/Passwort');
      } else {
        this.props.mainStore!.displayError('Ein interner Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.');
      }
    } finally {
      actions.setSubmitting(false);
    }
  };

  getReferrer() {
    const { state, search } = this.props.location;
    // check for referer in router state (from ProtectedRoute in index.js)
    if (state && state.referrer) {
      return state.referrer;
    }

    // check for the old 'path' query parameter
    const query = new URLSearchParams(search);
    const apiStore = this.props.apiStore!;

    if (query.has('path')) {
      let url = query.get('path');
      if (url && url.startsWith('/login')) {
        url = apiStore.isAdmin ? '/' : '/profile';
      }
      return url;
    }
    return apiStore.isAdmin ? '/' : '/profile';
  }

  render(): ReactNode {
    return (
      <IziviContent card showBackgroundImage title={'Registrieren'}>
        <div>
          <p>
            Als zukünftiger Zivi musst du dich zuerst erkundigen, ob zum gewünschten Zeitpunkt ein Einsatz möglich ist. Kontaktiere hierfür
            bitte direkt{' '}
            <a href="//stiftungswo.ch/about/meet-the-team#jumptomarc" target="_blank" rel="noopener noreferrer">
              {' '}
              Marc Pfeuti{' '}
            </a>
            (<a href={'tel:+41774385761'}>+41 77 438 57 61</a>) unter{' '}
            <a
              href="mailto:zivildienst@stiftungswo.ch?subject=Einsatzplanung Zivildienst&body=Guten Tag Herr Pfeuti!
              %0D%0A%0D%0AIch schreibe Ihnen betreffend meiner Einsatzplanung als FELDZIVI / BÜROZIVI (EINS AUSWÄHLEN) vom DD.MM.YYYY bis DD.MM.YYYY, wäre dieser Zeitraum möglich?
              %0D%0A%0D%0A
              %0D%0A%0D%0ABesten Dank und freundliche Grüsse"
            >
              {' '}
              zivildienst@stiftungswo.ch{' '}
            </a>
            .
          </p>
          <ul>
            <li>
              Nach Eingabe deiner persönlichen Daten kannst du die Einsatzplanung ausdrucken, unterschreiben und an den Einsatzbetrieb
              zurückzuschicken. Nach erfolgreicher Prüfung werden wir diese direkt an dein zuständiges Regionalzentrum weiterleiten. Das
              Aufgebot erhältst du dann automatisch von deinem zuständigen Regionalzentrum.
            </li>
          </ul>
          <Container>
            <hr />
            <Formik
              initialValues={template}
              validationSchema={loginSchema}
              onSubmit={this.login}
              render={formikProps => (
                <Form onSubmit={formikProps.handleSubmit}>
                  <h3>Persönliche Informationen</h3>
                  <br />
                  <WiredField
                    horizontal={true}
                    component={TextField}
                    name={'zdp'}
                    label={'Zivildienstnummer (ZDP)'}
                    placeholder={'Dies ist deine Zivildienst-Nummer, welche du auf deinem Aufgebot wiederfindest'}
                  />
                  <WiredField horizontal={true} component={TextField} name={'firstname'} label={'Vorname'} placeholder={'Dein Vorname'} />
                  <WiredField horizontal={true} component={TextField} name={'lastname'} label={'Nachname'} placeholder={'Dein Nachname'} />
                  <WiredField
                    horizontal={true}
                    component={TextField}
                    name={'email'}
                    label={'Email'}
                    placeholder={'Wird für das zukünftige Login sowie das Versenden von Systemnachrichten benötigt'}
                  />
                  <WiredField
                    horizontal={true}
                    component={PasswordField}
                    name={'password'}
                    label={'Passwort (mind. 7 Zeichen)'}
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
                    component={PasswordField}
                    name={'community_pw'}
                    label={'Community Passwort'}
                    placeholder={'Dieses erhälst du von der Einsatzleitung welche dich berechtigt einen Account zu eröffnen'}
                  />
                  <WiredField
                    horizontal={true}
                    component={CheckboxField}
                    name={'newsletter'}
                    label={'Ja, ich möchte den SWO Newsletter erhalten'}
                  />
                  <Button color={'primary'} disabled={formikProps.isSubmitting} onClick={formikProps.submitForm}>
                    Registrieren
                  </Button>
                  <br />
                </Form>
              )}
            />
          </Container>
        </div>
      </IziviContent>
    );
  }
}

export { Register };
