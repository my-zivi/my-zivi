import React, { Component } from 'react';
import ScrollableCard from '../tags/scrollableCard';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/InputFields/DatePicker';
import { api, apiURL } from '../../utils/api';

export default class ExpenseOverview extends Component {
  constructor(props) {
    super(props);

    var date = new Date();
    var firstDay = new Date(date.getFullYear(), date.getMonth(), 1).toISOString();
    var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0).toISOString();

    this.state = {
      activeReportSheet: null,
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
    this.getReportSheets('reportsheet/pending', 2);
  }

  getReportSheets(url, tabId) {
    this.setState({
      activeReportSheet: tabId,
      zdp: '',
      name: '',
      start: '',
      end: '',
      loading: true,
      error: null,
    });
    api()
      .get(url)
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
    this.setState({
      [e.target.name]: value,
    });
  }

  handleDateChange(e) {
    let value = e.target.value;

    if (value) {
      value = DatePicker.dateFormat_CH2EN(value);
    } else {
      value = this.state.lastDateValue;
    }

    this.setState({ [e.target.name]: value });
  }

  showStatsExtended(showDetails) {
    return this.showStats(
      this.state.time_type,
      showDetails,
      this.state.showOnlyDoneSheets,
      this.state.time_year,
      this.state.time_from,
      this.state.time_to
    );
  }

  showStats(time_type, showDetails, showOnlyDoneSheets, time_year, time_from, time_to) {
    return apiURL(
      'pdf/statistik',
      {
        time_type,
        showDetails,
        showOnlyDoneSheets,
        time_year,
        time_from,
        time_to,
      },
      true
    );
  }

