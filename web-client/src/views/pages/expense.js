import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';

export default class MissionOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {
      report_sheets: [],
    };
  }

  componentDidMount() {
    this.getReportSheets('reportsheet');
  }

  getReportSheets(url) {
    let self = this;
    axios
      .get(ApiService.BASE_URL + url, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(function(response) {
        self.setState({
          report_sheets: response.data,
        });
      })
      .catch(function(error) {
        console.log(error);
      });
  }

  render() {
    var tableBody = [];
    var sheets = this.state.report_sheets;

    var even = true;
    for (let i = 0; i < sheets.length; i++) {
      tableBody.push(
        <tr class="teven">
          <td>&nbsp;</td>
          <td class="center">{sheets[i].zdp}</td>
          <td>
            <a href={'/profile/' + sheets[i].userid}>
              {sheets[i].first_name} {sheets[i].last_name}
            </a>
          </td>
          <td class="center">{sheets[i].start}</td>
          <td class="center">{sheets[i].end}</td>
          <td>
            <a href={'/expense/' + sheets[i].id}>Spesen bearbeiten</a>
          </td>
          <td>{sheets[i].done ? <img border="0" src="images/ok.png" /> : ''}</td>
        </tr>
      );
      even = !even;
    }

    return (
      <div className="page page__expense">
        <Card>
          <h1>Spesen</h1>

          <button>Spesenstatistiken</button>
          <br />
          <button>Übersicht </button>
          <button>Übersicht </button>

          <h2>Meldeblätter-Liste</h2>
          <button onClick={() => this.getReportSheets('reportsheet')}>Alle Meldeblätter anzeigen</button>
          <button onClick={() => this.getReportSheets('reportsheet/pending')}>Pendente Meldeblätter anzeigen</button>
          <button onClick={() => this.getReportSheets('reportsheet/current')}>Aktuelle Meldeblätter anzeigen</button>

          <table border="0" cellspacing="0" cellpadding="2" class="table">
            <tr class="theader">
              <td>&nbsp;</td>
              <td>ZDP</td>
              <td>Name</td>
              <td>Von</td>
              <td>Bis</td>
              <td />
              <td />
            </tr>
            <tr class="theader">
              <td>&nbsp;</td>
              <td>
                <input type="text" size="5" name="FILTER_ZDP" value="" />
              </td>
              <td>
                <input type="text" size="40" name="FILTER_NAME" value="" />
              </td>
              <td>
                <input type="text" size="15" name="FILTER_VON" value="" />
              </td>
              <td>
                <input type="text" size="15" name="FILTER_BIS" value="" />
              </td>
              <td />
              <td />
            </tr>

            {tableBody}
          </table>
        </Card>
      </div>
    );
  }
}
