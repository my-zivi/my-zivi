import Inferno from 'inferno';
import { Link } from 'inferno-router';
import ScrollableCard from '../tags/scrollableCard';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/InputFields/DatePicker';
import moment from 'moment-timezone';
import { Glyphicon } from '../tags/Glyphicon';
import update from 'immutability-helper';

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
    switch (sheet.state) {
      case -1:
        return <Glyphicon name="refresh" spin />;
      case 2:
        return <Glyphicon style={{ cursor: 'pointer' }} name="unchecked" onClick={() => this.updateState(sheet.report_sheet, 3)} />;
      case 3:
        return <Glyphicon name="ok" />;
      default:
        return <Glyphicon name="alert" title="Ungültiger Status" />;
    }
  };

  setSheetState = (sheetId, state) =>
    this.setState(
      update(this.state, {
        payment: {
          sheets: {
            $set: this.state.payment.sheets.map(sheet => {
              if (sheet.report_sheet === sheetId) {
                return {
                  ...sheet,
                  state,
                };
              }
              return sheet;
            }),
          },
        },
      })
    );

  updateState = (sheetId, state) => {
    this.setSheetState(sheetId, -1);
    axios
      .put(
        `${ApiService.BASE_URL}reportsheet/${sheetId}/state`,
        { state },
        { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } }
      )
      .then(response => {
        this.setSheetState(sheetId, state);
        console.log('woo');
      })
      .catch(error => {
        //this.setState({error: error});
        console.log('ow');
      });
  };

  componentDidMount() {
    this.getReportSheets();
    DatePicker.initializeDatePicker();
  }

  getReportSheets() {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'reportsheet/payments/' + this.props.params.payment_id, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
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
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th>ZDP</th>
                    <th>Name</th>
                    <th>IBAN</th>
                    <th class="amount">Betrag</th>
                    <th class="hide-print">Bestätigen</th>
                  </tr>
                </thead>
                <tbody>
                  {sheets.map(sheet => (
                    <tr>
                      <td>{sheet.zdp}</td>
                      <td>
                        <a href={'/profile/' + sheet.userid}>
                          {sheet.first_name} {sheet.last_name}
                        </a>
                      </td>
                      <td>{sheet.iban}</td>
                      <td class="amount">
                        <a href={'/expense/' + sheet.report_sheet}>{'CHF ' + this.formatRappen(sheet.amount / 100)}</a>
                      </td>
                      <td class="hide-print">{this.Confirmer(sheet)}</td>
                    </tr>
                  ))}
                  <tr class="total">
                    <td colspan="4">{this.total(sheets)}</td>
                  </tr>
                </tbody>
              </table>

              <a
                href={
                  ApiService.BASE_URL +
                  'reportsheet/payments/xml/' +
                  this.state.payment.id +
                  '?jwttoken=' +
                  encodeURI(localStorage.getItem('jwtToken'))
                }
                class="btn btn-primary hide-print"
              >
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
