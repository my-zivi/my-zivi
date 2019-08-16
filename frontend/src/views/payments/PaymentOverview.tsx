import * as React from 'react';
import { ExpenseSheetStore } from '../../stores/expenseSheetStore';
import { MainStore } from '../../stores/mainStore';
import { PaymentStore } from '../../stores/paymentStore';

interface Props {
  mainStore?: MainStore;
  paymentStore?: PaymentStore;
  expenseSheetStore?: ExpenseSheetStore;
}

interface State {
  loading: boolean;
}

// TODO Implement this and load user from store
// @inject('mainStore', 'paymentStore', 'expenseSheetStore')
// @observer
export class PaymentOverview extends React.Component<Props, State> {
  render() {
    return <></>;
  }

  // paymentColumns: Array<Column<Payment>>;
  // expenseSheetColumns: Array<Column<ExpenseSheet>>;
  //
  // constructor(props: Props) {
  //   super(props);
  //
  //   this.paymentColumns = [
  //     {
  //       id: 'created_at',
  //       label: 'Datum',
  //       format: (p: Payment) => this.props.mainStore!.formatDate(p.created_at),
  //     },
  //     {
  //       id: 'amount',
  //       label: 'Betrag',
  //       format: (p: Payment) => this.props.mainStore!.formatCurrency(p.amount),
  //     },
  //   ];
  //
  //   this.expenseSheetColumns = [
  //     {
  //       id: 'zdp',
  //       label: 'ZDP',
  //       format: (r: ExpenseSheet) => (r.user ? r.user.zdp : ''),
  //     },
  //     {
  //       id: 'full_name',
  //       label: 'Name',
  //       format: (r: ExpenseSheet) => (r.user ? `${r.user.first_name} ${r.user.last_name}` : ''),
  //     },
  //     {
  //       id: 'iban',
  //       label: 'IBAN',
  //       format: (r: ExpenseSheet) => (r.user ? r.user.bank_iban : ''),
  //     },
  //     {
  //       id: 'total',
  //       label: 'Betrag',
  //       format: (r: ExpenseSheet) => this.props.mainStore!.formatCurrency(r.total),
  //     },
  //     {
  //       id: 'notices',
  //       label: 'Bemerkungen',
  //       format: (r: ExpenseSheet) => (
  //         <>
  //           {r.user && (r.user.address === '' || r.user.city === '' || !r.user.zip) && (
  //             <>
  //               <p>Adresse unvollständig!</p>
  //               <br />
  //             </>
  //           )}
  //           {!this.props.mainStore!.validateIBAN(r.user ? r.user.bank_iban : '') && (
  //             <>
  //               <p>IBAN hat ein ungültiges Format!</p>
  //               <br />
  //             </>
  //           )}
  //         </>
  //       ),
  //     },
  //   ];
  //
  //   this.state = {
  //     loading: true,
  //   };
  // }
  //
  // componentDidMount(): void {
  //   Promise.all([this.props.paymentStore!.fetchAll(), this.props.expenseSheetStore!.fetchToBePaidAll()]).then(() => {
  //     this.setState({ loading: false });
  //   });
  // }
  //
  // render() {
  //   return (
  //     <IziviContent card loading={this.state.loading} title={'Auszahlungen'}>
  //       {this.props.expenseSheetStore!.toBePaidExpenseSheets.length > 0 ? (
  //         <>
  //           <OverviewTable
  //             columns={this.expenseSheetColumns}
  //             data={this.props.expenseSheetStore!.toBePaidExpenseSheets}
  //             renderActions={(r: ExpenseSheet) => <Link to={'/expense_sheets/' + r.id}>Spesenblatt</Link>}
  //           />
  //           <Button
  //             color={'primary'}
  //             href={this.props.mainStore!.apiURL('payments/execute')}
  //             tag={'a'}
  //             target={'_blank'}
  //           >
  //             Zahlungsdatei generieren
  //           </Button>
  //         </>
  //       ) : (
  //         'Keine Spesen zur Auszahlung bereit.'
  //       )}
  //       <br />
  //       <br />
  //       <h1>Archiv</h1> <br />
  //       <OverviewTable
  //         columns={this.paymentColumns}
  //         data={this.props.paymentStore!.payments}
  //         renderActions={(p: Payment) => (
  //           <>
  //             <Link to={'/payments/' + p.id}>Details</Link>
  //           </>
  //         )}
  //       />
  //     </IziviContent>
  //   );
  // }
}
