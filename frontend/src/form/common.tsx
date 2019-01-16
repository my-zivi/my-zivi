import * as React from 'react';
import { ReactElement } from 'react';
import { ErrorMessage, FieldProps } from 'formik';
import Input, { InputType } from 'reactstrap/lib/Input';
import FormGroup from 'reactstrap/lib/FormGroup';
import Label from 'reactstrap/lib/Label';
import FormFeedback from 'reactstrap/lib/FormFeedback';
import Col from 'reactstrap/lib/Col';
import InputGroup from 'reactstrap/lib/InputGroup';
import InputGroupAddon from 'reactstrap/lib/InputGroupAddon';

export type FormProps = {
  label?: string;
  required?: boolean;
  multiline?: boolean;
  horizontal?: boolean;
  appendedLabels?: string[];
} & FieldProps;

type FormPropsWithChildren = {
  children: ReactElement<any>; //tslint:disable-line:no-any
} & FormProps;

export type InputFieldProps = {
  type: InputType;
  unit?: string;
  onChange?: (e: React.ChangeEvent<HTMLInputElement>) => void;
  value?: string;
  delayed?: boolean;
  disabled?: boolean;
} & FormProps;

export type SelectFieldProps = {
  options: Array<{
    id: string;
    name: string;
  }>;
} & InputFieldProps;

interface ClonedFieldProps {
  children: ReactElement<any>; //tslint:disable-line:no-any
  invalid: boolean;
}

const withInputGroupAddon = (appendedLabels: string[]) => (wrappedComponent: React.ReactNode) => (
  <InputGroup>
    {wrappedComponent}
    {appendedLabels.map((label: string, index) => (
      <InputGroupAddon key={index} addonType={'append'}>
        {label}
      </InputGroupAddon>
    ))}
  </InputGroup>
);

const withColumn = () => (wrappedComponent: React.ReactNode) => <Col md={9}>{wrappedComponent}</Col>;

const ClonedField = ({ children, invalid }: ClonedFieldProps) => React.cloneElement(children, { invalid });

export const ValidatedFormGroupWithLabel = ({
  label,
  field,
  form: { touched, errors },
  children,
  required,
  horizontal,
  appendedLabels,
}: FormPropsWithChildren) => {
  const hasErrors: boolean = !!errors[field.name] && !!touched[field.name];
  const clonedField = <ClonedField children={children} invalid={hasErrors} />;
  const labels = Boolean(appendedLabels) ? appendedLabels : [];

  return (
    <FormGroup row={horizontal}>
      {label && (
        <Label for={field.name} md={horizontal ? 3 : undefined}>
          {label} {required && '*'}
        </Label>
      )}
      {labels!.length > 0 && horizontal && withColumn()(withInputGroupAddon(labels!)(clonedField))}
      {labels!.length > 0 && !horizontal && withInputGroupAddon(labels!)(clonedField)}
      {labels!.length <= 0 && horizontal && withColumn()(clonedField)}
      {labels!.length <= 0 && !horizontal && clonedField}

      <ErrorMessage name={field.name} render={error => <FormFeedback valid={false}>{error}</FormFeedback>} />
    </FormGroup>
  );
};

export const InputFieldWithValidation = ({
  label,
  field,
  form,
  unit,
  required,
  multiline,
  horizontal,
  appendedLabels,
  ...rest
}: InputFieldProps) => {
  return (
    <ValidatedFormGroupWithLabel
      label={label}
      field={field}
      form={form}
      required={required}
      horizontal={horizontal}
      appendedLabels={appendedLabels}
    >
      <Input {...field} value={field.value === null ? '' : field.value} {...rest} />
    </ValidatedFormGroupWithLabel>
  );
};

const SelectFieldWithValidation = ({ label, field, form, unit, required, multiline, options, horizontal, ...rest }: SelectFieldProps) => {
  return (
    <ValidatedFormGroupWithLabel label={label} field={field} form={form} required={required} horizontal={horizontal}>
      <Input {...field} value={field.value === null ? '' : field.value} {...rest}>
        {options.map(option => (
          <option value={option.id} key={option.id}>
            {option.name}
          </option>
        ))}
      </Input>
    </ValidatedFormGroupWithLabel>
  );
};

export const EmailField = (props: InputFieldProps) => <InputFieldWithValidation type={'email'} {...props} />;

export const NumberField = (props: InputFieldProps) => <InputFieldWithValidation type={'number'} {...props} />;

export const PasswordField = (props: InputFieldProps) => <InputFieldWithValidation type={'password'} {...props} />;

export const TextField = (props: InputFieldProps & { multiline?: boolean }) => <InputFieldWithValidation type={'text'} {...props} />;

export const DateField = (props: InputFieldProps) => <InputFieldWithValidation type={'date'} {...props} />;

export const SelectField = (props: SelectFieldProps) => <SelectFieldWithValidation type={'select'} {...props} />;
