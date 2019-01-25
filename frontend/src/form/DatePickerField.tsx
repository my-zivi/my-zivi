import React from 'react';
import { FormProps, ValidatedFormGroupWithLabel } from './common';
import injectSheet, { WithSheet } from 'react-jss';
import { DateTimePicker } from 'react-widgets';
import createStyles from 'src/utilities/createStyles';

const datePickerStyle = () =>
  createStyles({
    tableFix: {
      '& th, & td': {
        padding: '0.25em',
      },
    },
  });

export type DateTimePickerFieldProps = FormProps & {
  label: string;
  required?: boolean;
  onChange?: (date?: Date) => void;
  time?: boolean;
  editFormat?: string;
  format?: string;
  value: Date;
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
  <DateTimePicker time={false} editFormat={'DD.MM.YYYY'} format={'DD.MM.YYYY'} {...props} />
);

const DateTimePickerFieldWithValidationInner = ({ label, field, form, required, horizontal, ...rest }: DateTimePickerFieldProps) => (
  <span className={rest.classes.tableFix}>
    <ValidatedFormGroupWithLabel label={label} field={field} form={form} required={required} horizontal={horizontal}>
      <DatePickerDefaults
        onChange={(date?: Date) => form.setFieldValue(field.name, date)}
        value={field.value !== null ? new Date(field.value) : null}
        {...rest}
      />
    </ValidatedFormGroupWithLabel>
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
