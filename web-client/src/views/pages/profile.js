import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import InputField from '../tags/InputField';
import InputFieldWithHelpText from '../tags/InputFieldWithHelpText';
import InputCheckbox from '../tags/InputCheckbox';
import DatePicker from '../tags/DatePicker';
import Cantons from '../tags/Cantons';
import RegionalCenters from '../tags/RegionalCenters';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

export default class User extends Component {
  constructor(props, { router }) {
    super(props);

    this.state = {
      result: [],
      cantons: [],
      regianlCenters: [],
    };

    this.cantonTag = new Cantons();
    this.regionalCenterTag = new RegionalCenters();
    this.router = router;
  }

  componentDidMount() {
    this.getUser();
    this.cantonTag.getCantons(this);
    this.regionalCenterTag.getRegionalCenters(this);
  }

  componentWillReceiveProps(nextProps) {
    this.props = nextProps;
    this.componentDidMount();
  }

  getUser() {
    this.setState({ loading: true, error: null });

    axios
      .get(ApiService.BASE_URL + 'user' + (this.props.params.userid ? '/' + this.props.params.userid : ''), {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({
          result: response.data,
          loading: false,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChange(e) {
    let value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.state['result'][e.target.name] = value;
    this.setState(this.state);
  }

  handleDateChange(e, origin) {
    let value = DatePicker.dateFormat_CH2EN(e.target.value);

    origin.state['result'][e.target.name] = value;
    origin.setState(this.state);
  }

  handleSelectChange(e) {
    var targetSelect = document.getElementById(e.target.id);
    let value = targetSelect.options[targetSelect.selectedIndex].value;
    this.state['result'][e.target.name] = value;
    this.setState(this.state);
  }

  handleTextareaChange(e) {
    let value = document.getElementById(e.target.id).value;
    this.state['result'][e.target.name] = value;
    this.setState(this.state);
  }

  save() {
    this.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'user/' + this.state.result.id, this.state.result, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({ loading: false });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  redirectToChangePassword(e) {
    this.router.push('/changePassword');
  }

  render() {
    let result = this.state.result;
    let howerText_IBAN = 'IBAN nummer';
    let howerText_Post = 'Postkonto Nummer';
    let howerText_Berufserfahrung =
      'Wir profitieren gerne von deiner Erfahrung. Wenn wir genau wissen, wann wer mit welchen Erfahrungen einen Einsatz tätigt, können wir z.T. Projekte speziell planen.';

    return (
      <Header>
        <div className="page page__user_list">
          <Card>
            <h1>Profil</h1>
            <div class="container">
              <form class="form-horizontal">
                <hr />
                {this.passwordChangeButton()}
                <input name="id" value="00000" type="hidden" />
                <input name="action" value="saveEmployee" type="hidden" />

                <h3>Persönliche Informationen</h3>
                <InputField id="zdp" label="ZDP" value={result.zdp} disabled="true" />
                <InputField id="first_name" label="Vorname" value={result.first_name} self={this} />
                <InputField id="last_name" label="Nachname" value={result.last_name} self={this} />

                <InputField id="address" label="Strasse" value={result.address} self={this} />
                <InputField id="city" label="Ort" value={result.city} self={this} />
                <InputField id="zip" label="PLZ" value={result.zip} self={this} />

                <DatePicker
                  id="birthday"
                  label="Geburtstag"
                  value={result.birthday}
                  callback={this.handleDateChange}
                  callbackOrigin={this}
                />

                <InputField id="hometown" label="Heimatort" value={result.hometown} self={this} />

                <InputField inputType="email" id="email" label="E-Mail" value={result.email} self={this} />
                <InputField inputType="tel" id="phone_mobile" label="Tel. Mobil" value={result.phone_mobile} self={this} />
                <InputField inputType="tel" id="phone_private" label="Tel. Privat" value={result.phone_private} self={this} />
                <InputField inputType="tel" id="phone_business" label="Tel. Geschäft" value={result.phone_business} self={this} />

                <div class="form-group">
                  <label class="control-label col-sm-3" for="canton">
                    Kanton
                  </label>
                  <div class="col-sm-9">
                    <select id="canton" name="canton" class="form-control" onChange={e => this.handleSelectChange(e)}>
                      {this.cantonTag.renderCantons(this.state)}
                    </select>
                  </div>
                </div>

                <hr />
                <h3>Bank-/Postverbindung</h3>
                <InputFieldWithHelpText id="bank_iban" label="IBAN-Nr." value={result.bank_iban} popoverText={howerText_IBAN} self={this} />
                <InputFieldWithHelpText
                  id="post_account"
                  label="Postkonto-Nr."
                  value={result.post_account}
                  popoverText={howerText_Post}
                  self={this}
                />

                <hr />
                <h3>Diverse Informationen</h3>
                <div class="form-group">
                  <label class="control-label col-sm-3" for="berufserfahrung">
                    Berufserfahrung
                  </label>
                  <div class="col-sm-8">
                    <textarea
                      rows="4"
                      id="work_experience"
                      name="work_experience"
                      class="form-control"
                      onChange={e => this.handleTextareaChange(e)}
                    >
                      {result.work_experience}
                    </textarea>
                  </div>
                  <div id="_helpberufserfahrung" className="col-sm-1">
                    <a href="#" data-toggle="popover" title="Berufserfahrung" data-content={howerText_Berufserfahrung}>
                      <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true" />
                    </a>
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-3" for="hometown">
                    Regionalzentrum
                  </label>
                  <div class="col-sm-9">
                    <select id="regional_center" name="regional_center" class="form-control" onChange={e => this.handleSelectChange(e)}>
                      {this.regionalCenterTag.renderRegionalCenters(this.state)}
                    </select>
                  </div>
                </div>

                <InputCheckbox id="driving_licence" value={result.driving_licence} label="Führerausweis" self={this} />
                <InputCheckbox id="travel_card" value={result.travel_card} label="GA" self={this} />

                <div class="form-group">
                  <label class="control-label col-sm-3" for="internal_comment">
                    Int. Bemerkung
                  </label>
                  <div class="col-sm-9">
                    <textarea
                      rows="4"
                      id="internal_note"
                      name="internal_note"
                      class="form-control"
                      onChange={e => this.handleTextareaChange(e)}
                    >
                      {result.internal_note}
                    </textarea>
                  </div>
                </div>

                <button
                  type="submit"
                  class="btn btn-primary"
                  onclick={() => {
                    this.save();
                  }}
                >
                  Absenden
                </button>
              </form>
            </div>
          </Card>
          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }

  componentDidUpdate() {
    DatePicker.initializeDatePicker();
  }

  passwordChangeButton() {
    if (!this.props.params.userid) {
      return (
        <div>
          <button name="resetPassword" class="btn btn-primary" onClick={e => this.redirectToChangePassword(e)}>
            Passwort ändern
          </button>
          <hr />
        </div>
      );
    }
    return;
  }
}
