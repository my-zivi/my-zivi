import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

export default class Freeday extends Component {
  constructor(props) {
    super(props);

    this.state = {
      freedays: [],
      newFreeday: { holiday_type: 2, description: '' },
    };
  }

  componentDidMount() {
    this.getFreedays();
  }

  getFreedays() {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'holiday', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.setState({
          freedays: response.data,
          loading: false,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChange(e, i) {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.state['freedays'][i][e.target.name] = value;
    this.setState(this.state);
  }

  save(i) {
    this.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'holiday/' + this.state.freedays[i].id, this.state.freedays[i], {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({ loading: false });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  remove(i) {
    this.setState({ loading: true, error: null });
    axios
      .delete(ApiService.BASE_URL + 'holiday/' + this.state.freedays[i].id, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.getFreedays();
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChangeNew(e) {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.state['newFreeday'][e.target.name] = value;
    this.setState(this.state);
  }

  add() {
    this.setState({ loading: true, error: null });
    axios
      .put(ApiService.BASE_URL + 'holiday', this.state.newFreeday, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({ newFreeday: { holiday_type: 2, description: '' } });
        this.getFreedays();
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  render() {
    var tbody = [];

    tbody.push(
      <tr>
        <td>
          <input
            class="form-control"
            type="date"
            name="date_from"
            value={this.state.newFreeday.date_from}
            onChange={e => this.handleChangeNew(e)}
          />
        </td>
        <td>
          <input
            class="form-control"
            type="date"
            name="date_to"
            value={this.state.newFreeday.date_to}
            onChange={e => this.handleChangeNew(e)}
          />
        </td>
        <td>
          <select
            class="form-control"
            name="holiday_type"
            value={this.state.newFreeday.holiday_type}
            onChange={e => this.handleChangeNew(e)}
          >
            <option value="2">Feiertag</option>
            <option value="1">Betriebsferien</option>
          </select>
        </td>
        <td>
          <input
            class="form-control"
            type="text"
            value={this.state.newFreeday.description}
            name="description"
            onChange={e => this.handleChangeNew(e)}
          />
        </td>
        <td>
          <button class="btn btn-sm" onClick={() => this.add()}>
            hinzufügen
          </button>
        </td>
        <td />
      </tr>
    );

    var freedays = this.state.freedays;
    for (let i = 0; i < freedays.length; i++) {
      tbody.push(
        <tr>
          <td>
            <input
              class="form-control"
              type="date"
              name="date_from"
              value={freedays[i].date_from}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td>
            <input class="form-control" type="date" name="date_to" value={freedays[i].date_to} onChange={e => this.handleChange(e, i)} />
          </td>
          <td>
            <select class="form-control" name="holiday_type" value={'' + freedays[i].holiday_type} onChange={e => this.handleChange(e, i)}>
              <option value="2">Feiertag</option>
              <option value="1">Betriebsferien</option>
            </select>
          </td>
          <td>
            <input
              class="form-control"
              type="text"
              name="description"
              value={freedays[i].description}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td>
            <button class="btn btn-sm" onClick={() => this.save(i)}>
              speichern
            </button>
          </td>
          <td>
            <button
              class="btn btn-sm"
              onClick={() => {
                if (confirm('Möchten Sie ' + freedays[i].description + ' wirklich löschen?')) {
                  this.remove(i);
                }
              }}
            >
              löschen
            </button>
          </td>
        </tr>
      );
    }

    return (
      <Header>
        <div className="page page__freeday">
          <Card>
            <h1>Freitage</h1>
            <table class="table table-hover">
              <thead>
                <tr>
                  <th>Datum Start</th>
                  <th>Datum Ende</th>
                  <th>Typ</th>
                  <th>Beschreibung</th>
                  <th />
                  <th />
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
