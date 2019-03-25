import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { RouteComponentProps, withRouter } from 'react-router';
import Button from 'reactstrap/lib/Button';
import IziviContent from '../../layout/IziviContent';
import { OverviewTable } from '../../layout/OverviewTable';
import { MainStore } from '../../stores/mainStore';
import { PaymentStore } from '../../stores/paymentStore';
import { Column, PaymentEntry } from '../../types';
import { ReportSheetConfirmer } from './ReportSheetConfirmer';

interface PaymentDetailRouterProps {
  id?: string;
}

interface Props extends RouteComponentProps<PaymentDetailRouterProps> {
  mainStore?: MainStore;
  paymentStore?: PaymentStore;
}

interface State {
  loading: boolean;
}

@inject('mainStore', 'paymentStore')
@observer
class PaymentDetailInner extends React.Component<Props, State> {
  columns: Array<Column<PaymentEntry>>;

  constructor(props: Props) {
    super(props);
    props.paymentStore!.fetchOne(Number(props.match.params.id)).then(() => this.setState({ loading: false }));

    this.columns = [
      {
        id: 'zdp',
        label: 'ZDP',
        format: (p: PaymentEntry) => p.user.zdp,
      },
      {
        id: 'full_name',
        label: 'Name',
        format: (p: PaymentEntry) => `${p.user.first_name} ${p.user.last_name}`,
      },
      {
        id: 'iban',
        label: 'IBAN',
        format: (p: PaymentEntry) => p.user.bank_iban,
      },
      {
        id: 'total_costs',
        label: 'Betrag',
        format: (p: PaymentEntry) => this.props.mainStore!.formatCurrency(p.report_sheet.total_costs),
      },
    ];

    this.state = {
      loading: true,
    };
  }

  render() {
    const payment = this.props.paymentStore!.payment;
    const title = payment
      ? `Auszahlung vom ${this.props.mainStore!.formatDate(payment.created_at)}`
      : `Details zur Auszahlung ${this.props.match.params.id}`;

    return (
      <IziviContent card loading={this.state.loading} title={title}>
        {payment && (
          <>
            <Button color={'primary'} href={this.props.mainStore!.apiURL('payments/' + payment!.id + '/xml')} tag={'a'} target={'_blank'}>
              Zahlung.xml erneut herunterladen
            </Button>{' '}
            <br /> <br />
            <OverviewTable
              columns={this.columns}
              data={this.props.paymentStore!.payment!.payment_entries}
              renderActions={(p: PaymentEntry) => <ReportSheetConfirmer paymentEntry={p} />}
            />
          </>
        )}
      </IziviContent>
    );
  }
}

export const PaymentDetail = withRouter(PaymentDetailInner);
