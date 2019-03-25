import { Formik, FormikActions } from 'formik';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { RouteComponentProps } from 'react-router';
import Button from 'reactstrap/lib/Button';
import Form from 'reactstrap/lib/Form';
import * as yup from 'yup';
import { TextField } from '../form/common';
import { WiredField } from '../form/formik';
import IziviContent from '../layout/IziviContent';
import { ApiStore } from '../stores/apiStore';
import { MainStore } from '../stores/mainStore';

const forgotSchema = yup.object({
  email: yup
    .string()
    .email()
    .required(),
});

const template = {
  email: '',
};

type FormValues = typeof template;

interface Props extends RouteComponentProps {
  apiStore?: ApiStore;
  mainStore?: MainStore;
}

@inject('apiStore', 'mainStore')
@observer
export class ForgotPassword extends React.Component<Props> {
  state = {
    success: false,
  };

  handleSubmit = async (values: FormValues, actions: FormikActions<FormValues>) => {
    try {
      await this.props.apiStore!.postForgotPassword(values.email);
      this.setState({ success: true, error: null });
    } catch ({ error, messages }) {
      messages.forEach(this.props.mainStore!.displayError);
    } finally {
      actions.setSubmitting(false);
    }
  }

  render() {
    return (
      <IziviContent card showBackgroundImage>
        <Formik
          initialValues={template}
          validationSchema={forgotSchema}
          onSubmit={this.handleSubmit}
          render={formikProps => (
            <Form onSubmit={formikProps.handleSubmit}>
              <h2>Passwort vergessen</h2>
              {this.state.success && (
                <div className="alert alert-info">
                  <strong>E-Mail gesendet</strong>
                  <br />
                  Sie haben eine E-Mail mit einem Link zum Passwort-Reset erhalten.
                </div>
              )}
              <WiredField component={TextField} name={'email'} label={'Email'} placeholder={'zivi@example.org'} />
              <Button color={'primary'} disabled={formikProps.isSubmitting} onClick={formikProps.submitForm}>
                Weiter
              </Button>
            </Form>
          )}
        />
      </IziviContent>
    );
  }
}
