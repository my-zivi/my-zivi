import * as React from 'react';
import { CheckboxField } from '../../../../form/CheckboxField';
import { TextField } from '../../../../form/common';
import CurrencyField from '../../../../form/CurrencyField';
import { WiredField } from '../../../../form/formik';
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
    </>
  ),
);
