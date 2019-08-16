import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import Button from 'reactstrap/lib/Button';
import { ExpenseSheetStore } from '../../stores/expenseSheetStore';
import { MainStore } from '../../stores/mainStore';
import { PaymentStore } from '../../stores/paymentStore';
import { ExpenseSheetState, PaymentEntry } from '../../types';
import { CheckSolidIcon, ExclamationSolidIcon, SquareRegularIcon, SyncSolidIcon } from '../../utilities/Icon';

interface Props {
  mainStore?: MainStore;
  paymentEntry: PaymentEntry;
  paymentStore?: PaymentStore;
  expenseSheetStore?: ExpenseSheetStore;
}

enum TransmissionState {
  invalid = 'invalid',
  loading = 'loading',
}

interface State {
  expenseSheetState: ExpenseSheetState | TransmissionState;
}

@inject('mainStore', 'paymentStore', 'expenseSheetStore')
@observer
export class ExpenseSheetConfirmer extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    this.state = {
      expenseSheetState: this.props.paymentEntry.expense_sheet.state,
    };
  }

  updateState(sheetId: number, state: ExpenseSheetState) {
    this.setState({ expenseSheetState: TransmissionState.loading });
    this.props
      .expenseSheetStore!.putState(state, sheetId)
      .then(() => this.setState({ expenseSheetState: state }))
      .catch(error => {
        this.props.mainStore!.displayError('Der Eintrag konnte nicht aktualisiert werden.');
        this.setState({ expenseSheetState: TransmissionState.invalid });
        throw error;
      });
  }

  render() {
    switch (this.state.expenseSheetState) {
      case TransmissionState.invalid:
        return (
          <>
            <Button
              onClick={() => this.updateState(this.props.paymentEntry.expense_sheet.id!, ExpenseSheetState.paid)}
              color={'link'}
              style={{ margin: 0, padding: 0 }}
            >
              <FontAwesomeIcon icon={SquareRegularIcon} />
            </Button>{' '}
            <FontAwesomeIcon icon={ExclamationSolidIcon} title={'Fehler bei der Übertragung.'} />
          </>
        );
      case TransmissionState.loading:
        return <FontAwesomeIcon spin icon={SyncSolidIcon} />;
      case ExpenseSheetState.ready_for_payment:
        return (
          <Button
            onClick={() => this.updateState(this.props.paymentEntry.expense_sheet.id!, ExpenseSheetState.paid)}
            color={'link'}
            style={{ margin: 0, padding: 0 }}
          >
            <FontAwesomeIcon icon={SquareRegularIcon} />
          </Button>
        );
      case ExpenseSheetState.paid:
        return <FontAwesomeIcon icon={CheckSolidIcon} />;
      default:
        return <FontAwesomeIcon icon={ExclamationSolidIcon} title={'Ungültiger Zustand'} />;
    }
  }
}
