import * as React from 'react';
import { NumberField, TextField } from '../../../../form/common';
import { WiredField } from '../../../../form/formik';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const UnpaidVacationSegment = expenseSheetFormSegment(
  () => (
    <>
      <WiredField horizontal component={NumberField} name={'unpaid_vacation_days'} label={'Persönlicher Urlaub'}/>
      <WiredField horizontal component={TextField} name={'unpaid_vacation_comment'} label={'Bemerkung'}/>
    </>
  ),
);
