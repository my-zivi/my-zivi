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
import { DomainStore } from '../stores/domainStore';
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
      await this.props.apiStore!.postForgotPassword({ email: values.email });
      this.setState({ success: true, error: null });
    } catch (error) {
      this.props.mainStore!.displayError(DomainStore.buildErrorMessage(error, 'Konnte Passwort nicht zurücksetzen'));
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
                  <h6>E-Mail gesendet</h6>
                  Sie haben eine E-Mail mit einem Link zum Passwort-Reset erhalten, falls uns die E-Mail bekannt ist.
                </div>
              )}
              <WiredField
                component={TextField}
                disabled={this.state.success}
                name={'email'}
                label={'Email'}
                placeholder={'zivi@example.org'}
              />
              {!this.state.success &&
              <Button color={'primary'} disabled={formikProps.isSubmitting} onClick={formikProps.submitForm}>
                Weiter
              </Button>
              }
            </Form>
          )}
        />
      </IziviContent>
    );
  }
}
