import { Formik, FormikConfig, FormikProps } from 'formik';
import * as React from 'react';
import { Prompt } from 'react-router';
import { HandleFormikSubmit } from '../types';
import { FormikSubmitDetector } from './FormikSubmitDetector';
import IziviContent from '../layout/IziviContent';

export interface FormViewProps<T> {
  card?: boolean;
  onSubmit: (values: T) => Promise<void>;
  loading?: boolean;
  title?: string;
  submitted?: boolean;
}

interface Props<T> extends FormViewProps<T> {
  render: (props: FormikProps<T>) => React.ReactNode;
}

export class FormView<Values = object, ExtraProps = {}> extends React.Component<FormikConfig<Values> & ExtraProps & Props<Values>> {
  private handleSubmit: HandleFormikSubmit<Values> = async (values, formikBag) => {
    try {
      await this.props.onSubmit(this.props.validationSchema.cast(values));
    } finally {
      formikBag.setSubmitting(false);
    }
  };

  public render() {
    // tslint:disable-next-line:no-any ; need this so we can spread into ...rest
    const { title, ...rest } = this.props as any;
    return this.props.loading ? (
      <>
        <IziviContent title={title}>
          <p>Laden ... (eine lange Zeit)</p>
        </IziviContent>
      </>
    ) : (
      <Formik
        {...rest}
        enableReinitialize
        onSubmit={this.handleSubmit}
        render={(formikProps: FormikProps<Values>) => (
          <FormikSubmitDetector {...formikProps}>
            <Prompt when={!this.props.submitted && formikProps.dirty} message={() => 'Änderungen verwerfen?'} />
            <IziviContent card={this.props.card} title={title}>
              {this.props.render(formikProps)}
            </IziviContent>
          </FormikSubmitDetector>
        )}
      />
    );
  }
}
