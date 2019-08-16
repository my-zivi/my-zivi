import * as React from 'react';
import { MainStore } from '../../../stores/mainStore';
import { ExpenseSheetListing } from '../../../types';

function addressIsValid(user: { address: string, city: string, zip: number }) {
  return user.address !== '' && user.city !== '' && user.zip && user.zip > 0;
}

export const ExpenseSheetPaymentWarnings = (props: { expenseSheet: ExpenseSheetListing }) => {
  if ('user' in props.expenseSheet) {
    return (
      <>
        {!addressIsValid(props.expenseSheet.user) && <div className="text-danger">Adresse unvollständig!</div>}
        {!MainStore.validateIBAN(props.expenseSheet.user.bank_iban) && <div className="text-danger">IBAN ist ungültig!</div>}
      </>
    );
  } else {
    return <></>;
  }
};
