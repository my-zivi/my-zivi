import { Component } from 'inferno';
import ScrollableCard from '../tags/scrollableCard';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/InputFields/DatePicker';
import Toast from '../../utils/toast';
import { api } from '../../utils/api';
import update from 'immutability-helper';

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
    api()
      .get('holiday')
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

    //this.state['freedays'][i][e.target.name] = value;
    this.setState({ freedays: update(this.state.freedays, { [i]: { [e.target.name]: { $set: value } } }) });
  }

  handleChangeNew(e) {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.setState({
      newFreeday: {
        ...this.state.newFreeday,
        [e.target.name]: value,
      },
    });
  }

  handleNewDateChange(e) {
    let value = e.target.value;

    if (value === undefined || value == null || value == '') {
      value = this.state.lastDateValue;
    } else {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    this.setState({
      newFreeday: {
        ...this.state.newFreeday,
        [e.target.name]: value,
      },
    });
  }

  handleDateChange(e, index) {
    let value = e.target.value;

    if (value === undefined || value == null || value == '') {
      value = this.state.lastDateValue;
    } else {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    //origin.state['freedays'][index][e.target.name] = value;
    this.setState({
      freedays: update(this.state.freedays, { [index]: { [e.target.name]: { $set: value } } }),
    });
  }

  save(i) {
    this.setState({ loading: true, error: null });
    api()
      .post('holiday/' + this.state.freedays[i].id, this.state.freedays[i])
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
    api()
      .delete('holiday/' + this.state.freedays[i].id)
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
    api()
      .put('holiday', this.state.newFreeday)
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
            onChange={this.handleNewDateChange.bind(this)}
            showLabel={false}
          />
        </td>
        <td>
          <DatePicker id="date_to" value={this.state.newFreeday.date_to} onChange={this.handleNewDateChange.bind(this)} showLabel={false} />
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
              onChange={e => this.handleDateChange(e, i)}
              showLabel={false}
            />
          </td>
          <td>
            <DatePicker id="date_to" value={this.state.freedays[i].date_to} onChange={e => this.handleDateChange(e, i)} showLabel={false} />
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
