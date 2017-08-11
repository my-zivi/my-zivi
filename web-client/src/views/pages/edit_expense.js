import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import InputField from '../tags/Profile/InputField';
import DatePicker from '../tags/DatePicker';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import Toast from '../../utils/toast';

export default class EditExpense extends Component {
  constructor(props, { router }) {
    super(props);

    this.state = {
      report_sheet: null,
    };

    this.router = router;
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

  formatRappen(amount) {
    return parseFloat(Math.round(amount * 100) / 100).toFixed(2);
  }

  render(props) {
    var content = [];
    var sheet = this.state.report_sheet;

    if (sheet != null) {
      content.push(
        <div class="container">
          <form class="form-horizontal" action="javascript:;">
            <div>
              <h1>
                Spesenrapport erstellen für {sheet.first_name} {sheet.last_name}
              </h1>
            </div>
            <br />
            <br />

            <h3>Allgemein</h3>
            <InputField id="pid" label="Pflichtenheft" value={sheet.pflichtenheft_id + ' ' + sheet.pflichtenheft_name} disabled="true" />
            <DatePicker
              id="einsaetze_start"
              label="Beginn Einsatz"
              value={sheet.einsaetze_start}
              callback={this.handleDateChange}
              callbackOrigin={this}
            />
            <DatePicker
              id="einsaetze_end"
              label="Ende Einsatz"
              value={sheet.einsaetze_end}
              callback={this.handleDateChange}
              callbackOrigin={this}
            />

            <InputField
              id="einsaetze_eligibleholiday"
              label="Ferienanspruch für Einsatz"
              value={sheet.einsaetze_eligibleholiday}
              disabled="true"
            />
            <InputField id="meldeblaetter_start" label="Beginn Meldeblattperiode" value={sheet.meldeblaetter_start} disabled="true" />

            <InputField id="meldeblaetter_end" label="Ende Meldeblattperiode" value={sheet.meldeblaetter_end} disabled="true" />
            <InputField id="sum_tage" label="Dauer" value={sheet.sum_tage + ' Tage'} disabled="true" />

            <h3>Gearbeitet</h3>
            <InputField
              id="meldeblaetter_workdays_proposal"
              label="Vorschlag"
              value={sheet.meldeblaetter_workdays_proposal}
              disabled="true"
            />
            <InputField id="meldeblaetter_workdays" label="Wert" value={sheet.meldeblaetter_workdays} />

            <h3>Arbeitsfreie Tage</h3>
            <InputField
              id="meldeblaetter_workfreedays_proposal"
              label="Vorschlag"
              value={sheet.meldeblaetter_workfreedays_proposal}
              disabled="true"
            />
            <InputField id="meldeblaetter_workfreedays" label="Wert" value={sheet.meldeblaetter_workfreedays} />
            <InputField id="meldeblaetter_workfree_comment" label="Bemerkung" value={sheet.meldeblaetter_workfree_comment} />

            <h3>Betriebsferien (Urlaub)</h3>
            <InputField
              id="meldeblaetter_companyurlaub_proposal"
              label="Vorschlag"
              value={sheet.meldeblaetter_companyurlaub_proposal}
              disabled="true"
            />
            <InputField id="meldeblaetter_companyurlaub" label="Wert" value={sheet.meldeblaetter_companyurlaub} />
            <InputField id="meldeblaetter_compholiday_comment" label="Bemerkung" value={sheet.meldeblaetter_compholiday_comment} />

            <h3>Betriebsferien (Ferien)</h3>
            <InputField
              id="meldeblaetter_ferien_wegen_urlaub_proposal"
              label="Vorschlag"
              value={sheet.meldeblaetter_ferien_wegen_urlaub_proposal}
              disabled="true"
            />
            <InputField id="meldeblaetter_ferien_wegen_urlaub" label="Wert" value={sheet.meldeblaetter_ferien_wegen_urlaub} />

            <h3>Zusätzlich Arbeitsfrei</h3>
            <InputField id="meldeblaetter_add_workfree" label="Vorschlag" value={sheet.meldeblaetter_add_workfree} disabled="true" />
            <InputField id="meldeblaetter_add_workfree_comment" label="Bemerkung" value={sheet.meldeblaetter_add_workfree_comment} />

            <h3>Krankheit</h3>
            <InputField
              id="krankheitstage_verbleibend"
              label="Übriges Guthaben"
              value={sheet.krankheitstage_verbleibend + ' Tage'}
              disabled="true"
            />
            <InputField id="meldeblaetter_ill" label="Wert" value={sheet.meldeblaetter_ill} />
            <InputField id="meldeblaetter_ill_comment" label="Bemerkung" value={sheet.meldeblaetter_ill_comment} />

            <h3>Ferien</h3>
            <InputField id="remaining_holidays" label="Übriges Guthaben" value={sheet.remaining_holidays + ' Tage'} disabled="true" />
            <InputField id="meldeblaetter_holiday" label="Wert" value={sheet.meldeblaetter_holiday} />
            <InputField id="meldeblaetter_holiday_comment" label="Bemerkung" value={sheet.meldeblaetter_holiday_comment} />

            <h3>Persönlicher Urlaub</h3>
            <InputField id="meldeblaetter_urlaub" label="Wert" value={sheet.meldeblaetter_urlaub} />
            <InputField id="meldeblaetter_urlaub_comment" label="Bemerkung" value={sheet.meldeblaetter_urlaub_comment} />

            <h3>Kleiderspesen</h3>
            <InputField
              id="meldeblaetter_kleider_proposal"
              label="Wert"
              value={this.formatRappen(sheet.meldeblaetter_kleider_proposal) + ' Fr.'}
              disabled="true"
            />
            <InputField id="meldeblaetter_kleider_comment" label="Bemerkung" value={sheet.meldeblaetter_kleider_comment} />

            <h3>Fahrspesen</h3>
            <InputField id="meldeblaetter_fahrspesen" label="Wert [Fr.]" value={sheet.meldeblaetter_fahrspesen} />
            <InputField id="meldeblaetter_fahrspesen_comment" label="Bemerkung" value={sheet.meldeblaetter_fahrspesen_comment} />

            <h3>Ausserordentliche Spesen</h3>
            <InputField id="meldeblaetter_ausserordentlich" label="Wert" value={this.formatRappen(sheet.meldeblaetter_ausserordentlich)} />
            <InputField
              id="meldeblaetter_ausserordentlich_comment"
              label="Bemerkung"
              value={sheet.meldeblaetter_ausserordentlich_comment}
            />

            <InputField id="total" label="Total" value={this.formatRappen(sheet.total) + ' Fr.'} disabled="true" />

            <InputField id="bank_account_number" label="Konto-Nr." value={sheet.bank_account_number} />
            <InputField id="document_number" label="Beleg-Nr." value={sheet.document_number} />

            <DatePicker
              id="booked_date"
              label="Verbucht"
              value={sheet.booked_date}
              callback={this.handleDateChange}
              callbackOrigin={this}
            />
            <DatePicker id="paid_date" label="Bezahlt" value={sheet.paid_date} callback={this.handleDateChange} callbackOrigin={this} />

            <InputField id="done" label="Erledigt" value={sheet.done} />

            <br />
            <br />

            <div class="form-group">
              <div class="col-sm-2" />
              <button
                type="submit"
                name="saveExpense"
                class="btn btn-primary col-sm-1"
                onClick={() => {
                  this.save();
                }}
              >
                Speichern
              </button>
              <div class="col-sm-1" />
              <button
                type="button"
                name="showProfile"
                class="btn btn-default col-sm-2"
                onClick={() => {
                  this.router.push('/profile/' + ApiService.getUserId());
                }}
              >
                Profil anzeigen
              </button>
              <div class="col-sm-6" />
            </div>
          </form>
        </div>
      );
    }

    return (
      <Header>
        <div className="page page__edit_expense">
          <Card>{content}</Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
