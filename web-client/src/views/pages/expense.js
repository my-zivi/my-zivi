import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/DatePicker';

export default class MissionOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {
      report_sheets: [],
      zdp: '',
      name: '',
      start: '',
      end: '',

      time_type: 0,
      time_year: new Date().getFullYear(),
      showOnlyDoneSheets: 1,
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
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.state[e.target.name] = value;
    this.setState(this.state);
  }

  showStatsExtended(showDetails) {
    this.showStats(
      this.state.time_type,
      showDetails,
      this.state.showOnlyDoneSheets,
      this.state.time_year,
      this.state.time_from,
      this.state.time_to
    );
  }

  showStats(time_type, showDetails, showOnlyDoneSheets, time_year, time_from, time_to) {
    this.setState({ loading: true, error: null });
    axios
      .get(
        ApiService.BASE_URL +
          'pdf/statistik?time_type=' +
          time_type +
          '&showDetails=' +
          showDetails +
          '&showOnlyDoneSheets=' +
          showOnlyDoneSheets +
          '&time_year=' +
          time_year +
          '&time_from=' +
          time_from +
          '&time_to=' +
          time_to,
        {
          headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
          responseType: 'blob',
        }
      )
      .then(response => {
        this.setState({
          loading: false,
        });
        let blob = new Blob([response.data], { type: 'application/pdf' });
        window.location = window.URL.createObjectURL(blob);
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  monthNames = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

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
          <td>{sheets[i].done ? <span class="glyphicon glyphicon-ok" style="color:green" /> : ''}</td>
        </tr>
      );
      even = !even;
    }

    var prevMonthDate = new Date();
    prevMonthDate.setMonth(prevMonthDate.getMonth() - 1);
    var curMonthDate = new Date();

    var yearoptions = [];
    for (var i = 2005; i < curMonthDate.getFullYear() + 3; i++) {
      yearoptions.push(<option value={i}>{i}</option>);
    }

    return (
      <Header>
        <div className="page page__expense">
          <Card>
            <h1>Spesen</h1>

            <button class="btn btn-primary" onclick={() => this.showStats(3, 1)}>
              Übersicht {this.monthNames[prevMonthDate.getMonth()]}
            </button>
            <button class="btn btn-primary" onclick={() => this.showStats(2, 1)}>
              Übersicht {this.monthNames[curMonthDate.getMonth()]}
            </button>
            <button class="btn btn-primary" data-toggle="modal" data-target="#myModal">
              Erweitert
            </button>

            <div id="myModal" class="modal fade" role="dialog">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                      &times;
                    </button>
                    <h4 class="modal-title">Spesenstatistik erstellen</h4>
                  </div>
                  <div class="modal-body">
                    <label>
                      <input
                        type="radio"
                        name="time_type"
                        value="0"
                        defaultChecked="true"
                        onchange={e => {
                          this.handleChange(e);
                        }}
                      />{' '}
                      Jahr:&nbsp;
                    </label>
                    <select
                      name="time_year"
                      defaultValue={curMonthDate.getFullYear()}
                      onchange={e => {
                        this.handleChange(e);
                      }}
                    >
                      {yearoptions}
                    </select>
                    <br />

                    <label>
                      <input
                        type="radio"
                        name="time_type"
                        value="1"
                        onchange={e => {
                          this.handleChange(e);
                        }}
                      />{' '}
                      Periode:&nbsp;
                    </label>
                    <DatePicker
                      id="time_from"
                      label="Datum von"
                      value={new Date()}
                      callback={e => {
                        this.handleChange(e);
                      }}
                      callbackOrigin={this}
                    />
                    <DatePicker
                      id="time_to"
                      label="Datum zu"
                      value={new Date()}
                      callback={e => {
                        this.handleChange(e);
                      }}
                      callbackOrigin={this}
                    />
                    <div id="picker-container" />
                    <br />

                    <label>
                      <input
                        type="radio"
                        name="time_type"
                        value="2"
                        onchange={e => {
                          this.handleChange(e);
                        }}
                      />{' '}
                      {this.monthNames[curMonthDate.getMonth()]} {curMonthDate.getFullYear()}
                    </label>
                    <br />
                    <label>
                      <input
                        type="radio"
                        name="time_type"
                        value="3"
                        onchange={e => {
                          this.handleChange(e);
                        }}
                      />{' '}
                      {this.monthNames[prevMonthDate.getMonth()]} {prevMonthDate.getFullYear()}
                    </label>
                    <br />
                    <br />

                    <label>
                      <input
                        type="radio"
                        name="showOnlyDoneSheets"
                        value="1"
                        defaultChecked="true"
                        onchange={e => {
                          this.handleChange(e);
                        }}
                      />{' '}
                      Erledigte Meldeblätter
                    </label>
                    <br />
                    <label>
                      <input
                        type="radio"
                        name="showOnlyDoneSheets"
                        value="0"
                        onchange={e => {
                          this.handleChange(e);
                        }}
                      />{' '}
                      Alle Meldeblätter
                    </label>
                    <br />
                    <br />

                    <button
                      data-dismiss="modal"
                      onClick={() => {
                        this.showStatsExtended(0);
                      }}
                      class="btn btn-primary"
                    >
                      Gesamtstatistik
                    </button>
                    <button
                      data-dismiss="modal"
                      onClick={() => {
                        this.showStatsExtended(1);
                      }}
                      class="btn btn-primary"
                    >
                      Detailübersicht
                    </button>
                  </div>
                </div>
              </div>
            </div>

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
