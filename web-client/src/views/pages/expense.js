import Inferno from 'inferno';
import { Link } from 'inferno-router';
import ScrollableCard from '../tags/scrollableCard';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/InputFields/DatePicker';

export default class MissionOverview extends Component {
  constructor(props) {
    super(props);

    var date = new Date();
    var firstDay = new Date(date.getFullYear(), date.getMonth(), 1).toISOString();
    var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0).toISOString();

    this.state = {
      report_sheets: [],
      zdp: '',
      name: '',
      start: '',
      end: '',
      time_from: firstDay,
      time_to: lastDay,
      lastDateValue: new Date().toISOString(),
      time_type: 0,
      time_year: new Date().getFullYear(),
      showOnlyDoneSheets: 1,
    };
  }

  componentDidMount() {
    this.getReportSheets('reportsheet', 1);
    DatePicker.initializeDatePicker();
  }

  getReportSheets(url, tabId) {
    $('#tab1').attr('class', 'btn btn-default');
    $('#tab2').attr('class', 'btn btn-default');
    $('#tab3').attr('class', 'btn btn-default');
    $('#tab' + tabId).attr('class', 'btn btn-primary');

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

  handleDateChange(e, origin) {
    let value = e.target.value;

    if (value === undefined || value == null || value == '') {
      value = origin.state.lastDateValue;
    } else {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    origin.state[e.target.name] = value;
    origin.setState(this.state);
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
          <ScrollableCard>
            <div class="btn-group">
              <button class="btn btn-default" onclick={() => this.showStats(3, 1)}>
                <span class="glyphicon glyphicon-file" aria-hidden="true" />
                {' ' + this.monthNames[prevMonthDate.getMonth()]}
              </button>
              <button class="btn btn-default" onclick={() => this.showStats(2, 1)}>
                <span class="glyphicon glyphicon-file" aria-hidden="true" />
                {' ' + this.monthNames[curMonthDate.getMonth()]}
              </button>
              <button class="btn btn-default" data-toggle="modal" data-target="#myModal">
                <span class="glyphicon glyphicon-file" aria-hidden="true" />
                {' Erweitert'}
              </button>
            </div>

            <br />
            <br />
            <h2>Meldeblätter</h2>

            <div class="btn-group">
              <button id="tab1" onclick={() => this.getReportSheets('reportsheet', 1)}>
                Alle Meldeblätter anzeigen
              </button>
              <button id="tab2" onclick={() => this.getReportSheets('reportsheet/pending', 2)}>
                Pendente Meldeblätter anzeigen
              </button>
              <button id="tab3" onclick={() => this.getReportSheets('reportsheet/current', 3)}>
                Aktuelle Meldeblätter anzeigen
              </button>
            </div>
            <br />
            <br />
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
                    <div class="btn-group btn-block" data-toggle="buttons">
                      <label
                        class="btn btn-default active"
                        data-toggle="collapse"
                        data-target="#datePickerContainer.in"
                        style="width: 598px;border-radius: 5px;margin: 0px;"
                      >
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
                        <select
                          name="time_year"
                          defaultValue={curMonthDate.getFullYear()}
                          onchange={e => {
                            this.handleChange(e);
                          }}
                          style="color: black;"
                        >
                          {yearoptions}
                        </select>
                      </label>

                      <label
                        class="btn btn-default"
                        data-toggle="collapse"
                        data-target="#datePickerContainer:not(.in)"
                        style="width: 598px;border-radius: 5px;margin: 0px;"
                      >
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
                      <div id="datePickerContainer" class="panel-collapse collapse ">
                        <div class="btn-group-justified">
                          <label class="btn">
                            <DatePicker
                              id="time_from"
                              label="Von"
                              value={this.state.time_from}
                              callback={this.handleDateChange}
                              callbackOrigin={this}
                            />
                          </label>
                          <label class="btn">
                            <DatePicker
                              id="time_to"
                              label="Zu"
                              value={this.state.time_to}
                              callback={this.handleDateChange}
                              callbackOrigin={this}
                            />
                          </label>
                        </div>
                      </div>

                      <label
                        class="btn btn-default"
                        data-toggle="collapse"
                        data-target="#datePickerContainer.in"
                        style="width: 598px;border-radius: 5px;margin: 0px;"
                      >
                        <input
                          type="radio"
                          name="time_type"
                          value="2"
                          onchange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        {this.monthNames[curMonthDate.getMonth()] + ' ' + curMonthDate.getFullYear()}
                      </label>

                      <label
                        class="btn btn-default"
                        data-toggle="collapse"
                        data-target="#datePickerContainer.in"
                        style="width: 598px;border-radius: 5px;margin: 0px;"
                      >
                        <input
                          type="radio"
                          name="time_type"
                          value="3"
                          onchange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        {this.monthNames[prevMonthDate.getMonth()] + ' ' + prevMonthDate.getFullYear()}
                      </label>
                    </div>

                    <br />
                    <br />

                    <div class="btn-group  btn-group-justified" data-toggle="buttons">
                      <label class="btn btn-default active">
                        <input
                          type="radio"
                          name="showOnlyDoneSheets"
                          value="1"
                          onchange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        Erledigte Meldeblätter
                      </label>
                      <label class="btn btn-default">
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
                    </div>

                    <br />

                    <div class="btn-group  btn-group-justified" data-toggle="buttons">
                      <label class="btn btn-info">
                        <input
                          type="radio"
                          data-dismiss="modal"
                          onchange={() => {
                            this.showStatsExtended(0);
                          }}
                        />{' '}
                        Gesamtstatistik
                      </label>
                      <label class="btn btn-info">
                        <input
                          type="radio"
                          data-dismiss="modal"
                          onchange={() => {
                            this.showStatsExtended(1);
                          }}
                        />{' '}
                        Detailübersicht
                      </label>
                    </div>
                  </div>
                </div>
              </div>
            </div>

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
                    <input class="form-control" name="zdp" type="text" value={this.state.zdp} oninput={this.handleChange.bind(this)} />
                  </td>
                  <td>
                    <input class="form-control" name="name" type="text" value={this.state.name} oninput={this.handleChange.bind(this)} />
                  </td>
                  <td>
                    <DatePicker id="start" value={null} callback={this.handleDateChange} callbackOrigin={this} showLabel={false} />
                  </td>
                  <td>
                    <DatePicker id="end" value={null} callback={this.handleDateChange} callbackOrigin={this} showLabel={false} />
                  </td>
                  <td />
                  <td />
                </tr>
              </thead>
              <tbody>{tableBody}</tbody>
            </table>
          </ScrollableCard>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
