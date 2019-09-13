import * as React from 'react';
import { TextField } from '../../../form/common';
import { WiredField } from '../../../form/formik';

export const BankAndInsurancePage = () => {
  return (
    <>
      <h3>{BankAndInsurancePage.Title}</h3>
      <br />
      <WiredField
        horizontal={true}
        component={TextField}
        name={'bank_iban'}
        label={'IBAN'}
        placeholder={'Deine IBAN wird für das Auszahlen der Spesen benötigt'}
      />
      <WiredField
        horizontal={true}
        component={TextField}
        name={'health_insurance'}
        label={'Krankenkasse'}
        placeholder={'Name & Ort der Krankenkasse'}
      />
    </>
  );
};

BankAndInsurancePage.Title = 'Bank- und Versicherungsinformationen';
