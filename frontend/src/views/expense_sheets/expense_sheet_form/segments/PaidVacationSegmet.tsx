import * as React from 'react';
import { NumberField, TextField } from '../../../../form/common';
import { WiredField } from '../../../../form/formik';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const PaidVacationSegment = expenseSheetFormSegment(
  () => (
    <>
      <WiredField horizontal component={NumberField} name={'paid_vacation_days'} label={'Ferien'}/>
      <WiredField horizontal component={TextField} name={'paid_vacation_comment'} label={'Bemerkung'}/>
    </>
  ),
);
