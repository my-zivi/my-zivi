import React, { Component } from 'react';
import ScrollableCard from '../tags/scrollableCard';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import moment from 'moment-timezone';
import { Glyphicon } from '../tags/Glyphicon';
import update from 'immutability-helper';
import { api, apiURL } from '../../utils/api';
import Toast from '../../utils/toast';

export default class ExpensePaymentDetail extends Component {
  constructor(props) {
    super(props);
    this.state = {
      payment: {
        sheets: [],
      },
    };
  }

  Confirmer = sheet => {
    const confirmCheckbox = (
      <Glyphicon style={{ cursor: 'pointer' }} name="unchecked" onClick={() => this.updateState(sheet.report_sheet, 3)} />
    );
    switch (sheet.state) {
      case -2:
        return (
          <div>
            {confirmCheckbox}
            <Glyphicon name="alert" title="Fehler" />;
          </div>
        );
      case -1:
        return <Glyphicon name="refresh" spin />;
      case 2:
        return confirmCheckbox;
      case 3:
        return <Glyphicon name="ok" />;
      default:
        return <Glyphicon name="alert" title="Ungültiger Status" />;
    }
  };

  setSheetState(sheetId, state) {
    const sheetIndex = this.state.payment.sheets.map(sheet => sheet.report_sheet).indexOf(sheetId);
    this.setState(
      update(this.state, {
        payment: {
          sheets: {
            [sheetIndex]: {
              state: { $set: state },
            },
          },
        },
      })
    );
  }

  updateState(sheetId, state) {
    this.setSheetState(sheetId, -1);
    api()
      .put(`reportsheet/${sheetId}/state`, { state })
      .then(response => {
        this.setSheetState(sheetId, state);
      })
      .catch(error => {
        Toast.showError('Bestätigen fehlgeschlagen', 'Ein Fehler ist aufgetreten', error, path => this.props.history.push(path));
        this.setSheetState(sheetId, -2);
      });
  }

  componentDidMount() {
    this.getReportSheets();
  }

  getReportSheets() {
    this.setState({ loading: true, error: null });
    api()
      .get('reportsheet/payments/' + this.props.match.params.payment_id)
      .then(response => {
        this.setState({
          payment: response.data,
          loading: false,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  formatRappen(amount) {
    return parseFloat(Math.round(amount * 100) / 100).toFixed(2);
  }

  total(sheets) {
    const amount = sheets.reduce((sum, sheet) => sum + sheet.amount, 0);
    return 'CHF ' + this.formatRappen(amount / 100);
  }

  render() {
    const sheets = this.state.payment.sheets;

    return (
      <Header>
        <div className="page page__expense_payment_detail">
          <ScrollableCard>
            <h2>
              Auszahlung vom{' '}
              {moment
                .tz(this.state.payment.created_at, 'UTC')
                .tz('Europe/Zurich')
                .format('DD.MM.YYYY H:mm')}
            </h2>
            <div>
              <table className="table table-hover">
                <thead>
                  <tr>
                    <th>ZDP</th>
                    <th>Name</th>
                    <th>IBAN</th>
                    <th className="amount">Betrag</th>
                    <th className="hide-print">Bestätigen</th>
                  </tr>
                </thead>
                <tbody>
                  {sheets.map(sheet => (
                    <tr key={sheet.report_sheet}>
                      <td>{sheet.zdp}</td>
                      <td>
                        <a href={'/profile/' + sheet.userid}>
                          {sheet.first_name} {sheet.last_name}
                        </a>
                      </td>
                      <td>{sheet.iban}</td>
                      <td className="amount">
                        <a href={'/expense/' + sheet.report_sheet}>{'CHF ' + this.formatRappen(sheet.amount / 100)}</a>
                      </td>
                      <td className="hide-print">{this.Confirmer(sheet)}</td>
                    </tr>
                  ))}
                  <tr className="total">
                    <td colSpan="4">{this.total(sheets)}</td>
                  </tr>
                </tbody>
              </table>

              <a href={apiURL('reportsheet/payments/xml/' + this.state.payment.id, {}, true)} className="btn btn-primary hide-print">
                zahlung.xml erneut herunterladen
              </a>
            </div>
          </ScrollableCard>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
