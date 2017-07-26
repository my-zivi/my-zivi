import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';

const inputEmail = 'else@48026.no';
const inputPassword = '1234';

export default class UserList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      result: [],
    };
  }

  componentDidMount() {
    this.getUsers();
  }

  getUsers() {
    let temp = [];
    let self = this;
    axios
      .get('http://localhost/api/user/zivi', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(function(response) {
        console.log('response ' + response);
        let users = response.data.data.original;
        for (let i = 0; i < users.length; i++) {
          if (i % 2 == 1) {
            temp.push(
              <tr class="todd">
                <td>{users[i].zdp}</td>
                <td>
                  <a href="/profile">
                    {users[i].first_name} {users[i].last_name}
                  </a>
                </td>
                <td>{users[i].start}</td>
                <td>{users[i].end}</td>
                <td> </td>
                <td>
                  <button type="button">Löschen</button>
                </td>
                <td>
                  <a href="/profile">{users[i].role}</a>
                </td>
              </tr>
            );
          } else {
            temp.push(
              <tr class="teven">
                <td>{users[i].zdp}</td>
                <td>
                  <a href="/profile">
                    {users[i].first_name} {users[i].last_name}
                  </a>
                </td>
                <td>{users[i].start}</td>
                <td>{users[i].end}</td>
                <td> </td>
                <td>
                  <button type="button">Löschen</button>
                </td>
                <td>
                  <a href="/profile">{users[i].role}</a>
                </td>
              </tr>
            );
          }
        }
      })
      .then(function(response) {
        self.setState({
          result: temp,
        });
      })
      .catch(function(error) {
        console.log(error);
      });
  }

  render() {
    return (
      <div className="page page__user_list">
        <Card>
          <h1>Benutzerliste</h1>
        </Card>
        <table class="table" cellspacing="0" cellpadding="2">
          <tr>
            <th>ZDP</th>
            <th>Vorname Name</th>
            <th>Start</th>
            <th>Ende</th>
            <th>Qualifikation</th>
            <th>Aktiv?</th>
            <th>Gruppe</th>
          </tr>
          <tr>
            <td>
              <input class="SWOInput" name="username" size="4" value="" type="text" />
            </td>
            <td>
              <input class="SWOInput" name="name" size="15" value="" type="text" />
            </td>
            <td>
              <input class="SWOInput" name="start" size="10" value="" type="text" />
            </td>
            <td>
              <input class="SWOInput" name="end" size="10" value="" type="text" />
            </td>
            <td />
            <td>
              <input class="" name="search_active" value="1" type="checkbox" />
            </td>
            <td>
              <select name="groupid">
                <option value="0">(Alle Gruppen)</option>
                <option value="1">Admins</option>
                <option value="2">Mitarbeiter</option>
                <option value="3">Zivis</option>
              </select>
            </td>
            <td width="100" valign="top" align="right">
              <button type="button">Suchen</button>
            </td>
          </tr>
          {this.state.result}
        </table>
      </div>
    );
  }
}
