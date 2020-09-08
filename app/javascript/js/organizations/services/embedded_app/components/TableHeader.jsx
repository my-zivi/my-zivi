import React, { h } from 'preact';
import { DATE_FORMATS } from '../../../../constants';

export default ({ servicesPlan }) => {
  return (
    <tr>
      {servicesPlan.mapDays(day => (
        <th>{day.format(DATE_FORMATS.day)}</th>
      ))}
    </tr>
  );
}
