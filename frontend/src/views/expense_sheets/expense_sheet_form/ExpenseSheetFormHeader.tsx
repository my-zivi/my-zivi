import * as React from 'react';
import Badge from 'reactstrap/lib/Badge';
import { ExpenseSheetState, Service, ServiceSpecification } from '../../../types';
import { Formatter } from '../../../utilities/formatter';
import { stateTranslation } from '../../../utilities/helpers';

const formatDate = (date: Date | null) => {
  if (!date) {
    return 'Unbekannt';
  }

  return new Formatter().formatDate(date.toString());
};

interface ExpenseSheetFormHeaderProps {
  service: Service;
  expenseSheetState: ExpenseSheetState;
  serviceSpecification: ServiceSpecification;
}
export const ExpenseSheetFormHeader = (props: ExpenseSheetFormHeaderProps) => {
  return (
    <h5 className="mb-5 text-secondary">
      Für den Einsatz{' '}
      <span className="text-body">{props.serviceSpecification.name}</span>
      {' '}vom{' '}
      <span className="text-body">{formatDate(props.service.beginning)}</span>
      {' '}bis{' '}
      <span className="text-body">{formatDate(props.service.ending)}</span>
      <Badge color="secondary" className="ml-3 align-bottom" pill>{stateTranslation(props.expenseSheetState)}</Badge>
    </h5>
  );
};
