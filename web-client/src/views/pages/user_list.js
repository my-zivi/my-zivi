import Inferno from 'inferno';
import { Link } from 'inferno-router';
import ScrollableCard from '../tags/scrollableCard';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/DatePicker';
import Toast from '../../utils/toast';

export default class UserList extends Component {
  constructor(props) {
    super(props);

    var date = new Date();
    var firstDay = new Date('2000', date.getMonth(), 1).toISOString().slice(0, 10);
    var lastDay = new Date(date.getFullYear() + 5, date.getMonth(), 1).toISOString().slice(0, 10);

    this.state = {
      users: [],
      zdp: '',
      name: '',
      start: firstDay,
      end: lastDay,
      active: '',
      group: 0,
    };
  }

  componentDidMount() {
    this.getUsers();
    DatePicker.initializeDatePicker();
  }

  getUsers() {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'user/zivi', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.setState({
          users: response.data,
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

    value = value.slice(0, 10);
    console.log('value = ', value);

    origin.state[e.target.name] = value;
    origin.setState(this.state);
  }

  deleteUser(user) {
    axios
      .delete(ApiService.BASE_URL + 'user/' + user.id, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        Toast.showSuccess('Löschen erfolgreich', 'Benutzer wurde erfolgreich gelöscht');
        this.getUsers();
      })
      .catch(error => {
        Toast.showError('Löschen fehlgeschlagen', 'Benutzer konnte nicht gelöscht werden');
        //TODO ERROR Handling!!!
        //this.setState({error: error});
      });
  }

  render() {
    console.log('state start = ', this.state.start);
    var temp = [];
    var users = this.state.users;
    for (let i = 0; i < users.length; i++) {
      if (this.state.zdp != '' && !users[i].zdp.startsWith(this.state.zdp)) {
        continue;
      }
      if (
        this.state.name != '' &&
        (users[i].first_name + ' ' + users[i].last_name).toLowerCase().indexOf(this.state.name.toLowerCase()) == -1
      ) {
        continue;
      }
      if (this.state.start != '' && users[i].end < this.state.start) {
        continue;
      }
      if (this.state.end != '' && users[i].start > this.state.end) {
        continue;
      }
      if (
        this.state.active &&
        (users[i].start == null ||
          users[i].end < new Date().toISOString().slice(0, 10) ||
          users[i].start > new Date().toISOString().slice(0, 10))
      ) {
        continue;
      }
      if (this.state.group != 0 && users[i].role_id != this.state.group) {
        continue;
      }

      temp.push(
        <tr>
          <td className="hidden-xs">{users[i].zdp}</td>
          <td>
            <a href={'/profile/' + users[i].id}>
              {users[i].first_name} {users[i].last_name}
            </a>
          </td>
          <td>{users[i].start}</td>
          <td>{users[i].end}</td>
          <td className="hidden-xs">{users[i].active}</td>
          <td className="hidden-xs">{users[i].role}</td>
          <td className="hidden-xs">
            <a
              onclick={() => {
                if (confirm('Möchten Sie ' + users[i].first_name + ' ' + users[i].last_name + ' wirklich löschen?')) {
                  this.deleteUser(users[i]);
                }
              }}
            >
              Löschen
            </a>
          </td>
        </tr>
      );
    }

    return (
      <Header>
        <div className="page page__user_list">
          <ScrollableCard>
            <h1>Benutzerliste</h1>
            <table class="table table-hover" cellspacing="0" cellpadding="2">
              <thead>
                <tr>
                  <th className="hidden-xs">ZDP</th>
                  <th>Vorname Name</th>
                  <th>Start</th>
                  <th>Ende</th>
                  <th className="hidden-xs">Aktiv?</th>
                  <th className="hidden-xs">Gruppe</th>
                  <th className="hidden-xs" />
                </tr>
                <tr>
                  <td className="hidden-xs">
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
                    <DatePicker
                      class="SWOInput"
                      id="start"
                      value={this.state.start}
                      callback={this.handleDateChange}
                      callbackOrigin={this}
                    />
                  </td>
                  <td>
                    <DatePicker class="SWOInput" id="end" value={this.state.end} callback={this.handleDateChange} callbackOrigin={this} />
                  </td>
                  <td className="hidden-xs">
                    <input
                      class="SWOInput"
                      name="active"
                      type="checkbox"
                      value={this.state.active}
                      onchange={this.handleChange.bind(this)}
                    />
                  </td>
                  <td className="hidden-xs">
                    <select name="group" value={this.state.group} oninput={this.handleChange.bind(this)}>
                      <option value="0">(Alle Gruppen)</option>
                      <option value="1">Admins</option>
                      <option value="2">Mitarbeiter</option>
                      <option value="3">Zivis</option>
                    </select>
                  </td>
                  <td className="hidden-xs" />
                </tr>
              </thead>
              <tbody>{temp}</tbody>
            </table>
          </ScrollableCard>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
