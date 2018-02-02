import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import Component from 'inferno-component';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/InputFields/DatePicker';
import { apiURL } from '../../utils/api';

export default class UserPhoneList extends Component {
  constructor(props) {
    super(props);

    var date = new Date();
    var firstDay = new Date(date.getFullYear(), date.getMonth(), 1).toISOString();
    var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0).toISOString();

    this.state = {
      loading: false,
      lastDateValue: new Date(),
      start: firstDay,
      end: lastDay,
    };
  }

  handleDateChange(e, origin) {
    let value = e.target.value;

    if (value === undefined || value == null || value == '') {
      value = origin.state.lastDateValue;
    } else {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    origin.state[e.target.name] = value;
    origin.setState(this.state);
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

            <form action="javascript:;">
              <DatePicker id="start" label="Anfang:" value={this.state.start} callback={this.handleDateChange} callbackOrigin={this} />
              <DatePicker id="end" label="Ende:" value={this.state.end} callback={this.handleDateChange} callbackOrigin={this} />

              <a
                class="btn btn-primary"
                href={apiURL(
                  'pdf/phoneList',
                  {
                    start: this.state.start,
                    end: this.state.end,
                  },
                  true
                )}
                target="_blank"
              >
                Laden
              </a>
            </form>
          </Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
