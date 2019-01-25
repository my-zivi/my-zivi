// tslint:disable
// https://github.com/jaredpalmer/formik-effect/issues/4#issuecomment-410205716

import React from 'react';
import { connect, FormikProps } from 'formik';

export type OnChange<T> = (current: FormState<T>, next: FormState<T>, formik: FormikProps<T>) => void;

interface FormState<T> {
  values: T;
  touched: any;
  errors: any;
  isSubmitting: boolean;
}

interface Props<T> {
  onChange: OnChange<T>;
  formik: any;
}

class Effect<T> extends React.Component<Props<T>> {
  componentWillReceiveProps(nextProps: any) {
    const { values, touched, errors, isSubmitting }: any = this.props.formik;
    const { values: nextValues, touched: nextTouched, errors: nextErrors, isSubmitting: nextIsSubmitting } = nextProps.formik;

    if (nextProps.formik !== this.props.formik) {
      this.props.onChange(
        {
          values,
          touched,
          errors,
          isSubmitting,
        },
        {
          values: nextValues,
          touched: nextTouched,
          errors: nextErrors,
          isSubmitting: nextIsSubmitting,
        },
        this.props.formik
      );
    }
  }

  render() {
    return null;
  }
}

// without this, typescript requires the `formik` prop on the Effect component, which is actually provided by `connect`
const anyEffect = connect(Effect) as any;
export default anyEffect;
