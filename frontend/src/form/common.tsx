import * as React from 'react';
import { ReactElement } from 'react';
import { ErrorMessage, FieldProps } from 'formik';
import Input, { InputType } from 'reactstrap/lib/Input';
import FormGroup from 'reactstrap/lib/FormGroup';
import Label from 'reactstrap/lib/Label';
import FormFeedback from 'reactstrap/lib/FormFeedback';

export type FormProps = {
  label: string;
  children: ReactElement<any>; //tslint:disable-line:no-any
  required?: boolean;
  multiline?: boolean;
} & FieldProps;

export type InputFieldProps = {
  type: InputType;
  unit?: string;
  onChange?: (e: React.ChangeEvent<HTMLInputElement>) => void;
  value?: string;
  delayed?: boolean;
  disabled?: boolean;
} & FormProps;

export const ValidatedFormGroupWithLabel = ({ label, field, form: { touched, errors }, children, required }: FormProps) => {
  const hasErrors: boolean = !!errors[field.name] && !!touched[field.name];

  return (
    <FormGroup>
      {label && (
        <Label for={field.name}>
          {label} {required && '*'}
        </Label>
      )}
      {React.cloneElement(children, { invalid: hasErrors })}
      <ErrorMessage name={field.name} render={error => <FormFeedback valid={false}>{error}</FormFeedback>} />
    </FormGroup>
  );
};

const InputFieldWithValidation = ({ label, field, form, unit, required, multiline, ...rest }: InputFieldProps) => {
  return (
    <ValidatedFormGroupWithLabel label={label} field={field} form={form} required={required}>
      <Input {...field} value={field.value === null ? '' : field.value} {...rest} />
    </ValidatedFormGroupWithLabel>
  );
};

export const EmailField = (props: InputFieldProps) => <InputFieldWithValidation type={'email'} {...props} />;

export const NumberField = (props: InputFieldProps) => <InputFieldWithValidation type={'number'} {...props} />;

export const PasswordField = (props: InputFieldProps) => <InputFieldWithValidation type={'password'} {...props} />;

export const TextField = (props: InputFieldProps & { multiline?: boolean }) => <InputFieldWithValidation type={'text'} {...props} />;
