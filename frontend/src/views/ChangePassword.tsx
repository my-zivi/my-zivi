import { Formik, FormikActions } from 'formik';
import { repeat } from 'lodash';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { Form } from 'reactstrap';
import Button from 'reactstrap/lib/Button';
import * as yup from 'yup';
import { PasswordField } from '../form/common';
import { WiredField } from '../form/formik';
import IziviContent from '../layout/IziviContent';
import { ApiStore } from '../stores/apiStore';
import { DomainStore } from '../stores/domainStore';
import { MainStore } from '../stores/mainStore';

const changePasswordSchema = yup.object({
  current_password: yup.string().required('Pflichtfeld'),
  password: yup
    .string()
    .required('Pflichtfeld')
    .min(6, 'Passwort muss mindestens 6 Zeichen sein'),
  password_confirmation: yup
    .string()
    .required('Pflichtfeld')
    .min(6, 'Passwort muss mindestens 6 Zeichen sein')
    .test('passwords-match', 'Passwörter müssen übereinstimmen', function(value) {
      return this.parent.password === value;
    }),
});

const template = {
  current_password: '',
  password: '',
  password_confirmation: '',
};

type FormValues = typeof template;

interface ChangePasswordProps {
  apiStore?: ApiStore;
  mainStore?: MainStore;
}

@inject('apiStore', 'mainStore')
@observer
class ChangePassword extends React.Component<ChangePasswordProps> {
  constructor(props: ChangePasswordProps) {
    super(props);
  }

  changePassword = async (values: FormValues, actions: FormikActions<FormValues>) => {
    try {
      await this.props.apiStore!.putChangePassword(values);
      this.props.mainStore!.displaySuccess('Passwort wurde erfolgreich gespeichert!');
    } catch (error) {
      this.displayError(error);
      throw error;
    } finally {
      actions.setSubmitting(false);
    }
  }

  render(): React.ReactNode {
    const passwordPlaceholder = repeat('*', 7);
    return (
      <IziviContent card title={'Passwort ändern'}>
        <Formik
          initialValues={template}
          validationSchema={changePasswordSchema}
          onSubmit={this.changePassword}
          render={formikProps => (
            <Form onSubmit={formikProps.handleSubmit}>
              <WiredField component={PasswordField} name={'current_password'} label={'Altes Passwort'} placeholder={passwordPlaceholder} />
              <WiredField component={PasswordField} name={'password'} label={'Neues Passwort'} placeholder={passwordPlaceholder} />
              <WiredField
                component={PasswordField}
                name={'password_confirmation'}
                label={'Neues Passwort wiederholen'}
                placeholder={passwordPlaceholder}
              />
              <Button color={'primary'} disabled={formikProps.isSubmitting} onClick={formikProps.submitForm}>
                Passwort ändern
              </Button>
              <Button className={'ml-3'} color={'danger'} onClick={() => (window.location.pathname = '/')}>
                Abbrechen
              </Button>
            </Form>
          )}
        />
      </IziviContent>
    );
  }

  private displayError(error: any) {
    if (this.isCurrentPasswordInvalid(error)) {
      this.props.mainStore!.displayError('Das eingegebene Passwort ist falsch');
    } else {
      this.props.mainStore!.displayError(
        DomainStore.buildErrorMessage(error, 'Ein interner Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.'),
      );
    }
  }

  private isCurrentPasswordInvalid(error: any) {
    try {
      const currentPasswordError = error.messages.errors.current_password;
      return /valide?|gültig/.test(currentPasswordError);
    } catch (_error) { // tslint:disable-line:variable-name
      return false;
    }
  }
}

export { ChangePassword };
