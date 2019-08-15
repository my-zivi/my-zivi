import * as React from 'react';
import Form from 'reactstrap/lib/Form';
import { NumberField, TextField } from '../../../../form/common';
import CurrencyField from '../../../../form/CurrencyField';
import { WiredField } from '../../../../form/formik';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const ExtraordinaryExpensesSegment = expenseSheetFormSegment(
  () => (
    <>
      <WiredField horizontal component={CurrencyField} name={'extraordinary_expenses'} label={'Ausserordentliche Spesen'}/>
      <WiredField horizontal component={TextField} name={'extraordinary_expenses_comment'} label={'Bemerkung'}/>
    </>
  ),
);
