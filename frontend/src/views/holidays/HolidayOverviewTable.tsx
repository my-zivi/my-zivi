import { Moment } from 'moment';
import * as React from 'react';
import Table from 'reactstrap/lib/Table';
import { MainStore } from '../../stores/mainStore';
import { Holiday } from '../../types';

function getColumns(formatDate: (date: string | Moment) => string) {
  return [
    {
      id: 'beginning',
      numeric: false,
      label: 'Start',
      format: ({ beginning }: Holiday) => formatDate(beginning),
    },
    {
      id: 'ending',
      numeric: false,
      label: 'Ende',
      format: ({ ending }: Holiday) => formatDate(ending),
    },
    {
      id: 'holiday_type_id',
      numeric: false,
      label: 'Type',
    },
    {
      id: 'description',
      numeric: false,
      label: 'Beschreibung',
    },
    {
      id: 'save',
      numeric: false,
      label: '',
    },
    {
      id: 'delete',
      numeric: false,
      label: '',
    },
  ];
}

export const HolidayOverviewTable: React.FunctionComponent<{mainStore: MainStore}> = props => {
  const { formatDate } = props.mainStore;

  const columns = getColumns(formatDate);

  return (
    <Table>
      <thead>
      <tr>
        {columns.map(column => (
          <th key={column.id}>{column.label}</th>
        ))}
      </tr>
      </thead>
      <tbody>
        {props.children}
      </tbody>
    </Table>
  );
};
