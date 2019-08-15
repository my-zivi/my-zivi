import * as React from 'react';
import { NumberField } from '../../../../form/common';
import { WiredField } from '../../../../form/formik';
import { ExpenseSheetHints } from '../../../../types';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const CompanyHolidaysSegment = expenseSheetFormSegment(
  ({ hints }: { hints: ExpenseSheetHints }) => (
    <>
      <WiredField
        horizontal
        appendedLabels={[`Vorschlag: ${hints.suggestions.unpaid_company_holiday_days} Tage`]}
        component={NumberField}
        name={'unpaid_company_holiday_days'}
        label={'Betriebsferien (Urlaub)'}
      />
      <WiredField
        horizontal
        appendedLabels={[`Vorschlag: ${hints.suggestions.paid_company_holiday_days} Tage`]}
        component={NumberField}
        name={'paid_company_holiday_days'}
        label={'Betriebsferien (Ferien)'}
      />
    </>
  ),
);