  monthNames = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  render() {
    let tableBody = [];
    var sheets = this.state.report_sheets;
    let statusIcon = (
      <span data-toggle="popover" title="" data-content="Erledigt">
        <span style={{ color: 'green' }} className="glyphicon glyphicon-ok" aria-hidden="true" />
      </span>
    );

    for (let i = 0; i < sheets.length; i++) {
      if (this.state.zdp && !sheets[i].zdp.startsWith(this.state.zdp)) {
        continue;
      }
      if (
        this.state.name &&
        (sheets[i].first_name + ' ' + sheets[i].last_name).toLowerCase().indexOf(this.state.name.toLowerCase()) === -1
      ) {
        continue;
      }
      if (this.state.start && sheets[i].end < this.state.start) {
        continue;
      }
      if (this.state.end && sheets[i].start > this.state.end) {
        continue;
      }

      tableBody.push(
        <tr>
          <td>&nbsp;</td>
          <td className="center">{sheets[i].zdp}</td>
          <td>
            <a href={'/profile/' + sheets[i].userid}>
              {sheets[i].first_name} {sheets[i].last_name}
            </a>
          </td>
          <td className="center">{sheets[i].start}</td>
          <td className="center">{sheets[i].end}</td>
          <td>{sheets[i].done ? statusIcon : ''}</td>
          <td>
            <a href={'/expense/' + sheets[i].id}>Spesen bearbeiten</a>
          </td>
        </tr>
      );
    }

    var prevMonthDate = new Date();
    prevMonthDate.setMonth(prevMonthDate.getMonth() - 1);
    var curMonthDate = new Date();

    var yearoptions = [];
    for (var i = 2005; i < curMonthDate.getFullYear() + 3; i++) {
      yearoptions.push(
        <option key={i} value={i}>
          {i}
        </option>
      );
    }

    return (
      <Header>
        <div className="page page__expense">
          <ScrollableCard>
            <div className="btn-group">
              <a className="btn btn-default" href={this.showStats(3, 1)} target="_blank">
                <span className="glyphicon glyphicon-file" aria-hidden="true" />
                {' ' + this.monthNames[prevMonthDate.getMonth()]}
              </a>
              <a className="btn btn-default" href={this.showStats(2, 1)} target="_blank">
                <span className="glyphicon glyphicon-file" aria-hidden="true" />
                {' ' + this.monthNames[curMonthDate.getMonth()]}
              </a>
              <button className="btn btn-default" data-toggle="modal" data-target="#myModal">
                <span className="glyphicon glyphicon-file" aria-hidden="true" />
                {' Erweitert'}
              </button>
            </div>

            <br />
            <br />
            <h2>Spesenblätter</h2>

            <div className="btn-group">
              <button
                id="tab1"
                className={this.state.activeReportSheet === 1 ? 'btn btn-primary' : 'btn btn-default'}
                onClick={() => this.getReportSheets('reportsheet', 1)}
              >
                Alle Spesenblätter anzeigen
              </button>
              <button
                id="tab2"
                className={this.state.activeReportSheet === 2 ? 'btn btn-primary' : 'btn btn-default'}
                onClick={() => this.getReportSheets('reportsheet/pending', 2)}
              >
                Pendente Spesenblätter anzeigen
              </button>
              <button
                id="tab3"
                className={this.state.activeReportSheet === 3 ? 'btn btn-primary' : 'btn btn-default'}
                onClick={() => this.getReportSheets('reportsheet/current', 3)}
              >
                Aktuelle Spesenblätter anzeigen
              </button>
            </div>
            <div className="btn-group" style={{ paddingLeft: '10px' }}>
              <a className="btn btn-default" href="/expensePayment">
                Auszahlung
              </a>
            </div>
            <br />
            <br />
            <div id="myModal" className="modal fade" role="dialog">
              <div className="modal-dialog">
                <div className="modal-content">
                  <div className="modal-header">
                    <button type="button" className="close" data-dismiss="modal">
                      &times;
                    </button>
                    <h4 className="modal-title">Spesenstatistik erstellen</h4>
                  </div>
                  <div className="modal-body">
                    <div className="btn-group btn-block" data-toggle="buttons">
                      <label
                        className="btn btn-default active"
                        data-toggle="collapse"
                        data-target="#datePickerContainer.in"
                        style={{ width: '598px', borderRadius: '5px', margin: '0px' }}
                      >
                        <input
                          type="radio"
                          name="time_type"
                          value="0"
                          defaultChecked="true"
                          onChange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        Jahr:&nbsp;
                        <select
                          name="time_year"
                          defaultValue={curMonthDate.getFullYear()}
                          onChange={e => {
                            this.handleChange(e);
                          }}
                          style={{ color: 'black' }}
                        >
                          {yearoptions}
                        </select>
                      </label>

                      <label
                        className="btn btn-default"
                        data-toggle="collapse"
                        data-target="#datePickerContainer:not(.in)"
                        style={{ width: '598px', borderRadius: '5px', margin: '0px' }}
                      >
                        <input
                          type="radio"
                          name="time_type"
                          value="1"
                          onChange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        Periode:&nbsp;
                      </label>
                      <div id="datePickerContainer" className="panel-collapse collapse ">
                        <div className="btn-group-justified">
                          <label className="btn">
                            <DatePicker
                              id="time_from"
                              label="Von"
                              value={this.state.time_from}
                              onChange={this.handleDateChange.bind(this)}
                            />
                          </label>
                          <label className="btn">
                            <DatePicker id="time_to" label="Zu" value={this.state.time_to} onChange={this.handleDateChange.bind(this)} />
                          </label>
                        </div>
                      </div>

                      <label
                        className="btn btn-default"
                        data-toggle="collapse"
                        data-target="#datePickerContainer.in"
                        style={{ width: '598px', borderRadius: '5px', margin: '0px' }}
                      >
                        <input
                          type="radio"
                          name="time_type"
                          value="2"
                          onChange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        {this.monthNames[curMonthDate.getMonth()] + ' ' + curMonthDate.getFullYear()}
                      </label>

                      <label
                        className="btn btn-default"
                        data-toggle="collapse"
                        data-target="#datePickerContainer.in"
                        style={{ width: '598px', borderRadius: '5px', margin: '0px' }}
                      >
                        <input
                          type="radio"
                          name="time_type"
                          value="3"
                          onChange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        {this.monthNames[prevMonthDate.getMonth()] + ' ' + prevMonthDate.getFullYear()}
                      </label>
                    </div>

                    <br />
                    <br />

                    <div className="btn-group  btn-group-justified" data-toggle="buttons">
                      <label className="btn btn-default active">
                        <input
                          type="radio"
                          name="showOnlyDoneSheets"
                          value="1"
                          onChange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        Erledigte Spesenblätter
                      </label>
                      <label className="btn btn-default">
                        <input
                          type="radio"
                          name="showOnlyDoneSheets"
                          value="0"
                          onChange={e => {
                            this.handleChange(e);
                          }}
                        />{' '}
                        Alle Spesenblätter
                      </label>
                    </div>

                    <br />

                    <div className="btn-group  btn-group-justified">
                      <a className="btn btn-info" href={this.showStatsExtended(0)} target="_blank">
                        Gesamtstatistik
                      </a>
                      <a className="btn btn-info" href={this.showStatsExtended(1)} target="_blank">
                        Detailübersicht
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <table className="table table-hover">
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
                <tr className="theader">
                  <td>&nbsp;</td>
                  <td>
                    <input className="form-control" name="zdp" type="text" value={this.state.zdp} onChange={this.handleChange.bind(this)} />
                  </td>
                  <td>
                    <input
                      className="form-control"
                      name="name"
                      type="text"
                      value={this.state.name}
                      onChange={this.handleChange.bind(this)}
                    />
                  </td>
                  <td>
                    <DatePicker id="start" value={null} onChange={this.handleDateChange.bind(this)} showLabel={false} />
                  </td>
                  <td>
                    <DatePicker id="end" value={null} onChange={this.handleDateChange.bind(this)} showLabel={false} />
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
