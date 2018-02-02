import Inferno from 'inferno';
import { Link } from 'inferno-router';
import ScrollableCard from '../tags/scrollableCard';
import Component from 'inferno-component';
import Header from '../tags/header';
import LoadingView from '../tags/loading-view';
import moment from 'moment-timezone';
import { api } from '../../utils/api';

export default class MissionOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {
      year: new Date().getFullYear(),
      loading: false,
      error: null,
      missions: [],
      weekCount: [],
      specifications: [],
    };
  }

  componentDidMount() {
    this.getSpecifications();
    this.getMissions();

    this.scrollTableHeader($('table'));
  }

  getSpecifications() {
    api()
      .get('specification')
      .then(response => {
        for (var i = 0; i < response.data.length; i++) {
          response.data[i].selected = true;
        }
        this.setState({
          specifications: response.data,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getMissions() {
    this.setState({ loading: true, error: null });
    api()
      .get(`missions/${this.state.year}`)
      .then(response => {
        this.renderMissions(response.data);
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChangeYear(e) {
    this.state.year = e.target.value;
    this.setState(this.state);
    this.getMissions();
  }

  handleChange(e, i) {
    this.state.specifications[e.target.name].selected = e.target.checked;
    this.setState(this.state);
  }

  componentDidUpdate() {
    var specs = this.state.specifications;
    for (var s = 0; s < specs.length; s++) {
      if (specs[s].selected) {
        $('tr.mission-row-' + String(specs[s].fullId).replace('.', '_')).show();
      } else {
        $('tr.mission-row-' + String(specs[s].fullId).replace('.', '_')).hide();
      }
    }
  }

  monthNames = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  print() {
    window.print();
  }

  scrollTableHeader(table) {
    const onScroll = () => {
      const offset = $(window).scrollTop();
      const tableOffsetTop = table.offset().top;
      const thead = table.find('thead');

      if (offset > tableOffsetTop - 50) {
        thead.css('top', offset - (tableOffsetTop - 50));
      } else {
        thead.css('top', 0);
      }
    };

    $(window).scroll(onScroll);
    onScroll();
  }

  renderMissions(userMissions) {
    var specs = this.state.specifications;

    var weekCount = [];
    for (var x = 0; x < specs.length; x++) {
      weekCount[specs[x].fullId] = [];
      for (var i = 1; i <= 52; i++) {
        weekCount[specs[x].fullId][i] = 0;
      }
    }

    var startDates = [];
    var endDates = [];

    for (var x = 1; x <= 52; x++) {
      startDates[x] = moment(this.state.year + ' ' + x + ' 1', 'YYYY WW E').format('DD.MM.YYYY');
      endDates[x] = moment(this.state.year + ' ' + x + ' 5', 'YYYY WW E').format('DD.MM.YYYY');
    }

    var tbody = [];

    for (var i = 0; i < userMissions.length; i++) {
      var cells = [];
      cells.push(<td>{userMissions[i][0].short_name}</td>);
      cells.push(
        <td>
          <div class="no-print">{userMissions[i][0].zdp}</div>
        </td>
      );
      cells.push(
        <td class="einsatz-zivi-name" nowrap>
          <a href={'/profile/' + userMissions[i][0].userid}>
            {userMissions[i][0].first_name} {userMissions[i][0].last_name}
          </a>
        </td>
      );

      var missionCounter = 0;

      for (var x = 1; x <= 52; x++) {
        let popOverStart = startDates[x];
        let popOverEnd = endDates[x];

        var curMission = userMissions[i][missionCounter];
        if (!curMission) {
          continue;
        }
        var startWeek = moment(curMission.start).isoWeek();
        if (new Date(curMission.start).getFullYear() < this.state.year) {
          startWeek = -1;
        }
        var endWeek = moment(curMission.end).isoWeek();
        if (new Date(curMission.end).getFullYear() > this.state.year) {
          endWeek = 55;
        }

        if (x < startWeek || x > endWeek) {
          cells.push(<td title={popOverStart + ' - ' + popOverEnd} />);
        } else {
          if (weekCount[curMission.specification]) {
            weekCount[curMission.specification][x]++;
          }
          if (x == startWeek) {
            cells.push(
              <td class={curMission.draft == null ? 'einsatzDraft' : 'einsatz'} title={popOverStart + ' - ' + popOverEnd}>
                {new Date(curMission.start).getDate()}
              </td>
            );
          } else if (x == endWeek) {
            cells.push(
              <td class={curMission.draft == null ? 'einsatzDraft' : 'einsatz'} title={popOverStart + ' - ' + popOverEnd}>
                {new Date(curMission.end).getDate()}
              </td>
            );
          } else {
            cells.push(
              <td class={curMission.draft == null ? 'einsatzDraft' : 'einsatz'} title={popOverStart + ' - ' + popOverEnd}>
                x
              </td>
            );
          }

          if (x == endWeek && missionCounter < userMissions[i].length - 1) {
            missionCounter++;
          }
        }
      }

      tbody.push(<tr class={'mission-row-' + String(userMissions[i][0].specification).replace('.', '_')}>{cells}</tr>);
    }

    this.setState({
      tbody: tbody,
      weekCount: weekCount,
      loading: false,
    });
  }

  render() {
    var specifications = [];
    var specs = this.state.specifications;
    for (var x = 0; x < specs.length; x++) {
      if (specs[x].active) {
        specifications.push(
          <div class="checkbox no-print">
            <label>
              <input
                type="checkbox"
                name={x}
                defaultChecked={true}
                onchange={e => {
                  this.handleChange(e);
                }}
              />
              {specs[x].name}
            </label>
          </div>
        );
      }
    }

    var yearOptions = [];
    for (var i = 2005; i <= new Date().getFullYear() + 1; i++) {
      yearOptions.push(<option value={i}>{i}</option>);
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
    for (var i = 1; i <= 52; i++) {
      var weekCountSum = 0;
      for (var x = 0; x < specs.length; x++) {
        if (specs[x].selected && weekCount[specs[x].fullId]) {
          weekCountSum += weekCount[specs[x].fullId][i];
        }
      }
      weekHeaders.push(<td>{i}</td>);
      averageHeaders.push(<td>{weekCountSum}</td>);
      averageCount += weekCountSum;
      if (
        moment(startDate)
          .isoWeekday(1)
          .month() != prevMonth
      ) {
        // cell width (25px) must be the same as in mission_overview.sass
        monthHeaders.push(
          <td style={{ 'font-weight': 'bold', 'max-width': 25 * monthColCount + 'px', overflow: 'hidden' }} colspan={monthColCount}>
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
      <td style="font-weight:bold;" colspan={monthColCount}>
        {this.monthNames[prevMonth]}
      </td>
    );

    return (
      <Header>
        <div className="page page__mission_overview">
          <ScrollableCard>
            <h1>Einsatzübersicht</h1>
            <div class="container no-print" style="height: auto; width: auto;">
              <div class="row">
                <div class="col-sm-2">
                  <select
                    defaultValue={this.state.year}
                    onchange={e => this.handleChangeYear(e)}
                    class="form-control"
                    style="margin: 10px auto auto auto;"
                  >
                    {yearOptions}
                  </select>
                </div>
                <div class="col-sm-8">{specifications}</div>
                <div class="col-sm-2">
                  <button
                    type="button"
                    class="btn btn-primary"
                    name="print"
                    onclick={e => this.print()}
                    style="margin: 10px auto auto auto;"
                  >
                    {' '}
                    Drucken{' '}
                  </button>
                </div>
              </div>
            </div>

            <table class="table table-striped table-bordered table-no-padding" id="mission_overview_table">
              <thead>
                <tr>
                  <td colspan="3" rowspan="2">
                    Name
                  </td>
                  {monthHeaders}
                </tr>
                <tr>{weekHeaders}</tr>
                <tr>
                  <td colspan="3" style="text-align:left; padding-left:8px !important; font-weight:bold;" nowrap>
                    Ø / Woche: {(averageCount / 52).toFixed(2)}
                  </td>
                  {averageHeaders}
                </tr>
              </thead>
              <tbody>{this.state.tbody}</tbody>
            </table>
          </ScrollableCard>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
