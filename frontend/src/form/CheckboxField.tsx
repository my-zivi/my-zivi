import * as React from 'react';
import FormGroup from 'reactstrap/lib/FormGroup';
import Label from 'reactstrap/lib/Label';
import Input from 'reactstrap/lib/Input';
import { FieldProps } from 'formik';
import Col from 'reactstrap/lib/Col';

// The checkbox requires it's own kind of "logic" to render
// we can't wrap it into our common stuff in common.tsx
// so it has its own sets of props

interface CheckboxFieldProps extends FieldProps {
  horizontal?: boolean;
  label: string;
  required?: boolean;
}

export const CheckboxField = ({ field, form: { touched, errors }, horizontal, label, required }: CheckboxFieldProps) => {
  const hasErrors: boolean = !!errors[field.name] && !!touched[field.name];

  return (
    <FormGroup check={!horizontal} row={horizontal}>
      {label && (
        <Label check={!horizontal} for={field.name} md={horizontal ? 3 : undefined}>
          {horizontal && label}
          {!horizontal && (
            <>
              <Input {...field} checked={field.value} invalid={hasErrors} type="checkbox" /> {label} {required && '*'}
            </>
          )}
        </Label>
      )}
      {horizontal && (
        <Col md={9}>
          <FormGroup check>
            <Label check>
              <Input {...field} checked={field.value} invalid={hasErrors} type="checkbox" />
            </Label>
          </FormGroup>
        </Col>
      )}
    </FormGroup>
  );
};
