import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import * as React from 'react';
import Button from 'reactstrap/lib/Button';
import { ExpenseSheetStore } from '../../../../../stores/expenseSheetStore';
import { ExpenseSheetState } from '../../../../../types';
import { DoubleAngleLeftIcon } from '../../../../../utilities/Icon';

interface CancelReadyForPaymentProps {
  expenseSheetStore: ExpenseSheetStore;
}

export const CancelReadyForPayment = ({ expenseSheetStore }: CancelReadyForPaymentProps) => {
  const [isLoading, setIsLoading] = React.useState(false);

  return (
    <Button
      color="danger"
      disabled={isLoading}
      onClick={() => {
        setIsLoading(true);
        expenseSheetStore.putState(ExpenseSheetState.open).catch(() => setIsLoading(false));
        // If the state update was successful, this button will be replaced with a new component.
        // Hence, we don't need to update the state again on success
      }}
    >
      <FontAwesomeIcon icon={DoubleAngleLeftIcon}/> Zurück auf Offen setzen
    </Button>
  );
};
