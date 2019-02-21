import * as React from 'react';
import FormGroup from 'reactstrap/lib/FormGroup';
import Label from 'reactstrap/lib/Label';
import Input from 'reactstrap/lib/Input';
import Col from 'reactstrap/lib/Col';
import { IziviCustomFieldProps } from './common';

// The checkbox requires it's own kind of "logic" to render
// we can't wrap it into our common stuff in common.tsx
// so it has its own sets of props

interface CheckboxFieldProps extends IziviCustomFieldProps<boolean> {
  horizontal?: boolean;
  label: string;
  required?: boolean;
}

export const CheckboxField = ({ value, onChange, name, horizontal, label, required, errorMessage }: CheckboxFieldProps) => {
  const hasErrors = Boolean(errorMessage);
  return (
    <FormGroup check={!horizontal} row={horizontal}>
      {label && (
        <Label check={!horizontal} for={name} md={horizontal ? 3 : undefined}>
          {horizontal && label}
          {!horizontal && (
            <>
              <Input id={name} checked={value} onChange={() => onChange(!value)} invalid={hasErrors} type="checkbox" /> {label}{' '}
              {required && '*'}
            </>
          )}
        </Label>
      )}
      {horizontal && (
        <Col md={9}>
          <FormGroup check>
            <Label check>
              <Input id={name} checked={value} onChange={() => onChange(!value)} invalid={hasErrors} type="checkbox" />
            </Label>
          </FormGroup>
        </Col>
      )}
    </FormGroup>
  );
};
