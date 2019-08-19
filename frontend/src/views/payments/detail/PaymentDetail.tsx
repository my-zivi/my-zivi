import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import injectSheet from 'react-jss';
import { WithSheet } from 'react-jss/lib/injectSheet';
import { RouteComponentProps, withRouter } from 'react-router';
import { Link } from 'react-router-dom';
import Badge from 'reactstrap/lib/Badge';
import Button from 'reactstrap/lib/Button';
import ButtonGroup from 'reactstrap/lib/ButtonGroup';
import IziviContent from '../../../layout/IziviContent';
import { OverviewTable } from '../../../layout/OverviewTable';
import { MainStore } from '../../../stores/mainStore';
import { PaymentStore } from '../../../stores/paymentStore';
import { Payment, PaymentExpenseSheet, PaymentState } from '../../../types';
import { Formatter } from '../../../utilities/formatter';
import { stateTranslation } from '../../../utilities/helpers';
import { CheckSolidIcon, DownloadIcon, ExclamationSolidIcon } from '../../../utilities/Icon';
import { paymentDetailStyles } from './paymentDetailStyles';

interface PaymentDetailRouterProps {
  timestamp?: string;
}

interface Props extends RouteComponentProps<PaymentDetailRouterProps> {
  mainStore?: MainStore;
  paymentStore?: PaymentStore;
}

interface State {
  loading: boolean;
  canceled: boolean;
}

const COLUMNS = [
  {
    id: 'zdp',
    label: 'ZDP',
    format: ({ user: { zdp } }: PaymentExpenseSheet) => zdp,
  },
  {
    id: 'full_name',
    label: 'Name',
    format: (expenseSheet: PaymentExpenseSheet) => (
      <Link to={'/users/' + expenseSheet.user.id}>{expenseSheet.user.full_name}</Link>
    ),
  },
  {
    id: 'iban',
    label: 'IBAN',
    format: ({ user: { bank_iban } }: PaymentExpenseSheet) => bank_iban,
  },
  {
    id: 'total',
    label: 'Betrag',
    format: (expenseSheet: PaymentExpenseSheet) => new Formatter().formatCurrency(expenseSheet.total),
  },
];

@inject('mainStore', 'paymentStore')
@observer
class PaymentDetailInner extends React.Component<Props & WithSheet<typeof paymentDetailStyles>, State> {
  constructor(props: Props & WithSheet<typeof paymentDetailStyles>) {
    super(props);
    props.paymentStore!.fetchOne(Number(props.match.params.timestamp)).then(() => this.setState({ loading: false }));

    this.state = {
      loading: true,
      canceled: false,
    };
  }

  actionButton() {
    const payment = this.props.paymentStore!.payment!;

    if (payment.state === PaymentState.payment_in_progress) {
      return (
        <ButtonGroup>
          <Button disabled={this.state.canceled} color="success" onClick={this.confirmButtonClicked} className="mb-4" target="_blank">
            <FontAwesomeIcon className="mr-1" icon={CheckSolidIcon}/> Zahlung bestätigen
          </Button>
          <Button color="danger" disabled={this.state.canceled} onClick={this.cancelButtonClicked} className="mb-4" target="_blank">
            <FontAwesomeIcon className="mr-1" icon={ExclamationSolidIcon}/> Zahlung abbrechen
          </Button>
        </ButtonGroup>
      );
    } else {
      return <></>;
    }
  }

  render() {
    const payment = this.props.paymentStore!.payment;
    return (
      <IziviContent card loading={this.state.loading}>
        {this.state.canceled && <div className={this.props.classes.cancelBadge}>Abgebrochen</div>}
        <div className={this.state.canceled ? this.props.classes.canceledDetailCard : undefined}>
          <Badge pill className="mb-2">{payment ? stateTranslation(payment!.state) : ''}</Badge>
          <h1 className="mb-4">{this.getTitle(payment)}</h1>
          {payment && (
            <>
              {payment.state === PaymentState.payment_in_progress && !this.state.canceled && (
                <Button color="primary" href={this.getPainURL(payment!)} tag="a" className="mb-4" target="_blank">
                  <FontAwesomeIcon className="mr-1" icon={DownloadIcon}/> Zahlungsdatei herunterladen
                </Button>
              )}
              <div className="float-right">{this.actionButton()}</div>
              <OverviewTable
                columns={COLUMNS}
                data={this.props.paymentStore!.payment!.expense_sheets}
                renderActions={(expenseSheet: PaymentExpenseSheet) => <Link to={`/expense_sheets/${expenseSheet.id!}`}>Spesenblatt</Link>}
              />
            </>
          )}
        </div>
      </IziviContent>
    );
  }

  private cancelButtonClicked = () => {
    return this.props.paymentStore!.cancelPayment().then(() => this.setState({ canceled: true }));
  }

  private confirmButtonClicked = () => {
    return this.props.paymentStore!.confirmPayment();
  }

  private getTitle(payment?: Payment) {
    return payment
      ? `Auszahlung vom ${this.props.mainStore!.formatDate(PaymentStore.convertPaymentTimestamp(payment.payment_timestamp))}`
      : `Details zur Auszahlung ${this.props.match.params.timestamp}`;
  }

  private getPainURL({ payment_timestamp }: Payment) {
    return this.props.mainStore!.apiURL(`payments/${payment_timestamp}.xml`);
  }
}

export const PaymentDetail = injectSheet(paymentDetailStyles)(withRouter(PaymentDetailInner));
