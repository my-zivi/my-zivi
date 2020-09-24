import React from 'preact/compat';
import { FunctionalComponent } from 'preact';
import MonthlyGroup from 'js/organizations/services/embedded_app/models/MonthlyGroup';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';
import { Service } from 'js/organizations/services/embedded_app/types';

interface Props {
  servicesList: ServicesList;
  currentMonthlyGroup: MonthlyGroup;
}

function renderService(currentMonthlyGroup: MonthlyGroup, service: Service) {
  if (!currentMonthlyGroup.containsService(service)) {
    return (
      <div className="d-table-row" />
    );
  }

  return (
    <div className="d-table-row">
      {currentMonthlyGroup.mapDays((day) => (
        <div className="d-table-cell">
          {day.isBetween(service.beginning, service.ending, 'day', '[]') ? 'x' : ''}
        </div>
      ))}
    </div>
  );
}

const TableContent: FunctionalComponent<Props> = ({ currentMonthlyGroup, servicesList }) => (
  <>
    {servicesList.services.map((service) => renderService(currentMonthlyGroup, service))}
  </>
);

export default TableContent;
