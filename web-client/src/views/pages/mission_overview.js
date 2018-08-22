import React, { Component } from 'react';
import ScrollableCard from '../tags/scrollableCard';
import Header from '../tags/header';
import LoadingView from '../tags/loading-view';
import moment from 'moment-timezone';
import { api } from '../../utils/api';
import update from 'immutability-helper';

export default class MissionOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {
      year: new Date().getFullYear(),
      loadingSpecifications: false,
      loadingMissions: false,
      error: null,
      missions: [],
      weekCount: [],
      specifications: [],
    };
  }

  componentDidMount() {
    this.getSpecifications();
    this.getMissions();

    this.scrollTableHeader(document.querySelector('table'));
  }

  async getSpecifications() {
    this.setState({ loadingSpecifications: true, error: null });
    try {
      let response = await api().get('specification');
      response.data.forEach(row => (row.selected = true));
      this.setState({
        loadingSpecifications: false,
        specifications: response.data,
      });
    } catch (error) {
      this.setState({ error });
    }
  }

  async getMissions() {
    this.setState({ loadingMissions: true, error: null });
    try {
      let response = await api().get(`missions/${this.state.year}`);

      let { missions, weekCount } = this.renderMissions(response.data);

      this.setState({
        loadingMissions: false,
        missions,
        weekCount,
      });
    } catch (error) {
      this.setState({ error });
    }
  }

  handleChangeYear(e) {
    this.setState({ year: e.target.value }, () => this.getMissions());
  }

  toggleSpecification(e) {
    //this.state.specifications[i].selected = e.target.checked;
    this.setState({
      specifications: update(this.state.specifications, { [e.target.name]: { $toggle: ['selected'] } }),
    });
  }

  isSpecSelected(specId) {
    // warning: specId will be a string, but the id of the spec is a number!
    // that's because we store the mission ids as strings rather than a number (look up issue #73 on github)
    // so it is safer to convert the spec.id to a string rather than the other way
    return this.state.specifications.filter(spec => spec.selected).some(spec => spec.id.toString() === specId);
  }

  monthNames = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  print() {
    window.print();
  }

  scrollTableHeader(table) {
    const onScroll = () => {
      const offset = window.pageYOffset;
      const tableOffsetTop = table.getBoundingClientRect().top + window.pageYOffset;
      const thead = table.querySelector('thead');

      if (offset > tableOffsetTop - 50) {
        thead.style.top = `${offset - (tableOffsetTop - 50)}px`;
      } else {
        thead.style.top = '0';
      }
    };

    document.addEventListener('scroll', onScroll);
    onScroll();
  }

  renderMissions(missions) {
    let weekCount = {};
    for (let spec of this.state.specifications) {
      weekCount[spec.id] = [];
      for (let i = 1; i <= 52; i++) {
        weekCount[spec.id][i] = 0;
      }
    }

    let startDates = [];
    let endDates = [];

    for (let x = 1; x <= 52; x++) {
      startDates[x] = moment(this.state.year + ' ' + x + ' 1', 'YYYY WW E').format('DD.MM.YYYY');
      endDates[x] = moment(this.state.year + ' ' + x + ' 5', 'YYYY WW E').format('DD.MM.YYYY');
    }

    let rows = [];

    for (let mission of missions) {
      let cells = [];

      let missionCounter = 0;

      for (let x = 1; x <= 52; x++) {
        let popOverStart = startDates[x];
        let popOverEnd = endDates[x];

        let curMission = mission[missionCounter];
        if (!curMission) {
          continue;
        }
        let startWeek = moment(curMission.start).isoWeek();
        if (new Date(curMission.start).getFullYear() < this.state.year) {
          startWeek = -1;
        }
        let endWeek = moment(curMission.end).isoWeek();
        if (new Date(curMission.end).getFullYear() > this.state.year) {
          endWeek = 55;
        }

        if (x < startWeek || x > endWeek) {
          cells.push({
            title: popOverStart + ' - ' + popOverEnd,
          });
        } else {
          if (weekCount[curMission.specification]) {
            weekCount[curMission.specification][x]++;
          }
          if (x === startWeek) {
            cells.push({
              className: curMission.draft == null ? 'einsatzDraft' : 'einsatz',
              title: popOverStart + ' - ' + popOverEnd,
              content: new Date(curMission.start).getDate(),
            });
          } else if (x === endWeek) {
            cells.push({
              className: curMission.draft == null ? 'einsatzDraft' : 'einsatz',
              title: popOverStart + ' - ' + popOverEnd,
              content: new Date(curMission.end).getDate(),
            });
          } else {
            cells.push({
              className: curMission.draft == null ? 'einsatzDraft' : 'einsatz',
              title: popOverStart + ' - ' + popOverEnd,
              content: 'x',
            });
          }

          if (x === endWeek && missionCounter < mission.length - 1) {
            missionCounter++;
          }
        }
      }

      rows.push({
        specId: String(mission[0].specification),
        shortName: mission[0].short_name,
        zdp: mission[0].zdp,
        userId: mission[0].userid,
        userName: `${mission[0].first_name} ${mission[0].last_name}`,
        cells,
      });
    }

    return {
      missions: rows,
      weekCount,
    };
  }

  render() {
    var specifications = [];
    var specs = this.state.specifications;

    var specIdsOfMissions = this.state.missions.map(mission => mission.specId).filter((elem, index, arr) => index === arr.indexOf(elem));

    for (let x = 0; x < specs.length; x++) {
      if (specIdsOfMissions.includes(specs[x].id)) {
        specifications.push(
          <div className="checkbox no-print" key={x}>
            <label>
              <input
                type="checkbox"
                name={x}
                checked={specs[x].selected}
                onChange={e => {
                  this.toggleSpecification(e);
                }}
              />
              {specs[x].name}
            </label>
          </div>
        );
      }
    }

    var yearOptions = [];
    for (let i = 2005; i <= new Date().getFullYear() + 1; i++) {
      yearOptions.push(
        <option key={i} value={i}>
          {i}
        </option>
      );
    }

    var weekCount = this.state.weekCount;
    var averageCount = 0;
    var weekHeaders = [];
    var averageHeaders = [];
    var monthHeaders = [];
    var startDate = new Date(this.state.year + '-01-01');
    while (moment(startDate).isoWeek() > 50) {
      startDate.setDate(startDate.getDate() + 1);
    }
    var prevMonth = moment(startDate)
      .isoWeekday(1)
      .month();
    var monthColCount = 0;
    for (let i = 1; i <= 52; i++) {
      var weekCountSum = 0;
      for (let x = 0; x < specs.length; x++) {
        if (specs[x].selected && weekCount[specs[x].id]) {
          weekCountSum += weekCount[specs[x].id][i];
        }
      }
      weekHeaders.push(<td key={i}>{i}</td>);
      averageHeaders.push(<td key={i}>{weekCountSum}</td>);
      averageCount += weekCountSum;
      if (
        moment(startDate)
          .isoWeekday(1)
          .month() !== prevMonth
      ) {
        // cell width (25px) must be the same as in mission_overview.sass
        monthHeaders.push(
          <td
            style={{ fontWeight: 'bold', maxWidth: 25 * monthColCount + 'px', overflow: 'hidden' }}
            colSpan={monthColCount}
            key={'month_header_' + i}
          >
            {this.monthNames[prevMonth]}
          </td>
        );
        monthColCount = 0;
        prevMonth = startDate.getMonth();
      }
      monthColCount++;
      startDate.setDate(startDate.getDate() + 7);
    }
    monthHeaders.push(
      <td style={{ fontWeight: 'bold' }} colSpan={monthColCount} key={this.monthNames.indexOf(this.monthNames[prevMonth])}>
        {this.monthNames[prevMonth]}
      </td>
    );

    return (
      <Header>
        <div className="page page__mission_overview">
          <ScrollableCard>
            <h1>Einsatzübersicht</h1>
            <div className="container no-print" style={{ height: 'auto', width: 'auto' }}>
              <div className="row">
                <div className="col-sm-2">
                  <select
                    defaultValue={this.state.year}
                    onChange={e => this.handleChangeYear(e)}
                    className="form-control"
                    style={{ margin: '10px auto auto auto' }}
                  >
                    {yearOptions}
                  </select>
                </div>
                <div className="col-sm-8">{specifications}</div>
                <div className="col-sm-2">
                  <button
                    type="button"
                    className="btn btn-primary"
                    name="print"
                    onClick={e => this.print()}
                    style={{ margin: '10px auto auto auto' }}
                  >
                    {' '}
                    Drucken{' '}
                  </button>
                </div>
              </div>
            </div>

            <table className="table table-striped table-bordered table-no-padding" id="mission_overview_table">
              <thead>
                <tr>
                  <td colSpan="3" rowSpan="2">
                    Name
                  </td>
                  {monthHeaders}
                </tr>
                <tr>{weekHeaders}</tr>
                <tr>
                  <td colSpan="3" style={{ textAlign: 'left', paddingLeft: '8px !important', fontWeight: 'bold' }} nowrap="true">
                    Ø / Woche: {(averageCount / 52).toFixed(2)}
                  </td>
                  {averageHeaders}
                </tr>
              </thead>
              <tbody>{this.state.missions.map(row => this.isSpecSelected(row.specId) && <Row key={row.zdp} {...row} />)}</tbody>
            </table>
          </ScrollableCard>
          <LoadingView loading={this.state.loadingMissions || this.state.loadingSpecifications} error={this.state.error} />
        </div>
      </Header>
    );
  }
}

function Row({ specId, shortName, zdp, userId, userName, cells }) {
  return (
    <tr className={'mission-row-' + specId}>
      <td>{shortName}</td>

      <td>
        <div className="no-print">{zdp}</div>
      </td>

      <td className="einsatz-zivi-name" nowrap="true">
        <a href={'/profile/' + userId}>{userName}</a>
      </td>

      {cells.map(({ content, ...props }, index) => (
        <td key={index} {...props}>
          {content}
        </td>
      ))}
    </tr>
  );
}
