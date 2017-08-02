import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

export default class MissionOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {
      report_sheets: [],
      zdp: '',
      name: '',
      start: '',
      end: '',
    };
  }

  componentDidMount() {
    this.getReportSheets('reportsheet');
  }

  getReportSheets(url) {
    this.setState({
      zdp: '',
      name: '',
      start: '',
      end: '',
      loading: true,
      error: null,
    });
    axios
      .get(ApiService.BASE_URL + url, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
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

  handleChange(e) {
    switch (e.target.name) {
      case 'zdp':
        this.setState({ zdp: e.target.value });
        break;
      case 'name':
        this.setState({ name: e.target.value });
        break;
      case 'start':
        this.setState({ start: e.target.value });
        break;
      case 'end':
        this.setState({ end: e.target.value });
        break;
      case 'group':
        this.setState({ group: e.target.value });
        break;
      default:
        console.log('Element not found for setting.');
    }
  }

  render() {
    var tableBody = [];
    var sheets = this.state.report_sheets;

    var even = true;
    for (let i = 0; i < sheets.length; i++) {
      if (this.state.zdp != '' && !sheets[i].zdp.startsWith(this.state.zdp)) {
        continue;
      }
      if (
        this.state.name != '' &&
        (sheets[i].first_name + ' ' + sheets[i].last_name).toLowerCase().indexOf(this.state.name.toLowerCase()) == -1
      ) {
        continue;
      }
      if (this.state.start != '' && sheets[i].end < this.state.start) {
        continue;
      }
      if (this.state.end != '' && sheets[i].start > this.state.end) {
        continue;
      }

      tableBody.push(
        <tr>
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
      <Header>
        <div className="page page__expense">
          <Card>
            <h1>Spesen</h1>

            <button class="btn btn-primary">Spesenstatistiken</button>
            <br />
            <button class="btn btn-primary">Übersicht </button>
            <button class="btn btn-primary">Übersicht </button>

            <h2>Meldeblätter-Liste</h2>
            <button class="btn btn-primary" onClick={() => this.getReportSheets('reportsheet')}>
              Alle Meldeblätter anzeigen
            </button>
            <button class="btn btn-primary" onClick={() => this.getReportSheets('reportsheet/pending')}>
              Pendente Meldeblätter anzeigen
            </button>
            <button class="btn btn-primary" onClick={() => this.getReportSheets('reportsheet/current')}>
              Aktuelle Meldeblätter anzeigen
            </button>

            <table class="table table-hover">
              <thead>
                <tr>
                  <th>&nbsp;</th>
                  <th>ZDP</th>
                  <th>Name</th>
                  <th>Von</th>
                  <th>Bis</th>
                  <th />
                  <th />
                </tr>
                <tr class="theader">
                  <td>&nbsp;</td>
                  <td>
                    <input class="SWOInput" name="zdp" size="5" type="text" value={this.state.zdp} oninput={this.handleChange.bind(this)} />
                  </td>
                  <td>
                    <input
                      class="SWOInput"
                      name="name"
                      size="15"
                      type="text"
                      value={this.state.name}
                      oninput={this.handleChange.bind(this)}
                    />
                  </td>
                  <td>
                    <input
                      class="SWOInput"
                      name="start"
                      size="10"
                      type="date"
                      value={this.state.start}
                      oninput={this.handleChange.bind(this)}
                    />
                  </td>
                  <td>
                    <input
                      class="SWOInput"
                      name="end"
                      size="10"
                      type="date"
                      value={this.state.end}
                      oninput={this.handleChange.bind(this)}
                    />
                  </td>
                  <td />
                  <td />
                </tr>
              </thead>
              <tbody>{tableBody}</tbody>
            </table>
          </Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
