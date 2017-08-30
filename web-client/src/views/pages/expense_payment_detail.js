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

export default class ExpensePaymentDetail extends Component {
  constructor(props) {
    super(props);
    this.state = {
      payment: {
        sheets: [],
      },
    };
  }

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

  render() {
    var tableBody = [];
    var sheets = this.state.payment.sheets;

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
            <a href={'/expense/' + sheets[i].report_sheet}>{'CHF ' + this.formatRappen(sheets[i].amount / 100)}</a>
          </td>
        </tr>
      );
    }

    return (
      <Header>
        <div className="page page__expense">
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
                    <th>Betrag</th>
                  </tr>
                </thead>
                <tbody>{tableBody}</tbody>
              </table>

              <a
                href={
                  ApiService.BASE_URL +
                  'reportsheet/payments/xml/' +
                  this.state.payment.id +
                  '?jwttoken=' +
                  encodeURI(localStorage.getItem('jwtToken'))
                }
                class="btn btn-primary"
              >
                zahlung.xml erneut herunterladen
              </a>

              <br />
              <br />
            </div>
          </ScrollableCard>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
