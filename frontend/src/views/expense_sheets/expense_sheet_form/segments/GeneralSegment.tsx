import { Field } from 'formik';
import * as React from 'react';
import { NumberField } from '../../../../form/common';
import { DatePickerField } from '../../../../form/DatePickerField';
import { WiredField } from '../../../../form/formik';
import { Service } from '../../../../types';
import { expenseSheetFormSegment } from './expenseSheetFormSegment';

export const GeneralSegment = expenseSheetFormSegment(
  ({service}: { service: Service }) => (
    <>
      <WiredField horizontal component={DatePickerField} name={'beginning'} label={'Start Spesenblattperiode'}/>
      <WiredField horizontal component={DatePickerField} name={'ending'} label={'Ende Spesenblattperiode'}/>

      <Field
        disabled
        horizontal
        component={NumberField}
        label="Ferienanspruch für Einsatz"
        value={service.eligible_paid_vacation_days}
      />
      <WiredField disabled horizontal component={NumberField} name={'duration'} label={'Dauer Spesenblattperiode'}/>
    </>
  ),
);
