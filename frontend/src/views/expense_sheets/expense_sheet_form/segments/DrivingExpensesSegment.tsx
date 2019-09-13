import * as React from 'react';
import { TextField } from '../../../../form/common';
import CurrencyField from '../../../../form/CurrencyField';
import { WiredField } from '../../../../form/formik';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const DrivingExpensesSegment = expenseSheetFormSegment(
  () => (
    <>
      <WiredField horizontal component={CurrencyField} name={'driving_expenses'} label={'Fahrspesen'}/>
      <WiredField horizontal component={TextField} name={'driving_expenses_comment'} label={'Bemerkung'}/>
    </>
  ),
);
