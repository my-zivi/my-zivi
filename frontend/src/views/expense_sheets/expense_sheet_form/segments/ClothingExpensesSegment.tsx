import * as React from 'react';
import CurrencyField from '../../../../form/CurrencyField';
import { WiredField } from '../../../../form/formik';
import { MainStore } from '../../../../stores/mainStore';
import { ExpenseSheetHints } from '../../../../types';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const ClothingExpensesSegment = expenseSheetFormSegment(
  ({ hints, mainStore }: { hints: ExpenseSheetHints, mainStore: MainStore }) => (
    <>
      <WiredField
        horizontal
        appendedLabels={[`Vorschlag: ${mainStore!.formatCurrency(hints.suggestions.clothing_expenses)}`]}
        component={CurrencyField}
        name={'clothing_expenses'}
        label={'Kleiderspesen'}
      />
    </>
  ),
);
