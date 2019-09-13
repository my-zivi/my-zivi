import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import * as React from 'react';
import Button from 'reactstrap/lib/Button';
import { ExpenseSheetStore } from '../../../../../stores/expenseSheetStore';
import { ExpenseSheetState } from '../../../../../types';
import { DoubleAngleRightIcon } from '../../../../../utilities/Icon';

interface SwitchToReadyForPaymentProps {
  expenseSheetStore: ExpenseSheetStore;
}

export const SwitchToReadyForPayment = ({ expenseSheetStore }: SwitchToReadyForPaymentProps) => {
  const [isLoading, setIsLoading] = React.useState(false);

  return (
    <Button
      color="success"
      disabled={isLoading}
      onClick={() => {
        setIsLoading(true);
        expenseSheetStore.putState(ExpenseSheetState.ready_for_payment).catch(() => setIsLoading(false));
        // If the state update was successful, this button will be replaced with a new component.
        // Hence, we don't need to update the state again on success
      }}
    >
      <FontAwesomeIcon icon={DoubleAngleRightIcon}/> Auf Bereit für Auszahlung ändern
    </Button>
  );
};
