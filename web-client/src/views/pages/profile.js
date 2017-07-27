import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';

export default class User extends Component {
  constructor(props) {
    super(props);

    this.state = {
      result: [],
    };
  }

  componentDidMount() {
    this.getUser();
  }

  getUser() {
    let temp = [];
    let self = this;
    axios
      .get(ApiService.BASE_URL + 'user' + (this.props.params.userid ? '/' + this.props.params.userid : ''), {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(function(response) {
        console.log('response ' + response.data);
        temp.push(
          <tbody>
            <tr>
              <td colspan="2">ZDP:</td>
              <td colspan="4">{response.data.zdp}</td>
            </tr>
            <tr>
              <td colspan="6">
                <b>Persönliche Informationen</b>
              </td>
            </tr>
            <tr>
              <td colspan="2">Vorname:</td>
              <td>
                <input class="SWOInput" size="20" id="firstname" name="firstname" value={response.data.first_name} type="text" />
              </td>
              <td colspan="2">Nachname:</td>
              <td>
                <input class="SWOInput" size="20" id="lastname" name="lastname" value={response.data.last_name} type="text" />
              </td>
            </tr>
            <tr>
              <td colspan="2">Strasse:</td>
              <td colspan="4">
                <input class="SWOInput" size="75" id="street" name="street" value={response.data.address} type="text" />
              </td>
            </tr>
            <tr>
              <td colspan="2">PLZ:</td>
              <td>
                <input class="SWOInput" size="20" id="zip" name="zip" value={response.data.zip} maxlength="4" type="text" />
              </td>
              <td colspan="2">Ort:</td>
              <td>
                <input class="SWOInput" size="20" id="city" name="city" value={response.data.city} type="text" />
              </td>
            </tr>
            <tr>
              <td colspan="2">Geburtstag:</td>
              <td>
                <input class="SWOInput" size="20" id="dateofbirth" name="dateofbirth" value={response.data.birthday} type="text" />
              </td>
              <td colspan="4">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="2">Tel. Mobil:</td>
              <td>
                <input class="SWOInput" size="20" id="phoneM" name="phoneM" value={response.data.phone_mobile} type="text" />
              </td>
              <td colspan="2">Tel. Privat:</td>
              <td>
                <input class="SWOInput" size="20" id="phoneP" name="phoneP" value={response.data.phone_private} type="text" />
              </td>
            </tr>
            <tr>
              <td colspan="2">Tel. Geschäft:</td>
              <td>
                <input class="SWOInput" size="20" id="phoneG" name="phoneG" value={response.data.phone_business} type="text" />
              </td>
              <td colspan="2">Email:</td>
              <td>
                <input class="SWOInput" size="20" id="email" name="email" value={response.data.email} type="text" />
              </td>
            </tr>
            <tr>
              <td colspan="2">Heimatort</td>
              <td>
                <input class="SWOInput" size="20" id="hometown" name="hometown" value={response.data.hometown} type="text" />
              </td>
              <td>Kanton</td>
              <td align="right">
                <div id="help_hometown">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <select id="hometown_canton" name="hometown_canton">
                  <option value="" />
                  <option value="AG">AG</option>
                  <option value="AI">AI</option>
                  <option value="AR">AR</option>
                  <option value="BL">BL</option>
                  <option value="BS">BS</option>
                  <option value="BE">BE</option>
                  <option value="FR">FR</option>
                  <option value="GE">GE</option>
                  <option value="GL">GL</option>
                  <option value="GR">GR</option>
                  <option value="JU">JU</option>
                  <option value="LU">LU</option>
                  <option value="NE">NE</option>
                  <option value="NW">NW</option>
                  <option value="OW">OW</option>
                  <option value="SH">SH</option>
                  <option value="SZ">SZ</option>
                  <option value="SG">SG</option>
                  <option value="SO">SO</option>
                  <option value="TI">TI</option>
                  <option value="TG">TG</option>
                  <option value="UR">UR</option>
                  <option value="VD">VD</option>
                  <option value="VS">VS</option>
                  <option value="ZG">ZG</option>
                  <option value="ZH">ZH</option>
                </select>
              </td>
            </tr>
            <tr>
              <td colspan="6">
                <b>Bank-/Postverbindung</b>
              </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td colspan="5">
                <input
                  class="SWOInput"
                  id="account_type_bank"
                  name="account_type"
                  value={response.data.TODO}
                  checked="checked"
                  type="radio"
                />Bank
              </td>
            </tr>
            <tr>
              <td>Name:</td>
              <td align="right">
                <div id="help_bank_name">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td colspan="4">
                <input
                  id="bank_name"
                  name="bank_name"
                  class="SWOInput"
                  size="75"
                  autocomplete="off"
                  value={response.data.TODO}
                  type="text"
                />
                <div id="bank_choices" class="autocomplete" style="display: none;" />
              </td>
            </tr>
            <tr>
              <td>Clearing-Nr.:</td>
              <td align="right">
                <div id="help_bank_clearing">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <input class="SWOInput" size="20" id="bank_clearing" name="bank_clearing" value={response.data.TODO} type="text" />
              </td>
              <td>Postkonto-Nr:</td>
              <td align="right">
                <div id="help_bank_post_account_no">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <input
                  class="SWOInput"
                  size="20"
                  id="bank_post_account_no"
                  name="bank_post_account_no"
                  value={response.data.TODO}
                  type="text"
                />
              </td>
            </tr>
            <tr>
              <td>IBAN-Nr.:</td>
              <td align="right">
                <div id="help_bank_account_no">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td colspan="4">
                <input class="SWOInput" size="75" id="bank_account_no" name="bank_account_no" value={response.data.TODO} type="text" />
              </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td colspan="5">
                <input class="SWOInput" id="account_type_post" name="account_type" value={response.data.TODO} type="radio" />Post
              </td>
            </tr>
            <tr>
              <td>Konto-Nr.:</td>
              <td align="right">
                <div id="help_post_account_no">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td colspan="4">
                <input
                  class="SWOInput"
                  size="75"
                  id="post_account_no"
                  name="post_account_no"
                  value={response.data.TODO}
                  disabled=""
                  type="text"
                />
              </td>
            </tr>
            <tr>
              <td colspan="6">
                <b>Krankenkasse</b>
              </td>
            </tr>
            <tr>
              <td>Name:</td>
              <td align="right">
                <div id="help_health_insurance">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <input class="SWOInput" size="20" id="health_insurance" name="health_insurance" value={response.data.TODO} type="text" />
              </td>
              <td>Versicherungs-Nr.:</td>
              <td align="right">
                <div id="help_health_insurance_no">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <input
                  class="SWOInput"
                  size="20"
                  id="health_insurance_no"
                  name="health_insurance_no"
                  value={response.data.TODO}
                  type="text"
                />
              </td>
            </tr>
            <tr>
              <td colspan="6">
                <b>Diverse Informationen</b>
              </td>
            </tr>
            <tr>
              <td valign="top">Berufserfahrung:</td>
              <td valign="top" align="right">
                <div id="help_berufserfahrung">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td colspan="4">
                <textarea rows="4" cols="60" class="SWOInput" id="berufserfahrung" name="berufserfahrung" />
              </td>
            </tr>
            <tr>
              <td>Führerausweis:</td>
              <td align="right">
                <div id="help_fahrausweis">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <input value={response.data.TODO} id="fahrausweis" name="fahrausweis" type="checkbox" /> Vorhanden
              </td>
              <td colspan="2">Regionalstelle:</td>
              <td>
                <select id="regionalzentrum" name="regionalzentrum">
                  <option value="-1" />
                  <option value="1">Regionalzentrum Thun</option>
                  <option selected="" value="3">
                    Regionalzentrum Rueti/ZH
                  </option>
                  <option value="4">Regionalzentrum Luzern</option>
                  <option value="6">Centre regional Lausanne</option>
                  <option value="7">Regionalzentrum Rivera</option>
                  <option value="8">Regionalzentrum Aarau</option>
                </select>
              </td>
            </tr>
            <tr>
              <td>GA:</td>
              <td align="right">
                <div id="help_ga">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <input value={response.data.TODO} id="ga" name="ga" type="checkbox" /> Vorhanden
              </td>
              <td>Photo:</td>
              <td align="right">
                <div id="help_photo">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <input name="MAX_FILE_SIZE" value="500000" type="hidden" />
                <input id="imgfile" name="imgfile" type="file" />
              </td>
            </tr>
            <tr>
              <td>Halbtax Abo:</td>
              <td align="right">
                <div id="help_halbtax">
                  <img src="NoSource" border="0" />
                </div>
              </td>
              <td>
                <input value={response.data.TODO} id="halbtax" name="halbtax" type="checkbox" /> Vorhanden
              </td>
              <td colspan="2">Ferien:</td>
              <td>
                <input value={response.data.TODO} id="hatFerien" name="hatFerien" type="checkbox" /> Hat Ferien zugute
              </td>
            </tr>
            <tr>
              <td colspan="2">Anderes Abo:</td>
              <td>
                <input class="SWOInput" size="20" id="anderesAbo" name="anderesAbo" value={response.data.TODO} type="text" />
              </td>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="2">Int. Bemerkung:</td>
              <td colspan="4">
                <textarea rows="4" cols="55" class="SWOInput" id="bemerkung" name="bemerkung">
                  {response.data.internal_note}
                </textarea>
              </td>
            </tr>
          </tbody>
        );
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
          <h1>Profil</h1>
          <input class="SWOButton" name="resetPassword" value="Passwort zurücksetzen" type="submit" />
          <table class="table" cellpadding="30">
            <tbody>
              <tr>
                <td>
                  <input name="id" value="00000" type="hidden" />
                  <input name="action" value="saveEmployee" type="hidden" />
                  <table>
                    <colgroup>
                      <col width="140" />
                      <col width="20" />
                      <col width="160" />
                      <col width="140" />
                      <col width="20" />
                      <col width="160" />
                    </colgroup>

                    {this.state.result}
                  </table>
                  <br />
                  <input class="SWOButton" value="Daten speichern" type="submit" />
                </td>
              </tr>
            </tbody>
          </table>
        </Card>
      </div>
    );
  }
}
