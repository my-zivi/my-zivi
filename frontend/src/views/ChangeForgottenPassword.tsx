import { Formik, FormikActions } from 'formik';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { RouteComponentProps, withRouter } from 'react-router';
import Button from 'reactstrap/lib/Button';
import Form from 'reactstrap/lib/Form';
import * as yup from 'yup';
import { PasswordField } from '../form/common';
import { WiredField } from '../form/formik';
import IziviContent from '../layout/IziviContent';
import { ApiStore } from '../stores/apiStore';
import { DomainStore } from '../stores/domainStore';
import { MainStore } from '../stores/mainStore';

const resetSchema = yup.object({
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

const TEMPLATE = {
  password: '',
  password_confirmation: '',
};

type FormValues = typeof TEMPLATE;

interface Props extends RouteComponentProps<{ reset_password_token?: string }> {
  apiStore?: ApiStore;
  mainStore?: MainStore;
}

@inject('apiStore', 'mainStore')
@observer
class ChangeForgottenPasswordInner extends React.Component<Props> {
  state = { success: false };

  handleSubmit = async (values: FormValues, actions: FormikActions<FormValues>) => {
    try {
      await this.props.apiStore!.postForgotPassword({ ...values, reset_password_token: this.props.match.params.reset_password_token! });
      this.setState({ success: true, error: null });
      this.props.mainStore!.displaySuccess('Passwort zurückgesetzt');
    } catch (error) {
      this.props.mainStore!.displayError(DomainStore.buildErrorMessage(error, 'Konnte Passwort nicht zurücksetzen'));
    } finally {
      actions.setSubmitting(false);
    }
  }

  render() {
    return (
      <IziviContent card>
        <Formik
          initialValues={TEMPLATE}
          validationSchema={resetSchema}
          onSubmit={this.handleSubmit}
          render={formikProps => (
            <Form onSubmit={formikProps.handleSubmit}>
              <h2>Passwort zurücksetzen</h2>
              <WiredField component={PasswordField} name={'password'} label={'Passwort'} placeholder={'Neues Passwort'}/>
              <WiredField
                component={PasswordField}
                name={'password_confirmation'}
                label={'Passwort bestätigen'}
                placeholder={'Neues Passwort bestätigen'}
              />
              <Button color={'primary'} disabled={formikProps.isSubmitting || this.state.success} onClick={formikProps.submitForm}>
                Speichern
              </Button>
            </Form>
          )}
        />
      </IziviContent>
    );
  }
}

export const ChangeForgottenPassword = withRouter(ChangeForgottenPasswordInner);
