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
    };
  }

  componentDidMount() {
    this.getUsers();
  }

  getUsers() {
    let temp = [];
    let self = this;
    axios
      .get(ApiService.BASE_URL + 'user/zivi', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(function(response) {
        self.setState({
          users: response.data.data.original,
        });
      })
      .catch(function(error) {
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
      default:
        console.log('Element not found for setting.');
    }
  }

  render() {
    var temp = [];
    var users = this.state.users;
    var even = true;
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

      temp.push(
        <tr class={even ? 'teven' : 'todd'}>
          <td>{users[i].zdp}</td>
          <td>
            <a href={'/profile/' + users[i].id}>
              {users[i].first_name} {users[i].last_name}
            </a>
          </td>
          <td>{users[i].start}</td>
          <td>{users[i].end}</td>
          <td>
            <button type="button">Löschen</button>
          </td>
          <td>{users[i].role}</td>
        </tr>
      );

      even = !even;
    }

    return (
      <div className="page page__user_list">
        <Card>
          <h1>Benutzerliste</h1>
          <table class="table" cellspacing="0" cellpadding="2">
            <tr>
              <th>ZDP</th>
              <th>Vorname Name</th>
              <th>Start</th>
              <th>Ende</th>
              <th />
              <th>Gruppe</th>
            </tr>
            <tr>
              <td>
                <input class="SWOInput" name="zdp" size="4" type="text" value={this.state.zdp} oninput={this.handleChange.bind(this)} />
              </td>
              <td>
                <input class="SWOInput" name="name" size="15" type="text" value={this.state.name} oninput={this.handleChange.bind(this)} />
              </td>
              <td>
                <input
                  class="SWOInput"
                  name="start"
                  size="10"
                  type="text"
                  value={this.state.start}
                  oninput={this.handleChange.bind(this)}
                />
              </td>
              <td>
                <input class="SWOInput" name="end" size="10" type="text" value={this.state.end} oninput={this.handleChange.bind(this)} />
              </td>
              <td />
              <td>
                <select name="groupid">
                  <option value="0">(Alle Gruppen)</option>
                  <option value="1">Admins</option>
                  <option value="2">Mitarbeiter</option>
                  <option value="3">Zivis</option>
                </select>
              </td>
              <td width="100" valign="top" align="right" />
            </tr>
            {temp}
          </table>
        </Card>
      </div>
    );
  }
}
