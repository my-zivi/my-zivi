import {Component} from 'inferno';
import ScrollableCard from '../tags/scrollableCard';
import axios from 'axios';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/InputFields/DatePicker';
import Toast from '../../utils/toast';

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

  handleChangeNew(e) {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.state['newFreeday'][e.target.name] = value;
    this.setState(this.state);
  }

  handleNewDateChange(e, origin) {
    let value = e.target.value;

    if (value === undefined || value == null || value == '') {
      value = origin.state.lastDateValue;
    } else {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    origin.state['newFreeday'][e.target.name] = value;
    origin.setState(this.state);
  }

  handleDateChange(e, origin, index) {
    let value = e.target.value;

    if (value === undefined || value == null || value == '') {
      value = origin.state.lastDateValue;
    } else {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    origin.state['freedays'][index][e.target.name] = value;
    origin.setState(this.state);
  }

  save(i) {
    this.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'holiday/' + this.state.freedays[i].id, this.state.freedays[i], {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        Toast.showSuccess('Speichern erfolgreich', 'Frei-Tag wurde erfolgreich gespeichert');
        this.setState({ loading: false });
      })
      .catch(error => {
        Toast.showError('Speichern fehlgeschlagen', 'Frei-Tag konnte nicht gespeicher werden', error, this.context);
        this.setState({ loading: false });
      });
  }

  remove(i) {
    this.setState({ loading: true, error: null });
    axios
      .delete(ApiService.BASE_URL + 'holiday/' + this.state.freedays[i].id, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        Toast.showSuccess('Löschen erfolgreich', 'Frei-Tag wurde erfolgreich gelöscht');
        this.getFreedays();
      })
      .catch(error => {
        Toast.showError('Löschen fehlgeschlagen', 'Frei-Tag konnte nicht gelöscht werden', error, this.context);
        this.setState({ loading: false });
      });
  }

  add() {
    this.setState({ loading: true, error: null });
    axios
      .put(ApiService.BASE_URL + 'holiday', this.state.newFreeday, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        Toast.showSuccess('Hinzufügen erfolgreich', 'Frei-Tag wurde erfolgreich hinzugefügt');
        this.setState({ newFreeday: { holiday_type: 2, description: '' } });
        this.getFreedays();
      })
      .catch(error => {
        Toast.showError('Hinzufügen fehlgeschlagen', 'Frei-Tag konnte nicht hinzugefügt werden', error, this.context);
        this.setState({ loading: false });
      });
  }

  render() {
    var tbody = [];

    tbody.push(
      <tr>
        <td>
          <DatePicker
            id="date_from"
            value={this.state.newFreeday.date_from}
            callback={this.handleNewDateChange}
            callbackOrigin={this}
            showLabel={false}
          />
        </td>
        <td>
          <DatePicker
            id="date_to"
            value={this.state.newFreeday.date_to}
            callback={this.handleNewDateChange}
            callbackOrigin={this}
            showLabel={false}
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
            onInput={e => this.handleChangeNew(e)}
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
            <DatePicker
              id="date_from"
              value={this.state.freedays[i].date_from}
              callback={(e, origin) => this.handleDateChange(e, origin, i)}
              callbackOrigin={this}
              showLabel={false}
            />
          </td>
          <td>
            <DatePicker
              id="date_to"
              value={this.state.freedays[i].date_to}
              callback={(e, origin) => this.handleDateChange(e, origin, i)}
              callbackOrigin={this}
              showLabel={false}
            />
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
              onInput={e => this.handleChange(e, i)}
            />
          </td>
          <td>
            {this.state.freedays[i].date_from > new Date().toISOString() ? (
              <button type="button" class="btn btn-sm" onClick={() => this.save(i)}>
                speichern
              </button>
            ) : null}
          </td>
          <td>
            {this.state.freedays[i].date_from > new Date().toISOString() ? (
              <button
                class="btn btn-sm"
                onClick={() => {
                  if (window.confirm('Möchten Sie ' + freedays[i].description + ' wirklich löschen?')) {
                    this.remove(i);
                  }
                }}
              >
                löschen
              </button>
            ) : null}
          </td>
        </tr>
      );
    }

    return (
      <Header>
        <div className="page page__freeday">
          <ScrollableCard>
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
          </ScrollableCard>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
