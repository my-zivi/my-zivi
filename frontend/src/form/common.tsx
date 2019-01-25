import * as React from 'react';
import { ReactElement } from 'react';
import Input, { InputType } from 'reactstrap/lib/Input';
import FormGroup from 'reactstrap/lib/FormGroup';
import Label from 'reactstrap/lib/Label';
import FormFeedback from 'reactstrap/lib/FormFeedback';
import Col from 'reactstrap/lib/Col';
import InputGroup from 'reactstrap/lib/InputGroup';
import InputGroupAddon from 'reactstrap/lib/InputGroupAddon';

export interface SharedProps {
  label?: string;
  required?: boolean;
  multiline?: boolean;
  horizontal?: boolean;
  appendedLabels?: string[];
  errorMessage?: string;
  name?: string;
}

export interface IziviFormControlProps extends SharedProps {
  children: React.ReactElement<any>;
  errorMessage?: string;
}

export interface IziviFieldProps extends SharedProps {
  type?: InputType;
  disabled?: boolean;
  onBlur?: () => void;
}

export type SelectFieldProps = {
  options: Array<{
    id: string;
    name: string;
  }>;
} & IziviInputFieldProps;

export interface IziviInputFieldProps<T = string> extends IziviFieldProps {
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  value: T;
}

export interface IziviCustomFieldProps<T, OutputValue = T> extends IziviFieldProps {
  value: T;
  onChange: (value: OutputValue) => void;
}

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

export const withColumn = () => (wrappedComponent: React.ReactNode) => <Col md={9}>{wrappedComponent}</Col>;

const ClonedField = ({ children, invalid }: ClonedFieldProps) => React.cloneElement(children, { invalid });

export const IziviFormControl = ({ label, children, required, horizontal, appendedLabels, name, errorMessage }: IziviFormControlProps) => {
  const clonedField = <ClonedField children={children} invalid={Boolean(errorMessage)} />;
  const labels = Boolean(appendedLabels) ? appendedLabels : [];

  return (
    <FormGroup row={horizontal}>
      {label && (
        <Label for={name} md={horizontal ? 3 : undefined}>
          {label} {required && '*'}
        </Label>
      )}
      {labels!.length > 0 && horizontal && withColumn()(withInputGroupAddon(labels!)(clonedField))}
      {labels!.length > 0 && !horizontal && withInputGroupAddon(labels!)(clonedField)}
      {labels!.length <= 0 && horizontal && withColumn()(clonedField)}
      {labels!.length <= 0 && !horizontal && clonedField}

      {errorMessage && <FormFeedback valid={false}>{errorMessage}</FormFeedback>}
    </FormGroup>
  );
};

export const IziviInputField = ({
  label,
  required,
  multiline,
  horizontal,
  appendedLabels,
  value,
  errorMessage,
  ...rest
}: IziviInputFieldProps & Partial<IziviFormControlProps>) => {
  return (
    <IziviFormControl label={label} required={required} horizontal={horizontal} appendedLabels={appendedLabels} errorMessage={errorMessage}>
      <Input value={value === null ? '' : value} {...rest} type={multiline ? 'textarea' : rest.type} />
    </IziviFormControl>
  );
};

const SelectFieldWithValidation = ({ label, required, multiline, options, horizontal, value, errorMessage, ...rest }: SelectFieldProps) => {
  return (
    <IziviFormControl label={label} required={required} horizontal={horizontal} errorMessage={errorMessage}>
      <Input value={value === null ? '' : value} {...rest}>
        {options.map(option => (
          <option value={option.id} key={option.id}>
            {option.name}
          </option>
        ))}
      </Input>
    </IziviFormControl>
  );
};

export const EmailField = (props: IziviInputFieldProps) => <IziviInputField type={'email'} {...props} />;

export const NumberField = (props: IziviInputFieldProps) => <IziviInputField type={'number'} {...props} />;

export const PasswordField = (props: IziviInputFieldProps) => <IziviInputField type={'password'} {...props} />;

export const TextField = (props: IziviInputFieldProps & { multiline?: boolean }) => <IziviInputField type={'text'} {...props} />;

export const DateField = (props: IziviInputFieldProps) => <IziviInputField type={'date'} {...props} />;

export const SelectField = (props: SelectFieldProps) => <SelectFieldWithValidation type={'select'} {...props} />;
