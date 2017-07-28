import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';

export default class UserList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      users: [],
      zdp: '',
      name: '',
      start: '',
      end: '',
      group: 0,
    };
  }

  componentDidMount() {
    this.getUsers();
  }

  getUsers() {
    axios
      .get(ApiService.BASE_URL + 'user/zivi', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.setState({
          users: response.data.data.original,
        });
      })
      .catch(error => {
        console.log(error);
      });
  }

  handleChange(e) {
    switch (e.target.name) {
      case 'zdp':
        this.setState({ zdp: e.target.value });
        break;
      case 'name':
        this.setState({ name: e.target.value });
        break;
      case 'start':
        this.setState({ start: e.target.value });
        break;
      case 'end':
        this.setState({ end: e.target.value });
        break;
      case 'group':
        this.setState({ group: e.target.value });
        break;
      default:
        console.log('Element not found for setting.');
    }
  }

  deleteUser(user) {
    axios
      .delete(ApiService.BASE_URL + 'user/' + user.id, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.getUsers();
      })
      .catch(error => {
        console.log(error);
      });
  }

  render() {
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
      if (this.state.group != 0 && users[i].role_id != this.state.group) {
        continue;
      }

      temp.push(
        <tr>
          <td>{users[i].zdp}</td>
          <td>
            <a href={'/profile/' + users[i].id}>
              {users[i].first_name} {users[i].last_name}
            </a>
          </td>
          <td>{users[i].start}</td>
          <td>{users[i].end}</td>
          <td>{users[i].role}</td>
          <td>
            <a
              href={() => {
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
      <div className="page page__user_list">
        <Card>
          <h1>Benutzerliste</h1>
          <table class="table table-hover" cellspacing="0" cellpadding="2">
            <thead>
              <tr>
                <th>ZDP</th>
                <th>Vorname Name</th>
                <th>Start</th>
                <th>Ende</th>
                <th>Gruppe</th>
                <th />
              </tr>
              <tr>
                <td>
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
                  <input
                    class="SWOInput"
                    name="start"
                    size="10"
                    type="date"
                    value={this.state.start}
                    oninput={this.handleChange.bind(this)}
                  />
                </td>
                <td>
                  <input class="SWOInput" name="end" size="10" type="date" value={this.state.end} oninput={this.handleChange.bind(this)} />
                </td>
                <td>
                  <select name="group" value={this.state.group} oninput={this.handleChange.bind(this)}>
                    <option value="0">(Alle Gruppen)</option>
                    <option value="1">Admins</option>
                    <option value="2">Mitarbeiter</option>
                    <option value="3">Zivis</option>
                  </select>
                </td>
                <td />
              </tr>
            </thead>
            <tbody>{temp}</tbody>
          </table>
        </Card>
      </div>
    );
  }
}
