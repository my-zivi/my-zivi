import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/DatePicker';

export default class EditExpense extends Component {
  constructor(props) {
    super(props);

    this.state = {
      report_sheet: null,
    };
  }

  componentDidMount() {
    this.getReportSheet();
  }

  componentDidUpdate() {
    DatePicker.initializeDatePicker();
  }

  getReportSheet() {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'reportsheet/' + this.props.params.report_sheet_id, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        this.setState({
          report_sheet: response.data,
          loading: false,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChange(e) {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.state['report_sheet'][e.target.name] = value;
    this.setState(this.state);
  }

  handleDateChange(e, origin) {
    let value = e.target.value;

    if (value === undefined || value == null || value == '') {
      value = origin.state.lastDateValue;
    } else {
      value = DatePicker.dateFormat_CH2EN(value);
    }

    origin.state['report_sheet'][e.target.name] = value;
    origin.setState(this.state);
  }

  save() {
    this.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'reportsheet/' + this.props.params.report_sheet_id, this.state.report_sheet, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        Toast.showSuccess('Speichern erfolgreich', 'Spesen konnte gespeichert werden');
        this.getReportSheet();
      })
      .catch(error => {
        Toast.showError('Speichern fehlgeschlagen', 'Spesen konnte nicht gespeichert werden', error, this.context);
      });
  }

  showPDF() {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'pdf/zivireportsheet?reportSheetId=' + this.props.params.report_sheet_id, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
        responseType: 'blob',
      })
      .then(response => {
        this.setState({
          loading: false,
        });
        let blob = new Blob([response.data], { type: 'application/pdf' });
        window.location = window.URL.createObjectURL(blob);
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  formatRappen(amount) {
    return parseFloat(Math.round(amount * 100) / 100).toFixed(2);
  }

  render() {
    var content = [];
    var sheet = this.state.report_sheet;

    if (sheet != null) {
      content.push(
        <form
          action="javascript:;"
          onsubmit={() => {
            this.save();
          }}
        >
          <div>
            <h1>
              Spesenrapport erstellen für {sheet.first_name} {sheet.last_name}
            </h1>
          </div>
          <table border="0" cellspacing="0" cellpadding="4" class="table">
            <tbody>
              <tr>
                <td>Pflichtenheft</td>
                <td>
                  {sheet.pflichtenheft_id} {sheet.pflichtenheft_name}
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Beginn Einsatz</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">{sheet.einsaetze_start}</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Ende Einsatz</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">{sheet.einsaetze_end}</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Ferienanspruch für Einsatz</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">{sheet.einsaetze_eligibleholiday}</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Beginn Meldeblattperiode</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">{sheet.meldeblaetter_start}</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Ende Meldeblattperiode</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">{sheet.meldeblaetter_end}</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Dauer</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">{sheet.sum_tage} Tage</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Arbeit</td>
                <td>&nbsp;</td>
                <td>{sheet.meldeblaetter_workdays_proposal} Tage</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_workdays"
                    value={sheet.meldeblaetter_workdays}
                    size="2"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Tage
                </td>
                <td>&nbsp;</td>
                <td align="left">
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_work_comment"
                    value={sheet.meldeblaetter_work_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Arbeitsfrei</td>
                <td>&nbsp;</td>
                <td>{sheet.meldeblaetter_workfreedays_proposal} Tage</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_workfreedays"
                    value={sheet.meldeblaetter_workfreedays}
                    size="2"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Tage
                </td>
                <td>&nbsp;</td>
                <td align="left">
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_workfree_comment"
                    value={sheet.meldeblaetter_workfree_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Betriebsferien (Urlaub)</td>
                <td>&nbsp;</td>
                <td>{sheet.meldeblaetter_companyurlaub_proposal} Tage</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_companyurlaub"
                    value={sheet.meldeblaetter_companyurlaub}
                    size="2"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Tage
                </td>
                <td>&nbsp;</td>
                <td align="left">
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_compholiday_comment"
                    value={sheet.meldeblaetter_compholiday_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Betriebsferien (Ferien)</td>
                <td>&nbsp;</td>
                <td>{sheet.meldeblaetter_ferien_wegen_urlaub_proposal} Tage</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_ferien_wegen_urlaub"
                    value={sheet.meldeblaetter_ferien_wegen_urlaub}
                    size="2"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Tage
                </td>
                <td>&nbsp;</td>
                <td align="left">&nbsp;</td>
              </tr>
              <tr>
                <td>zusätzlich Arbeitsfrei</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">{sheet.meldeblaetter_add_workfree} Tage</td>
                <td>&nbsp;</td>
                <td>
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_add_workfree_comment"
                    value={sheet.meldeblaetter_add_workfree_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Krankheit (Übriges Guthaben: {sheet.krankheitstage_verbleibend} Tage)</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_ill"
                    value={sheet.meldeblaetter_ill}
                    size="2"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Tage
                </td>
                <td>&nbsp;</td>
                <td>
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_ill_comment"
                    value={sheet.meldeblaetter_ill_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Ferien (Übriges Guthaben: {sheet.remaining_holidays} Tage)</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_holiday"
                    value={sheet.meldeblaetter_holiday}
                    size="2"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Tage
                </td>
                <td>&nbsp;</td>
                <td>
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_holiday_comment"
                    value={sheet.meldeblaetter_holiday_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Persönlicher Urlaub</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_urlaub"
                    value={sheet.meldeblaetter_urlaub}
                    size="2"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Tage
                </td>
                <td>&nbsp;</td>
                <td>
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_urlaub_comment"
                    value={sheet.meldeblaetter_urlaub_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Kleiderspesen</td>
                <td>&nbsp;</td>
                <td>{this.formatRappen(sheet.meldeblaetter_kleider_proposal)} Fr.</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_kleider"
                    value={this.formatRappen(sheet.meldeblaetter_kleider)}
                    size="5"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Fr.
                </td>
                <td>&nbsp;</td>
                <td>
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_kleider_comment"
                    value={sheet.meldeblaetter_kleider_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Fahrspesen</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_fahrspesen"
                    value={this.formatRappen(sheet.meldeblaetter_fahrspesen)}
                    size="5"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Fr.
                </td>
                <td>&nbsp;</td>
                <td>
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_fahrspesen_comment"
                    value={sheet.meldeblaetter_fahrspesen_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>Ausserordentliche Spesen</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <input
                    type="text"
                    name="meldeblaetter_ausserordentlich"
                    value={this.formatRappen(sheet.meldeblaetter_ausserordentlich)}
                    size="5"
                    onchange={e => this.handleChange(e)}
                  />{' '}
                  Fr.
                </td>
                <td>&nbsp;</td>
                <td>
                  Bemerkungen:{' '}
                  <input
                    type="text"
                    name="meldeblaetter_ausserordentlich_comment"
                    value={sheet.meldeblaetter_ausserordentlich_comment}
                    size="45"
                    onchange={e => this.handleChange(e)}
                  />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Total</b>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <b>{this.formatRappen(sheet.total)} Fr.</b>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Konto-Nr.</td>
                <td />
                <td>&nbsp;</td>
                <td align="right">
                  <input
                    type="text"
                    size="9"
                    name="bank_account_number"
                    value={sheet.bank_account_number}
                    onchange={e => this.handleChange(e)}
                  />
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Beleg-Nr.</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <input type="text" size="9" name="document_number" value={sheet.document_number} onchange={e => this.handleChange(e)} />
                </td>{' '}
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Verbucht</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <DatePicker id="booked_date" value={sheet.booked_date} callback={this.handleDateChange} callbackOrigin={this} />
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Bezahlt</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <DatePicker id="paid_date" value={sheet.paid_date} callback={this.handleDateChange} callbackOrigin={this} />
                </td>{' '}
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>

              <tr>
                <td>
                  <input type="checkbox" name="done" id="fidDone" defaultChecked={sheet.done} onchange={e => this.handleChange(e)} />
                  <label for="fidDone"> Erledigt</label>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <input type="submit" name="fSubmit" value="Speichern und Aktualisieren" />&nbsp;
                  <a
                    onClick={() => {
                      this.showPDF();
                    }}
                  >
                    PDF anzeigen
                  </a>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      );
    }

    return (
      <Header>
        <div className="page page__expense">
          <Card>{content}</Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
