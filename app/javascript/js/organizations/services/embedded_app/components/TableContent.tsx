import React from 'preact/compat';
import { FunctionalComponent } from 'preact';
import MonthlyGroup from 'js/organizations/services/embedded_app/models/MonthlyGroup';
import { DATE_FORMATS } from 'js/constants';

interface Props {
  monthlyGroup: MonthlyGroup;
}

const TableContent: FunctionalComponent<Props> = ({ monthlyGroup }) => (
  <>
    {monthlyGroup.services.map((service, index) => (
      <div className="d-table-row">
        {monthlyGroup.mapDays((day) => (
          <div className="d-table-cell">
            {day.isBetween(service.beginning, service.ending) ? 'x' : ''}
          </div>
        ))}
      </div>
    ))}
  </>
);

export default TableContent;
