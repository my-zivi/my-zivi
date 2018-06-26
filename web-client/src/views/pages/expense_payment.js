import { Component } from 'inferno';
import ScrollableCard from '../tags/scrollableCard';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import moment from 'moment-timezone';
import { api } from '../../utils/api';

export default class ExpensePayment extends Component {
  constructor(props) {
    super(props);
    this.state = {
      report_sheets: {
        valid: [],
        invalid: [],
        archive: [],
      },
    };
  }

  componentDidMount() {
    this.getReportSheets();
  }

  getReportSheets() {
    this.setState({ loading: true, error: null });
    api()
      .get('reportsheet/payments')
      .then(response => {
        this.setState({
          report_sheets: response.data,
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

  async generateReportsheet() {
    try {
      let response = await api().post('reportsheet/payments/execute', {
        data: this.state.report_sheets.valid,
      });

      let { xml, filename } = response.data;

      ExpensePayment.downloadXmlFile(xml, filename);
      this.getReportSheets();
    } catch (error) {
      this.setState({ error });
    }
  }

  static downloadXmlFile(xml, filename) {
    let a = document.createElement('a');
    let objectURL = URL.createObjectURL(new Blob([xml], { type: 'application/xml' }));
    a.href = objectURL;
    a.download = filename;

    document.body.appendChild(a);
    a.click();

    document.body.removeChild(a);
    URL.revokeObjectURL(objectURL);
  }

  render() {
    var tableBody = [];
    var sheets = this.state.report_sheets.valid;

    for (let i = 0; i < sheets.length; i++) {
      tableBody.push(
        <tr>
          <td>{sheets[i].zdp}</td>
          <td>
            <a href={'/profile/' + sheets[i].userid}>
              {sheets[i].first_name} {sheets[i].last_name}
            </a>
          </td>
          <td>{sheets[i].iban}</td>
          <td>
            <a href={'/expense/' + sheets[i].sheet_id}>{'CHF ' + this.formatRappen(sheets[i].amount)}</a>
          </td>
        </tr>
      );
    }

    var tableBodyInvalid = [];
    sheets = this.state.report_sheets.invalid;

    for (let i = 0; i < sheets.length; i++) {
      tableBodyInvalid.push(
        <tr>
          <td>{sheets[i].zdp}</td>
          <td>
            <a href={'/profile/' + sheets[i].userid}>
              {sheets[i].first_name} {sheets[i].last_name}
            </a>
          </td>
          <td>{sheets[i].iban}</td>
          <td>
            <a href={'/expense/' + sheets[i].sheet_id}>{'CHF ' + this.formatRappen(sheets[i].amount)}</a>
          </td>
          <td>{sheets[i].reason}</td>
        </tr>
      );
    }

    var tableBodyArchive = [];
    var payments = this.state.report_sheets.archive;
    for (let i = payments.length - 1; i >= 0; i--) {
      tableBodyArchive.push(
        <tr>
          <td>
            {moment
              .tz(payments[i].created_at, 'UTC')
              .tz('Europe/Zurich')
              .format('DD.MM.YYYY H:mm')}
          </td>
          <td>CHF {this.formatRappen(payments[i].amount / 100)}</td>
          <td>
            <a href={'/expensePayment/' + payments[i].id}>Details</a>
          </td>
        </tr>
      );
    }

    return (
      <Header>
        <div className="page page__expense">
          <ScrollableCard>
            <h2>Auszahlungen</h2>
            {this.state.report_sheets.valid.length > 0 && (
              <div>
                <table class="table table-hover">
                  <thead>
                    <tr>
                      <th>ZDP</th>
                      <th>Name</th>
                      <th>IBAN</th>
                      <th>Betrag</th>
                    </tr>
                  </thead>
                  <tbody>{tableBody}</tbody>
                </table>

                <button className="btn btn-primary" onClick={() => this.generateReportsheet()}>
                  Zahlungsdatei generieren
                </button>
                <br />
                <br />
              </div>
            )}

            {this.state.report_sheets.valid.length === 0 && (
              <div>
                Keine pendenten Zahlungen
                <br />
                <br />
              </div>
            )}

            {sheets.length > 0 && (
              <div>
                <h2>Ungültige Auszahlungen</h2>
                <table class="table table-hover">
                  <thead>
                    <tr>
                      <th>ZDP</th>
                      <th>Name</th>
                      <th>IBAN</th>
                      <th>Betrag</th>
                      <th>Problem</th>
                    </tr>
                  </thead>
                  <tbody>{tableBodyInvalid}</tbody>
                </table>
                <br />
                <br />
              </div>
            )}

            <div>
              <h2>Archiv</h2>
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th>Datum</th>
                    <th>Betrag</th>
                    <th>Details</th>
                  </tr>
                </thead>
                <tbody>{tableBodyArchive}</tbody>
              </table>
            </div>
          </ScrollableCard>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
