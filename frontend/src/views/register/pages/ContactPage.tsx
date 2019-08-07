import * as React from 'react';
import { NumberField, TextField } from '../../../form/common';
import { WiredField } from '../../../form/formik';

export const ContactPage = () => {
  return (
    <>
      <h3>{ContactPage.Title}</h3>
      <br />
      <WiredField
        horizontal={true}
        component={TextField}
        name={'phone'}
        label={'Telefon'}
        placeholder={'079 123 45 67'}
      />
      <WiredField
        horizontal={true}
        component={TextField}
        name={'address'}
        label={'Adresse'}
        placeholder={'Strasse, Hausnummer'}
      />
      <WiredField
        horizontal={true}
        component={TextField}
        name={'city'}
        label={'Stadt'}
        placeholder={'Stadt'}
      />
      <WiredField
        horizontal={true}
        component={NumberField}
        name={'zip'}
        label={'Postleitzahl'}
        placeholder={'z.B. 8000'}
      />
      <WiredField
        horizontal={true}
        component={TextField}
        name={'hometown'}
        label={'Heimatort'}
        placeholder={'Heimatort'}
      />
    </>
  );
};

ContactPage.Title = 'Kontaktinformationen';
