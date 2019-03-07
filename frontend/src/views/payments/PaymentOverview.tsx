import * as React from 'react';
import IziviContent from '../../layout/IziviContent';
import { PaymentStore } from '../../stores/paymentStore';
import { inject, observer } from 'mobx-react';
import { Column, Payment, ReportSheet } from '../../types';
import { MainStore } from '../../stores/mainStore';
import { OverviewTable } from '../../layout/OverviewTable';
import { ReportSheetStore } from '../../stores/reportSheetStore';
import Button from 'reactstrap/lib/Button';
import { Link } from 'react-router-dom';

interface Props {
  mainStore?: MainStore;
  paymentStore?: PaymentStore;
  reportSheetStore?: ReportSheetStore;
}

interface State {
  loading: boolean;
}

@inject('mainStore', 'paymentStore', 'reportSheetStore')
@observer
export class PaymentOverview extends React.Component<Props, State> {
  public paymentColumns: Array<Column<Payment>>;
  public reportSheetColumns: Array<Column<ReportSheet>>;

  constructor(props: Props) {
    super(props);

    this.paymentColumns = [
      {
        id: 'created_at',
        label: 'Datum',
        format: (p: Payment) => this.props.mainStore!.formatDate(p.created_at),
      },
      {
        id: 'amount',
        label: 'Betrag',
        format: (p: Payment) => this.props.mainStore!.formatCurrency(p.amount),
      },
    ];

    this.reportSheetColumns = [
      {
        id: 'zdp',
        label: 'ZDP',
        format: (r: ReportSheet) => (r.user ? r.user.zdp : ''),
      },
      {
        id: 'full_name',
        label: 'Name',
        format: (r: ReportSheet) => (r.user ? `${r.user.first_name} ${r.user.last_name}` : ''),
      },
      {
        id: 'iban',
        label: 'IBAN',
        format: (r: ReportSheet) => (r.user ? r.user.bank_iban : ''),
      },
      {
        id: 'total_costs',
        label: 'Betrag',
        format: (r: ReportSheet) => this.props.mainStore!.formatCurrency(r.total_costs),
      },
      {
        id: 'notices',
        label: 'Bemerkungen',
        format: (r: ReportSheet) => (
          <>
            {r.user && (r.user.address === '' || r.user.city === '' || !r.user.zip) && (
              <>
                <p>Adresse unvollständig!</p>
                <br />
              </>
            )}
            {!this.props.mainStore!.validateIBAN(r.user ? r.user.bank_iban : '') && (
              <>
                <p>IBAN hat ein ungültiges Format!</p>
                <br />
              </>
            )}
          </>
        ),
      },
    ];

    this.state = {
      loading: true,
    };
  }

  public componentDidMount(): void {
    Promise.all([this.props.paymentStore!.fetchAll(), this.props.reportSheetStore!.fetchToBePaidAll()]).then(() => {
      this.setState({ loading: false });
    });
  }

  public render() {
    return (
      <IziviContent card loading={this.state.loading} title={'Auszahlungen'}>
        {this.props.reportSheetStore!.toBePaidReportSheets.length > 0 ? (
          <>
            <OverviewTable
              columns={this.reportSheetColumns}
              data={this.props.reportSheetStore!.toBePaidReportSheets}
              renderActions={(r: ReportSheet) => <Link to={'/report_sheets/' + r.id}>Spesenblatt</Link>}
            />
            <Button color={'primary'}>Zahlungsdatei generieren (TODO)</Button>
          </>
        ) : (
          'Keine Spesen zur Auszahlung bereit.'
        )}
        <br />
        <br />
        <h1>Archiv</h1> <br />
        <OverviewTable
          columns={this.paymentColumns}
          data={this.props.paymentStore!.payments}
          renderActions={(p: Payment) => (
            <>
              <Link to={'/payments/' + p.id}>Details</Link>
            </>
          )}
        />
      </IziviContent>
    );
  }
}
