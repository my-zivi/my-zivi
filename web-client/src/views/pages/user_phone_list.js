import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

export default class UserPhoneList extends Component {
  constructor(props) {
    super(props);

    this.state = { loading: false };
  }

  getList() {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'pdf/phoneList?start=' + this.state.start + '&end=' + this.state.end, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
        responseType: 'blob',
      })
      .then(response => {
        this.setState({ loading: false });
        let blob = new Blob([response.data], { type: 'application/pdf' });
        window.location = window.URL.createObjectURL(blob);
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChange(e) {
    this.state[e.target.name] = e.target.value;
    this.setState(this.state);
  }

  render() {
    return (
      <Header>
        <div className="page page__user_phone_list">
          <Card>
            <h1>Telefonliste</h1>
            <p>
              Geben Sie ein Anfangsdatum und ein Enddatum ein um eine Telefonliste mit allen Zivis zu erhalten, die in diesem Zeitraum
              arbeiten.
            </p>

            <form
              action="javascript:;"
              onSubmit={() => {
                this.getList();
              }}
            >
              <div class="form-group">
                <label for="start">Anfang:</label>
                <input
                  type="date"
                  class="form-control"
                  name="start"
                  id="start"
                  value={this.state.start}
                  onChange={this.handleChange.bind(this)}
                  required
                />
              </div>
              <div class="form-group">
                <label for="email">Ende:</label>
                <input
                  type="date"
                  class="form-control"
                  name="end"
                  id="end"
                  value={this.state.end}
                  onChange={this.handleChange.bind(this)}
                  required
                />
              </div>

              <button class="btn btn-primary" type="submit">
                Absenden
              </button>
            </form>
          </Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
