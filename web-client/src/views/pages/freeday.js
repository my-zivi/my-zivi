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

  render() {
    var tbody = [];

    var freedays = this.state.freedays;
    for (let i = 0; i < freedays.length; i++) {
      tbody.push(
        <tr>
          <td>
            <input class="form-control" type="date" value={freedays[i].date_from} />
          </td>
          <td>
            <input class="form-control" type="date" value={freedays[i].date_to} />
          </td>
          <td>
            <select class="form-control" value={'' + freedays[i].holiday_type}>
              <option value="2">Feiertag</option>
              <option value="1">Betriebsferien</option>
            </select>
          </td>
          <td>
            <input class="form-control" type="text" value={freedays[i].description} />
          </td>
          <td>
            <a>speichern</a>
          </td>
          <td>
            <a>löschen</a>
          </td>
        </tr>
      );
    }

    return (
      <Header>
        <div className="page page__freeday">
          <Card>
            <h1>Freitage</h1>
            <button class="btn btn-primary">Neuer Eintrag</button>
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
