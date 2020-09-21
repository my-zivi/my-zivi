import React from 'preact/compat';
import { FunctionalComponent } from 'preact';
import MonthlyGroup from 'js/organizations/services/embedded_app/models/MonthlyGroup';

interface Props {
  monthlyGroup: MonthlyGroup;
}

const TableContent: FunctionalComponent<Props> = ({ monthlyGroup }) => (
  <>
    {monthlyGroup.services.map((service) => (
      <div className="d-table-row">
        <div className="d-table-cell">
          {service.civilServant.fullName}
        </div>
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
