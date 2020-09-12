import React from 'preact/compat';
import { DATE_FORMATS } from 'js/constants';

export default ({ servicesPlan }) => {
  return (
    <tr>
      {servicesPlan.mapDays(day => (
        <th>{day.format(DATE_FORMATS.day)}</th>
      ))}
    </tr>
  );
}
