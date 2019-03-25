import React from 'react';
import injectSheet, { WithSheet } from 'react-jss';
import { DateTimePicker } from 'react-widgets';
import createStyles from '../utilities/createStyles';
import { IziviCustomFieldProps, IziviFormControl } from './common';

const datePickerStyle = () =>
  createStyles({
    tableFix: {
      '& th, & td': {
        padding: '0.25em',
      },
    },
  });

export type DateTimePickerFieldProps = IziviCustomFieldProps<Date | undefined> & {
  label: string;
  required?: boolean;
  time?: boolean;
  editFormat?: string;
  format?: string;
  delayed?: boolean;
  disabled?: boolean;
} & WithSheet<typeof datePickerStyle>;

export interface DatePickerDefaultProps {
  time?: boolean;
  editFormat?: string;
  format?: string;
  onChange?: (d: Date) => void;
  value?: Date;
}

export type DatePickerInnerInputProps = DatePickerDefaultProps & WithSheet<typeof datePickerStyle>;

const DatePickerDefaults = (props: DatePickerDefaultProps) => (
  <DateTimePicker time={false} editFormat={'DD.MM.YYYY'} format={'DD.MM.YYYY'} {...(props as any)} />
);

const DateTimePickerFieldWithValidationInner = ({
  label,
  value,
  onChange,
  required,
  horizontal,
  errorMessage,
  ...rest
}: DateTimePickerFieldProps) => (
  <span className={rest.classes.tableFix}>
    <IziviFormControl label={label} required={required} horizontal={horizontal} errorMessage={errorMessage}>
      <DatePickerDefaults onChange={(date?: Date) => onChange(date)} value={value ? new Date(value) : undefined} {...rest} />
    </IziviFormControl>
  </span>
);
const DateTimePickerFieldWithValidation = injectSheet(datePickerStyle)(DateTimePickerFieldWithValidationInner);

const DatePickerInputInner = ({ classes, ...props }: DatePickerInnerInputProps) => (
  <span className={classes.tableFix}>
    <DatePickerDefaults {...props} />
  </span>
);
const DatePickerInputSheeted = injectSheet(datePickerStyle)(DatePickerInputInner);
export const DatePickerInput = (props: DatePickerDefaultProps) => <DatePickerInputSheeted {...props} />;

export const DatePickerField = (props: DateTimePickerFieldProps) => <DateTimePickerFieldWithValidation {...props} />;
