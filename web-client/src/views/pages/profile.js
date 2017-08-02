import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import InputField from '../tags/InputField';
import InputFieldWithHelpText from '../tags/InputFieldWithHelpText';
import InputCheckbox from '../tags/InputCheckbox';
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
    let howerText_BankName =
      'Name, Postleitzahl und Ort deiner Bank. Während der Eingabe werden dir Banken mit den entsprechenden Namen und aus den entsprechenden Ortschaften vorgeschlagen welche du auswählen kannst um automatisch die Clearing-Nr. und Postkonto-Nr. abfüllen zu lassen. Beispiel: Meine Bank, 8000 Zürich';

    axios
      .get(ApiService.BASE_URL + 'user' + (this.props.params.userid ? '/' + this.props.params.userid : ''), {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(function(response) {
        console.log('response ' + response.data);
        temp.push(
          <h3>Persönliche Informationen</h3>,
          <InputField id="zdp" label="ZDP" value={response.data.zdp} disabled="true" />,
          <InputField id="firstname" label="Vorname" value={response.data.first_name} />,
          <InputField id="lastname" label="Nachname" value={response.data.last_name} />,

          <InputField id="street" label="Strasse" value={response.data.address} />,
          <InputField id="zip" label="PLZ" value={response.data.zip} />,
          <InputField id="city" label="Ort" value={response.data.city} />,

          <InputField inputType="date" id="birthday" label="Geburtstag" value={response.data.birthday} />,
          <InputField id="hometown" label="Heimatort" value={response.data.hometown} />,

          <InputField inputType="email" id="email" label="E-Mail" value={response.data.email} />,
          <InputField inputType="tel" id="phoneM" label="Tel. Mobil" value={response.data.phone_mobile} />,
          <InputField inputType="tel" id="phoneP" label="Tel. Privat" value={response.data.phone_private} />,
          <InputField inputType="tel" id="phoneG" label="Tel. Geschäft" value={response.data.phone_business} />,

          <div class="form-group">
            <label class="control-label col-sm-3" for="hometown">
              Kanton
            </label>
            <div class="col-sm-9">
              <select id="hometown_canton" name="hometown_canton" class="form-control">
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
            </div>
          </div>,

          <hr />,
          <h3>Bank-/Postverbindung</h3>,

          <InputFieldWithHelpText id="bank_name" label="Bank Name" value={response.data.TODO} popoverText={howerText_BankName} />,
          <InputFieldWithHelpText id="iban" label="IBAN-Nr." value={response.data.TODO} popoverText={howerText_BankName} />,
          <InputFieldWithHelpText id="clearing" label="Clearing-Nr." value={response.data.TODO} popoverText={howerText_BankName} />,
          <InputFieldWithHelpText id="post_account" label="Postkonto-Nr." value={response.data.TODO} popoverText={howerText_BankName} />,

          <hr />,
          <h3>Krankenkasse</h3>,
          <InputField id="name" label="Name, Ort, PLZ" value={response.data.TODO} popoverText={howerText_BankName} />,
          <InputFieldWithHelpText
            id="insurance_nr"
            label="Versicherungs-Nr."
            value={response.data.TODO}
            popoverText={howerText_BankName}
          />,

          <hr />,
          <h3>Diverse Informationen</h3>,
          <div class="form-group">
            <label class="control-label col-sm-3" for="berufserfahrung">
              Berufserfahrung
            </label>
            <div class="col-sm-8">
              <textarea rows="4" id="berufserfahrung" name="berufserfahrung" class="form-control" />
            </div>
            <div id="_helpberufserfahrung" className="col-sm-1">
              <a href="#" data-toggle="popover" title="Berufserfahrung" data-content="Text TODO">
                <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true" />
              </a>
            </div>
          </div>,

          <div class="form-group">
            <label class="control-label col-sm-3" for="hometown">
              Regionalzentrum
            </label>
            <div class="col-sm-9">
              <select id="regionalzentrum" name="regionalzentrum" class="form-control">
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
            </div>
          </div>,

          <InputCheckbox id="driver_license" value={response.data.TODO} label="Führerausweis" />,
          <InputCheckbox id="ga" value={response.data.TODO} label="GA" />,
          <InputCheckbox id="reduced" value={response.data.TODO} label="Halbtax" />,
          <InputCheckbox id="local_abonnement" value={response.data.TODO} label="Lokales Abo" />,

          <div class="form-group">
            <label class="control-label col-sm-3" for="internal_comment">
              Int. Bemerkung
            </label>
            <div class="col-sm-9">
              <textarea rows="4" id="internal_comment" class="form-control" />
            </div>
          </div>
        );
        /*<tbody>
                    <tr>
                        <td colspan="2">ZDP:</td>
                        <td colspan="4">{response.data.zdp}</td>
                    </tr>
                    <tr>
                        <td colspan="6"><b>Persönliche Informationen</b></td>
                    </tr>
                    <tr>
                        <td colspan="2">Vorname:</td>
                        <td>
                            <input id="firstname" name="firstname" value={response.data.first_name} type="text" class="form-control"/>
                        </td>
                        <td colspan="2">Nachname:</td>
                        <td>
                            <input id="lastname" name="lastname" value={response.data.last_name} type="text" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">Strasse:</td>
                        <td colspan="4">
                            <input size="75" id="street" name="street" value={response.data.address} type="text" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">PLZ:</td>
                        <td>
                            <input id="zip" name="zip" value={response.data.zip} maxlength="4" type="text" class="form-control"/>
                        </td>
                        <td colspan="2">Ort:</td>
                        <td>
                            <input id="city" name="city" value={response.data.city} type="text" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">Geburtstag:</td>
                        <td>
                            <input id="dateofbirth" name="dateofbirth" value={response.data.birthday} type="text" class="form-control"/>
                        </td>
                        <td colspan="4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2">Tel. Mobil:</td>
                        <td>
                            <input id="phoneM" name="phoneM" value={response.data.phone_mobile} type="text" class="form-control"/>
                        </td>
                        <td colspan="2">Tel. Privat:</td>
                        <td>
                            <input id="phoneP" name="phoneP" value={response.data.phone_private} type="text" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">Tel. Geschäft:</td>
                        <td>
                            <input id="phoneG" name="phoneG" value={response.data.phone_business} type="text" class="form-control"/>
                        </td>
                        <td colspan="2">Email:</td>
                        <td>
                            <input id="email" name="email" value={response.data.email} type="text" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">Heimatort</td>
                        <td><input id="hometown" name="hometown" value={response.data.hometown} type="text" class="form-control"/></td>
                        <td>Kanton</td>
                        <td align="right">
                            <div id="help_hometown"><img src="NoSource" border="0" /></div>
                        </td>
                        <td>
                            <select id="hometown_canton" name="hometown_canton" class="form-control">
                                <option value=""></option>
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
                      <td colspan="6"><b>Bank-/Postverbindung</b></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="5">
                            <input id="account_type_bank" name="account_type" value={response.data.TODO} checked="checked" type="radio" class="form-control"/>Bank
                        </td>
                    </tr>
                    <tr>
                        <td>Name:</td>
                        <td align="right">
                            <div id="help_bank_name">
                                <a href="#" data-toggle="popover" title="Titel" data-content="Some content inside the popover">
                                    <span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span>
                                </a>
                            </div>
                        </td>
                        <td colspan="4">
                            <input id="bank_name" name="bank_name" size="75" autocomplete="off" value={response.data.TODO} type="text" class="form-control"/>
                                <div id="bank_choices" class="autocomplete" style="display: none;"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>Clearing-Nr.:</td>
                        <td align="right">
                            <div id="help_bank_clearing"><img src="NoSource" border="0" /></div>
                        </td>
                        <td><input id="bank_clearing" name="bank_clearing" value={response.data.TODO} type="text" class="form-control"/></td>
                        <td>Postkonto-Nr:</td>
                        <td align="right">
                            <div id="help_bank_post_account_no"><img src="NoSource" border="0" /></div>
                        </td>
                        <td><input id="bank_post_account_no" name="bank_post_account_no" value={response.data.TODO} type="text" class="form-control"/></td>
                    </tr>
                    <tr>
                        <td>IBAN-Nr.:</td>
                        <td align="right">
                            <div id="help_bank_account_no"><img src="NoSource" border="0" /></div>
                        </td>
                        <td colspan="4"><input size="75" id="bank_account_no" name="bank_account_no" value={response.data.TODO} type="text" class="form-control"/></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="5"><input id="account_type_post" name="account_type" value={response.data.TODO} type="radio" class="form-control"/>Post</td>
                    </tr>
                    <tr>
                        <td>Konto-Nr.:</td>
                        <td align="right">
                            <div id="help_post_account_no"><img src="NoSource" border="0" /></div>
                        </td>
                        <td colspan="4"><input size="75" id="post_account_no" name="post_account_no" value={response.data.TODO} disabled="" type="text" class="form-control"/></td>
                    </tr>
                    <tr>
                        <td colspan="6"><b>Krankenkasse</b></td>
                    </tr>
                    <tr>
                        <td>Name:</td>
                        <td align="right">
                            <div id="help_health_insurance"><img src="NoSource" border="0" /></div>
                        </td>
                        <td><input id="health_insurance" name="health_insurance" value={response.data.TODO} type="text" class="form-control"/></td>
                        <td>Versicherungs-Nr.:</td>
                        <td align="right">
                            <div id="help_health_insurance_no"><img src="NoSource" border="0" /></div>
                        </td>
                        <td><input id="health_insurance_no" name="health_insurance_no" value={response.data.TODO} type="text" class="form-control"/></td>
                    </tr>
                    <tr>
                        <td colspan="6"><b>Diverse Informationen</b></td>
                    </tr>
                    <tr>
                        <td valign="top">Berufserfahrung:</td>
                        <td valign="top" align="right">
                            <div id="help_berufserfahrung"><img src="NoSource" border="0" /></div>
                        </td>
                        <td colspan="4">
                            <textarea rows="4" cols="60" id="berufserfahrung" name="berufserfahrung" class="form-control"></textarea>
                        </td>
                    </tr>
                    <tr>
                    */

        /*

                        <td>Führerausweis:</td>
                        <td align="right">
                            <div id="help_fahrausweis"><img src="NoSource" border="0" /></div>
                        </td>
                        <td><input value={response.data.TODO} id="fahrausweis" name="fahrausweis" type="checkbox" class="form-control"/> Vorhanden</td>
                        <td colspan="2">Regionalstelle:</td>
                        <td>
                            <select id="regionalzentrum" name="regionalzentrum" class="form-control">
                                <option value="-1"></option>
                                <option value="1">Regionalzentrum Thun</option>
                                <option selected="" value="3">Regionalzentrum Rueti/ZH</option>
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
                            <div id="help_ga"><img src="NoSource" border="0" /></div>
                        </td>
                        <td><input value={response.data.TODO} id="ga" name="ga" type="checkbox" class="form-control"/> Vorhanden</td>
                        <td>Photo:</td>
                        <td align="right">
                            <div id="help_photo"><img src="NoSource" border="0" /></div>
                        </td>
                        <td>
                            <input name="MAX_FILE_SIZE" value="500000" type="hidden"/><input id="imgfile" name="imgfile" type="file" class="form-control"/>
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
                            <input value={response.data.TODO} id="halbtax" name="halbtax" type="checkbox" class="form-control"/> Vorhanden
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">Anderes Abo:</td>
                        <td>
                            <input id="anderesAbo" name="anderesAbo" value={response.data.TODO} type="text" class="form-control"/>
                        </td>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2">Int. Bemerkung:</td>
                        <td colspan="4">
                            <textarea rows="4" cols="55" id="bemerkung" name="bemerkung" class="form-control">{response.data.internal_note}</textarea>
                        </td>
                    </tr>
                </tbody>
            );*/
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
          <div class="container">
            <form class="form-horizontal">
              <hr />
              <button name="resetPassword" type="submit" class="btn btn-primary">
                Passwort zurücksetzen
              </button>
              <input name="id" value="00000" type="hidden" />
              <input name="action" value="saveEmployee" type="hidden" />
              <hr />

              {this.state.result}

              <button type="submit" class="btn btn-primary">
                Absenden
              </button>
            </form>
          </div>
        </Card>
      </div>
    );
  }
}
