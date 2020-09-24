import React from 'preact/compat';
import { FunctionalComponent } from 'preact';
import MonthlyGroup from 'js/organizations/services/embedded_app/models/MonthlyGroup';
import { DATE_FORMATS } from 'js/constants';

interface Props {
  monthlyGroup: MonthlyGroup;
}

const TableHeader: FunctionalComponent<Props> = ({ monthlyGroup }) => (
  <div className="d-table-row">
    {monthlyGroup.mapDays((day) => (
      <div className="d-table-cell">{day.format(DATE_FORMATS.day)}</div>
    ))}
  </div>
);

export default TableHeader;
