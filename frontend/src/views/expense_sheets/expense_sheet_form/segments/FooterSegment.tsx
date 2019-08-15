import * as React from 'react';
import Form from 'reactstrap/lib/Form';
import { CheckboxField } from '../../../../form/CheckboxField';
import { NumberField, SelectField, TextField } from '../../../../form/common';
import CurrencyField from '../../../../form/CurrencyField';
import { WiredField } from '../../../../form/formik';
import { ExpenseSheetState } from '../../../../types';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const FooterSegment = expenseSheetFormSegment(
  () => (
    <>
      <WiredField
        horizontal
        component={CheckboxField}
        name={'ignore_first_last_day'}
        label={'Erster / Letzter Tag nicht speziell behandeln'}
      />
      <WiredField disabled horizontal component={CurrencyField} name={'total'} label={'Total'}/>
      <WiredField horizontal component={TextField} name={'bank_account_number'} label={'Konto-Nr.'}/>
      <WiredField
        horizontal
        component={SelectField}
        name={'state'}
        options={[
          { id: ExpenseSheetState.open, name: 'Offen' },
          { id: ExpenseSheetState.ready_for_payment, name: 'Bereit für Auszahlung' },
          { id: ExpenseSheetState.payment_in_progress, name: 'Auszahlung in Verarbeitung' },
          { id: ExpenseSheetState.paid, name: 'Erledigt' },
        ]}
        label={'Status'}
      />
    </>
  ),
);
