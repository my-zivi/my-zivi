import { Field, FieldProps, getIn } from 'formik';
import * as React from 'react';
import { IziviFormControlProps, IziviInputFieldProps } from './common';

const wireFormik = ({ delayed = false } = {}) => (Component: React.ComponentType<IziviFormControlProps & IziviInputFieldProps>) => ({
  form,
  field,
  ...rest
}: IziviFormControlProps & FieldProps) => {
  const touched = getIn(form.touched, field.name);
  const error = getIn(form.errors, field.name);
  // tslint:disable-next-line:no-any
  const handleChange = (x: any) => {
    if (x === null) {
      form.setFieldValue(field.name, null);
    } else if (x.target && x.target.type === 'checkbox') {
      form.setFieldValue(field.name, x.target.checked);
    } else if (x.target) {
      form.setFieldValue(field.name, x.target.value);
    } else {
      form.setFieldValue(field.name, x);
    }
  };
  const handleBlur = () => {
    form.setFieldTouched(field.name, true);
  };
  return <Component errorMessage={touched && error ? error : undefined} {...field} onChange={handleChange} onBlur={handleBlur} {...rest} />;
};

type WiredFieldProps = any; // tslint:disable-line:no-any ; formik field does this, so we do too

export class WiredField extends React.Component<WiredFieldProps, { component: React.ReactType }> {
  componentWillMount() {
    this.setState({
      component: wireFormik({ delayed: this.props.delayed })(this.props.component),
    });
  }

  componentDidUpdate(prevProps: Readonly<WiredFieldProps>) {
    if (prevProps.component !== this.props.component) {
      this.setState({
        component: wireFormik({ delayed: this.props.delayed })(this.props.component),
      });
    }
  }

  render() {
    const { component, delayed, ...rest } = this.props;
    return <Field component={this.state.component} {...rest} />;
  }
}
