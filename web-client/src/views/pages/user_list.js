import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';

const inputEmail = 'else@48026.no';
const inputPassword = '1234';

export default function(props) {
  const test = () => {
    let result = [];
    let users = getUsers();
    console.log(users);
    for (let i = 0; i < users.length(); i++) {
      result.push(
        <tr>
          <td>users[i].zdp</td>
          <td>users[i].first_name + " " + users[i].last_name</td>
          <td>users[i].zdp</td>
          <td>users[i].zdp</td>
          <td>users[i].zdp</td>
        </tr>
      );
    }
    return result;
  };

  function getUsers() {
    console.log('Hello');
    console.log(localStorage.getItem('jwtToken'));
    axios
      .get('http://localhost/api/user/zivi', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(function(response) {
        return response.data;
      })
      .catch(function(error) {
        console.log(error);
      });
  }

  return (
    <div className="page page__user_list">
      <Card>
        <h1>Benutzerliste</h1>
      </Card>
      <table>
        <tr>
          <th>ZDP</th>
          <th>Vorname Name</th>
          <th>Start</th>
          <th>Ende</th>
          <th>Qualifikation</th>
          <th>Aktiv?</th>
          <th>Gruppe</th>
        </tr>
        {test()}
      </table>
    </div>
  );
}
