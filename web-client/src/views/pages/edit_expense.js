import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import InputField from '../tags/InputFields/InputField';
import InputFieldWithProposal from '../tags/InputFields/InputFieldWithProposal';
import DatePicker from '../tags/InputFields/DatePicker';
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

            <InputField id="pid" label="Pflichtenheft" value={sheet.pflichtenheft_id + ' ' + sheet.pflichtenheft_name} disabled="true" />
            <DatePicker
              id="einsaetze_start"
              label="Beginn Einsatz"
              value={sheet.einsaetze_start}
              callback={this.handleDateChange}
              callbackOrigin={this}
              disabled="true"
            />
            <DatePicker
              id="einsaetze_end"
              label="Ende Einsatz"
              value={sheet.einsaetze_end}
              callback={this.handleDateChange}
              callbackOrigin={this}
              disabled="true"
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
            <hr />

            <InputFieldWithProposal
              id="meldeblaetter_workdays"
              valueLabel="Gearbeitet"
              value={sheet.meldeblaetter_workdays}
              proposalValue={sheet.meldeblaetter_workdays_proposal}
              showComment={false}
              self={this}
            />

            <InputFieldWithProposal
              id="meldeblaetter_workfreedays"
              valueLabel="Arbeitsfreie Tage"
              value={sheet.meldeblaetter_workfreedays}
              proposalValue={sheet.meldeblaetter_workfreedays_proposal}
              showComment={true}
              commentId="meldeblaetter_workfree_comment"
              commentValue={sheet.meldeblaetter_workfree_comment}
              self={this}
            />

            <InputFieldWithProposal
              id="meldeblaetter_companyurlaub"
              valueLabel="Betriebsferien (Urlaub)"
              value={sheet.meldeblaetter_companyurlaub}
              proposalValue={sheet.meldeblaetter_companyurlaub_proposal}
              showComment={true}
              commentId="meldeblaetter_compholiday_comment"
              commentValue={sheet.meldeblaetter_compholiday_comment}
              self={this}
            />

            <InputFieldWithProposal
              id="meldeblaetter_ferien_wegen_urlaub"
              valueLabel="Betriebsferien (Ferien)"
              value={sheet.meldeblaetter_ferien_wegen_urlaub}
              proposalValue={sheet.meldeblaetter_ferien_wegen_urlaub_proposal}
              showComment={false}
              self={this}
            />

            <InputField
              id="meldeblaetter_add_workfree"
              label="Zusätzlich Arbeitsfrei"
              value={sheet.meldeblaetter_add_workfree}
              disabled="true"
            />
            <div class="proposalComment">
              <InputField
                id="meldeblaetter_add_workfree_comment"
                label="Bemerkung"
                value={sheet.meldeblaetter_add_workfree_comment}
                self={this}
              />
            </div>
            <hr />

            <InputFieldWithProposal
              id="meldeblaetter_ill"
              valueLabel="Krankheit"
              value={sheet.meldeblaetter_ill}
              proposalValue={sheet.krankheitstage_verbleibend}
              proposalText="Übriges Guthaben: "
              showComment={true}
              commentId="meldeblaetter_ill_comment"
              commentValue={sheet.meldeblaetter_ill_comment}
              self={this}
            />

            <InputFieldWithProposal
              id="meldeblaetter_holiday"
              valueLabel="Ferien"
              value={sheet.meldeblaetter_holiday}
              proposalValue={sheet.remaining_holidays}
              proposalText="Übriges Guthaben: "
              showComment={true}
              commentId="meldeblaetter_holiday_comment"
              commentValue={sheet.meldeblaetter_holiday_comment}
              self={this}
            />

            <InputField id="meldeblaetter_urlaub" label="Persönlicher Urlaub" value={sheet.meldeblaetter_urlaub} self={this} />
            <div class="proposalComment">
              <InputField id="meldeblaetter_urlaub_comment" label="Bemerkung" value={sheet.meldeblaetter_urlaub_comment} self={this} />
            </div>
            <hr />

            <InputFieldWithProposal
              id="meldeblaetter_kleider"
              valueLabel="Kleiderspesen"
              value={this.formatRappen(sheet.meldeblaetter_kleider)}
              proposalValue={this.formatRappen(sheet.meldeblaetter_kleider_proposal) + ' Fr.'}
              showComment={true}
              commentId="meldeblaetter_kleider_comment"
              commentValue={sheet.meldeblaetter_kleider_comment}
              self={this}
            />

            <InputField
              id="meldeblaetter_fahrspesen"
              label="Fahrspesen"
              value={this.formatRappen(sheet.meldeblaetter_fahrspesen)}
              self={this}
            />
            <div class="proposalComment">
              <InputField
                id="meldeblaetter_fahrspesen_comment"
                label="Bemerkung"
                value={sheet.meldeblaetter_fahrspesen_comment}
                self={this}
              />
            </div>
            <hr />

            <InputField
              id="meldeblaetter_ausserordentlich"
              label="Ausserordentliche Spesen"
              value={this.formatRappen(sheet.meldeblaetter_ausserordentlich)}
              self={this}
            />
            <div class="proposalComment">
              <InputField
                id="meldeblaetter_ausserordentlich_comment"
                label="Bemerkung"
                value={sheet.meldeblaetter_ausserordentlich_comment}
                self={this}
              />
            </div>
            <hr />

            <InputField id="total" label="Total" value={this.formatRappen(sheet.total) + ' Fr.'} disabled="true" />

            <InputField id="bank_account_number" label="Konto-Nr." value={sheet.bank_account_number} self={this} />
            <InputField id="document_number" label="Beleg-Nr." value={sheet.document_number} self={this} />

            <DatePicker
              id="booked_date"
              label="Verbucht"
              value={sheet.booked_date}
              callback={this.handleDateChange}
              callbackOrigin={this}
            />
            <DatePicker id="paid_date" label="Bezahlt" value={sheet.paid_date} callback={this.handleDateChange} callbackOrigin={this} />

            <InputField id="done" label="Erledigt" value={sheet.done} self={this} />

            <hr />

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
