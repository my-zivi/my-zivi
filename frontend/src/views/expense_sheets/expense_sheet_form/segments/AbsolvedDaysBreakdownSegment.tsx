import * as React from 'react';
import { NumberField } from '../../../../form/common';
import { WiredField } from '../../../../form/formik';
import { ExpenseSheetHints } from '../../../../types';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const AbsolvedDaysBreakdownSegment = expenseSheetFormSegment(
  ({ hints }: { hints: ExpenseSheetHints }) => (
    <>
      <WiredField
        horizontal
        appendedLabels={[`Vorschlag: ${hints.suggestions.work_days} Tage`]}
        component={NumberField}
        name={'work_days'}
        label={'Gearbeitet'}
      />
      <WiredField
        horizontal
        appendedLabels={[`Vorschlag: ${hints.suggestions.workfree_days} Tage`]}
        component={NumberField}
        name={'workfree_days'}
        label={'Arbeitsfrei'}
      />
      <WiredField
        horizontal
        appendedLabels={[`Übriges Guthaben: ${hints.remaining_days.sick_days} Tage`]}
        component={NumberField}
        name={'sick_days'}
        label={'Krank'}
      />
    </>
  ),
);
