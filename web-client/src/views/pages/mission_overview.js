import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
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

    var wocheCount = [];
    for (var i = 1; i <= 52; i++) {
      wocheCount[i] = 0;
    }

    var tbody = [];
    var missions = this.state.missions;
    for (var i = 0; i < missions.length; i++) {
      var selected = false;
      for (var s = 0; s < specs.length; s++) {
        if (specs[s].fullId == missions[i].specification) {
          selected = specs[s].selected;
          break;
        }
      }

      if (!selected) {
        continue;
      }

      var cells = [];
      cells.push(<td>{missions[i].short_name}</td>);
      cells.push(
        <td>
          <div class="no-print">{missions[i].zdp}</div>
        </td>
      );
      cells.push(
        <td class="einsatz-zivi-name" style="text-align:left; padding-left:8px !important;" nowrap>
          <a href={'/profile/' + missions[i].userid}>
            {missions[i].first_name} {missions[i].last_name}
          </a>
        </td>
      );
      var startWeek = moment(missions[i].start).isoWeek();
      if (new Date(missions[i].start).getFullYear() < this.state.year) {
        startWeek = -1;
      }
      var endWeek = moment(missions[i].end).isoWeek();
      if (new Date(missions[i].end).getFullYear() > this.state.year) {
        endWeek = 55;
      }
      for (var x = 1; x <= 52; x++) {
        if (x < startWeek || x > endWeek) {
          cells.push(<td />);
        } else {
          wocheCount[x]++;
          if (x == startWeek) {
            cells.push(<td class={missions[i].draft == null ? 'einsatzDraft' : 'einsatz'}>{new Date(missions[i].start).getDate()}</td>);
          } else if (x == endWeek) {
            cells.push(<td class={missions[i].draft == null ? 'einsatzDraft' : 'einsatz'}>{new Date(missions[i].end).getDate()}</td>);
          } else {
            cells.push(<td class={missions[i].draft == null ? 'einsatzDraft' : 'einsatz'}>x</td>);
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
      averageHeaders.push(<td>{wocheCount[i]}</td>);
      averageCount += wocheCount[i];
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
          <Card>
            <h1>Einsatzübersicht</h1>

            {specifications}

            <select defaultValue={this.state.year} onchange={e => this.handleChangeYear(e)}>
              <option value="2015">2015</option>
              {yearOptions}
            </select>

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
          </Card>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
