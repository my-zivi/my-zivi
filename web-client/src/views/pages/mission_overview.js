import Inferno from 'inferno';
import { Link } from 'inferno-router';
import ScrollableCard from '../tags/scrollableCard';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import Header from '../tags/header';
import LoadingView from '../tags/loading-view';

export default class MissionOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {
      year: new Date().getFullYear(),
      loading: false,
      error: null,
      missions: [],
      specifications: [],
    };
  }

  componentDidMount() {
    this.getSpecifications();
    this.getMissions();
  }

  getSpecifications() {
    axios
      .get(ApiService.BASE_URL + 'specification', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
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
    axios
      .get(ApiService.BASE_URL + 'missions/' + this.state.year, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({
          missions: response.data,
          loading: false,
        });
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

  monthNames = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  print() {
    window.print();
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

    var weekCount = [];
    for (var i = 1; i <= 52; i++) {
      weekCount[i] = 0;
    }

    var tbody = [];
    var userMissions = this.state.missions;

    for (var i = 0; i < userMissions.length; i++) {
      var selected = false;
      for (var s = 0; s < specs.length; s++) {
        for (var x = 0; x < userMissions[i].length; x++) {
          if (specs[s].fullId == userMissions[i][x].specification) {
            selected = specs[s].selected;
            break;
          }
        }
      }

      if (!selected) {
        continue;
      }

      var cells = [];
      cells.push(<td>{userMissions[i][0].short_name}</td>);
      cells.push(
        <td>
          <div class="no-print">{userMissions[i][0].zdp}</div>
        </td>
      );
      cells.push(
        <td class="einsatz-zivi-name" style="text-align:left; padding-left:8px !important;" nowrap>
          <a href={'/profile/' + userMissions[i][0].userid}>
            {userMissions[i][0].first_name} {userMissions[i][0].last_name}
          </a>
        </td>
      );

      var missionCounter = 0;

      for (var x = 1; x <= 52; x++) {
        var curMission = userMissions[i][missionCounter];
        var startWeek = moment(curMission.start).isoWeek();
        if (new Date(curMission.start).getFullYear() < this.state.year) {
          startWeek = -1;
        }
        var endWeek = moment(curMission.end).isoWeek();
        if (new Date(curMission.end).getFullYear() > this.state.year) {
          endWeek = 55;
        }

        if (x < startWeek || x > endWeek) {
          cells.push(<td />);
        } else {
          weekCount[x]++;
          if (x == startWeek) {
            cells.push(<td class={curMission.draft == null ? 'einsatzDraft' : 'einsatz'}>{new Date(curMission.start).getDate()}</td>);
          } else if (x == endWeek) {
            cells.push(<td class={curMission.draft == null ? 'einsatzDraft' : 'einsatz'}>{new Date(curMission.end).getDate()}</td>);
          } else {
            cells.push(<td class={curMission.draft == null ? 'einsatzDraft' : 'einsatz'}>x</td>);
          }

          if (x == endWeek && missionCounter < userMissions[i].length - 1) {
            missionCounter++;
          }
        }
      }

      tbody.push(<tr>{cells}</tr>);
    }

    var averageCount = 0;
    var weekHeaders = [];
    var averageHeaders = [];
    var monthHeaders = [];
    var startDate = new Date(this.state.year + '-01-01');
    while (moment(startDate).isoWeek() > 50) {
      startDate.setDate(startDate.getDate() + 7);
    }
    var prevMonth = 0;
    var monthColCount = 1;
    for (var i = 1; i <= 52; i++) {
      weekHeaders.push(<td style="width:25px;">{i}</td>);
      averageHeaders.push(<td>{weekCount[i]}</td>);
      averageCount += weekCount[i];
      if (startDate.getMonth() != prevMonth) {
        monthHeaders.push(
          <td style="font-weight:bold;" colspan={monthColCount}>
            {this.monthNames[prevMonth]}
          </td>
        );
        monthColCount = 1;
        prevMonth = startDate.getMonth();
      } else {
        monthColCount++;
      }
      startDate.setDate(startDate.getDate() + 7);
    }
    monthHeaders.push(
      <td style="font-weight:bold;" colspan={monthColCount}>
        {this.monthNames[prevMonth]}
      </td>
    );

    var yearOptions = [];
    for (var i = 2005; i <= new Date().getFullYear() + 1; i++) {
      yearOptions.push(<option value={i}>{i}</option>);
    }

    return (
      <Header>
        <div className="page page__mission_overview">
          <ScrollableCard>
            <h1>Einsatzübersicht</h1>

            <div class="container" style="height: auto;">
              <div class="row">
                <div class="col-sm-2">
                  <select defaultValue={this.state.year} onchange={e => this.handleChangeYear(e)}>
                    <option value="2015">2015</option>
                    {yearOptions}
                  </select>
                </div>
                <div class="col-sm-8">{specifications}</div>
                <div class="col-sm-2">
                  <button type="button" class="btn btn-primary" name="print" onclick={e => this.print()}>
                    {' '}
                    Drucken{' '}
                  </button>
                </div>
              </div>
            </div>

            <table class="table table-striped table-bordered table-no-padding">
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
              <tbody>{tbody}</tbody>
            </table>
          </ScrollableCard>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
