// tslint:disable-next-line:no-any
import { ExpenseSheetState, PaymentState, User } from '../types';

export const empty = (value: any) => {
  if (!value) {
    return true;
  }
  return value.length === 0;
};

export const translateUserRole = (user: User) => {
  switch (user.role) {
    case 'admin':
      return 'Admin';
    case 'civil_servant':
      return 'Zivi';
  }
};

export const stateTranslation = (state: ExpenseSheetState | PaymentState) => {
  switch (state) {
    case ExpenseSheetState.open:
      return 'Offen';
    case ExpenseSheetState.ready_for_payment:
      return 'Bereit für Zahlung';
    case ExpenseSheetState.payment_in_progress:
    case PaymentState.payment_in_progress:
      return 'Zahlung in bearbeitung';
    case ExpenseSheetState.paid:
    case PaymentState.paid:
      return 'Bezahlt';
  }
};

// tslint:disable-next-line:no-empty
export const noop = () => {};

export { default as buildURL } from 'axios/lib/helpers/buildURL';
