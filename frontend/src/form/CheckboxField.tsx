import * as React from 'react';
import FormGroup from 'reactstrap/lib/FormGroup';
import Label from 'reactstrap/lib/Label';
import Input from 'reactstrap/lib/Input';
import Col from 'reactstrap/lib/Col';
import { IziviCustomFieldProps } from './common';
import injectSheet, { WithSheet } from 'react-jss';
import createStyles from '../utilities/createStyles';

const styles = () =>
  createStyles({
    noselect: {
      userSelect: 'none',
    },
  });

// The checkbox requires its own kind of "logic" to render
// we can't wrap it into our common stuff in common.tsx
// so it has its own sets of props

interface CheckboxFieldProps extends IziviCustomFieldProps<boolean>, WithSheet<typeof styles> {
  horizontal?: boolean;
  label: string;
  required?: boolean;
  className?: string;
}

export const CheckboxFieldContent = ({
  value,
  onChange,
  name,
  horizontal,
  label,
  required,
  errorMessage,
  classes,
  className,
}: CheckboxFieldProps) => {
  const hasErrors = Boolean(errorMessage);
  return (
    <FormGroup check={!horizontal} row={horizontal}>
      {label && (
        <Label className={classes.noselect} check={!horizontal} for={name} md={horizontal ? 3 : undefined}>
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
            <Label className={classes.noselect} check>
              <Input id={name} checked={value} onChange={() => onChange(!value)} invalid={hasErrors} type="checkbox" />
            </Label>
          </FormGroup>
        </Col>
      )}
      {!horizontal && !label && (
        <Input
          className={'position-static ' + className}
          id={name}
          checked={value}
          onChange={() => onChange(!value)}
          invalid={hasErrors}
          type="checkbox"
        />
      )}
    </FormGroup>
  );
};

export const CheckboxField = injectSheet(styles)(CheckboxFieldContent);
