import React from 'preact/compat';
import { FunctionalComponent } from 'preact';
import MonthlyGroup from 'js/organizations/services/embedded_app/models/MonthlyGroup';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';
import { Service } from 'js/organizations/services/embedded_app/types';
import { Moment } from 'moment';

interface Props {
  servicesList: ServicesList;
  currentMonthlyGroup: MonthlyGroup;
}

function cellForDay(day: Moment, service: Service) {
  const isBetween = day.isBetween(service.beginning, service.ending, 'day', '[]');

  return (
    <div className={`d-table-cell day-cell ${isBetween ? 'active' : 'inactive'}`}>
      {isBetween ? <i class="fas fa-check"/> : ''}
    </div>
  );
}

function renderService(currentMonthlyGroup: MonthlyGroup, service: Service) {
  if (!currentMonthlyGroup.containsService(service)) {
    return (
      <div className="d-table-row" />
    );
  }

  return (
    <div className="d-table-row">
      {currentMonthlyGroup.mapDays((day) => cellForDay(day, service))}
    </div>
  );
}

const TableContent: FunctionalComponent<Props> = ({ currentMonthlyGroup, servicesList }) => (
  <>
    {servicesList.services.map((service) => renderService(currentMonthlyGroup, service))}
  </>
);

export default TableContent;
