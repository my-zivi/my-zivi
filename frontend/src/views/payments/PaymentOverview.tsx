import { inject, observer } from 'mobx-react';
import * as React from 'react';
import IziviContent from '../../layout/IziviContent';
import { ExpenseSheetStore } from '../../stores/expenseSheetStore';
import { MainStore } from '../../stores/mainStore';
import { PaymentStore } from '../../stores/paymentStore';
import { ExpenseSheetsReadyForPaymentTable } from './tables/ExpenseSheetsReadyForPaymentTable';
import { PaymentsTable } from './tables/PaymentsTable';

interface Props {
  mainStore?: MainStore;
  paymentStore?: PaymentStore;
  expenseSheetStore?: ExpenseSheetStore;
}

interface State {
  loading: boolean;
}

@inject('mainStore', 'paymentStore', 'expenseSheetStore')
@observer
export class PaymentOverview extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    this.state = {
      loading: true,
    };
  }

  componentDidMount(): void {
    Promise.all([this.props.paymentStore!.fetchAll(), this.props.expenseSheetStore!.fetchToBePaidAll()]).then(() => {
      this.setState({ loading: false });
    });
  }

  render() {
    return (
      <IziviContent card loading={this.state.loading}>
        <h1 className="mb-4">Pendente Spesenblätter für Auszahlung</h1>
        <ExpenseSheetsReadyForPaymentTable
          toBePaidExpenseSheets={this.props.expenseSheetStore!.toBePaidExpenseSheets}
          paymentStore={this.props.paymentStore!}
          expenseSheetStore={this.props.expenseSheetStore!}
        />

        <h1 className="mb-4 mt-5">In Auszahlung</h1>
        <PaymentsTable payments={this.props.paymentStore!.paymentsInProgress} emptyNotice={'Keine Zahlung in Bearbeitung'}/>

        <h1 className="mb-4 mt-5">Archiv</h1>
        <PaymentsTable payments={this.props.paymentStore!.paidPayments} emptyNotice={'Keine getätigten Zahlungen'}/>
      </IziviContent>
    );
  }
}
