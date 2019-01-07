import * as React from 'react';
import { inject, observer } from 'mobx-react';
import { ApiStore } from '../stores/apiStore';
import { RouteComponentProps } from 'react-router';
import { Link } from 'react-router-dom';
import { Field, Formik, FormikActions } from 'formik';
import Form from 'reactstrap/lib/Form';
import Button from 'reactstrap/lib/Button';
import * as yup from 'yup';
import { PasswordField, TextField } from '../form/common';
import IziviContent from '../layout/IziviContent';
import { MainStore } from '../stores/mainStore';

const loginSchema = yup.object({
  email: yup
    .string()
    .email()
    .required(),
  password: yup.string().required(),
});

const template = {
  email: '',
  password: '',
};

type FormValues = typeof template;

interface Props extends RouteComponentProps {
  apiStore?: ApiStore;
  mainStore?: MainStore;
}

@inject('apiStore', 'mainStore')
@observer
export class Login extends React.Component<Props> {
  login = async (values: FormValues, actions: FormikActions<FormValues>) => {
    try {
      await this.props.apiStore!.postLogin(values);
      this.props.history.push(this.getReferrer());
    } catch (error) {
      if (error.toString().includes('401')) {
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

  render() {
    return (
      <IziviContent card showBackgroundImage>
        <Formik
          initialValues={template}
          validationSchema={loginSchema}
          onSubmit={this.login}
          render={formikProps => (
            <Form onSubmit={formikProps.handleSubmit}>
              <h2 className="form-signin-heading">Anmelden</h2>
              <Field component={TextField} name={'email'} label={'Email'} placeholder={'zivi@example.org'} />
              <Field component={PasswordField} name={'password'} label={'Passwort'} placeholder={'****'} />
              <Button color={'primary'} disabled={formikProps.isSubmitting} onClick={formikProps.submitForm}>
                Anmelden
              </Button>
            </Form>
          )}
        />
        <p>
          <Link to="/forgotPassword">Passwort vergessen?</Link>
        </p>
      </IziviContent>
      /*<LoadingView loading={this.state.loading} error={this.state.error} />*/
    );
  }
}
