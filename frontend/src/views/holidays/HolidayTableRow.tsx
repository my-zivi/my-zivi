import * as React from 'react';
import { SelectField, TextField } from '../../form/common';
import { DatePickerField } from '../../form/DatePickerField';
import { WiredField } from '../../form/formik';

export default (params: { buttons: React.ReactElement[] }) => {
  const { buttons } = params;

  return (
    <tr>
      <td>
        <WiredField component={DatePickerField} name={'beginning'}/>
      </td>
      <td>
        <WiredField component={DatePickerField} name={'ending'}/>
      </td>
      <td>
        <WiredField
          component={SelectField}
          name={'holiday_type_id'}
          options={[
            { id: 'company_holiday', name: 'Betriebsferien' },
            { id: 'public_holiday', name: 'Feiertag' },
          ]}
        />
      </td>
      <td>
        <WiredField component={TextField} name={'description'}/>
      </td>

      {buttons.map((button, index) => <td key={`button-${index}`}>{button}</td>)}
    </tr>
  );
};
