import {Component} from 'inferno';
import Card from '../tags/card';
import InputField from '../tags/InputFields/InputField';
import InputCheckbox from '../tags/InputFields/InputCheckbox';
import InputFieldWithProposal from '../tags/InputFields/InputFieldWithProposal';
import DatePicker from '../tags/InputFields/DatePicker';
import axios from 'axios';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import Toast from '../../utils/toast';
import moment from 'moment-timezone';

export default class EditExpense extends Component {
  constructor(props, { router }) {
    super(props);

    this.state = {
      report_sheet: null,
      force_save: false,
    };

    this.router = router;
  }

  componentDidMount() {
    this.getReportSheet();
  }

  getReportSheet() {
    this.setState({ loading: true, error: null });
    axios
      .get(ApiService.BASE_URL + 'reportsheet/' + this.props.match.params.report_sheet_id, {
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

  handleSelectChange(e) {
    let value = 1;
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
    origin.state['report_sheet']['meldeblaetter_tage'] =
      moment(origin.state['report_sheet']['meldeblaetter_end']).diff(moment(origin.state['report_sheet']['meldeblaetter_start']), 'days') +
      1;
    origin.setState(this.state);
  }

  handleForceSave(e) {
    const value = e.target.checked;
    this.state.force_save = value;
    this.setState(this.state);
  }

  save() {
    var requiredDays = this.state.report_sheet.meldeblaetter_tage;
    var providedDays =
      (parseInt(this.state.report_sheet.meldeblaetter_workdays) || 0) +
      (parseInt(this.state.report_sheet.meldeblaetter_workfreedays) || 0) +
      (parseInt(this.state.report_sheet.meldeblaetter_companyurlaub) || 0) +
      (parseInt(this.state.report_sheet.meldeblaetter_ferien_wegen_urlaub) || 0) +
      (parseInt(this.state.report_sheet.meldeblaetter_add_workfree) || 0) +
      (parseInt(this.state.report_sheet.meldeblaetter_ill) || 0) +
      (parseInt(this.state.report_sheet.meldeblaetter_holiday) || 0) +
      (parseInt(this.state.report_sheet.meldeblaetter_urlaub) || 0);

    if (requiredDays != providedDays) {
      if (!this.state.force_save) {
        Toast.showError(
          'Anzahl Tage prüfen!',
          'Die benötigte Anzahl Tage (' + requiredDays + ') stimmt nicht mit der eingefüllten Anzahl (' + providedDays + ') überein.',
          null,
          this.context
        );
        return;
      }
    }

    this.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'reportsheet/' + this.props.match.params.report_sheet_id, this.state.report_sheet, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        Toast.showSuccess('Speichern erfolgreich', 'Spesen konnte gespeichert werden');
        this.getReportSheet();
      })
      .catch(error => {
        this.setState({ loading: false, error: null });
        Toast.showError('Speichern fehlgeschlagen', 'Spesen konnte nicht gespeichert werden', error, this.context);
      });
  }

  deleteReportSheet() {
    if (window.confirm('Möchten Sie dieses Meldeblatt wirklich löschen?')) {
      this.setState({ loading: true, error: null });
      axios
        .delete(ApiService.BASE_URL + 'reportsheet/' + this.props.match.params.report_sheet_id, {
          headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
        })
        .then(response => {
          this.router.history.push('/profile/' + this.state['report_sheet']['user']);
        })
        .catch(error => {
          this.setState({ loading: false, error: null });
          Toast.showError('Löschen fehlgeschlagen', 'Meldeblatt konnte nicht gelöscht werden', error, this.context);
        });
    }
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
            <DatePicker id="einsaetze_start" label="Beginn Einsatz" value={sheet.einsaetze_start} disabled="true" />
            <DatePicker
              id="einsaetze_end"
              label="Ende Einsatz"
              value={sheet.einsaetze_end}
              callback={this.handleDateChange}
              callbackOrigin={this}
              disabled="true"
            />
            <DatePicker
              id="meldeblaetter_start"
              label="Beginn Meldeblattperiode"
              value={sheet.meldeblaetter_start}
              callback={this.handleDateChange}
              callbackOrigin={this}
            />
            <DatePicker
              id="meldeblaetter_end"
              label="Ende Meldeblattperiode"
              value={sheet.meldeblaetter_end}
              callback={this.handleDateChange}
              callbackOrigin={this}
            />
            <InputField
              id="einsaetze_eligibleholiday"
              label="Ferienanspruch für Einsatz"
              value={sheet.einsaetze_eligibleholiday}
              disabled="true"
            />
            <InputField id="meldeblaetter_tage" label="Dauer" value={sheet.meldeblaetter_tage + ' Tage'} disabled="true" />
            <hr />

            <InputFieldWithProposal
              id="meldeblaetter_workdays"
              valueLabel="Gearbeitet"
              value={sheet.meldeblaetter_workdays}
              inputType="number"
              proposalValue={sheet.meldeblaetter_workdays_proposal}
              showComment={false}
              self={this}
              doValidation={true}
            />

            <InputFieldWithProposal
              id="meldeblaetter_workfreedays"
              valueLabel="Arbeitsfreie Tage"
              value={sheet.meldeblaetter_workfreedays}
              inputType="number"
              proposalValue={sheet.meldeblaetter_workfreedays_proposal}
              showComment={true}
              doValidation={true}
              commentId="meldeblaetter_workfree_comment"
              commentValue={sheet.meldeblaetter_workfree_comment}
              self={this}
            />

            <InputFieldWithProposal
              id="meldeblaetter_companyurlaub"
              valueLabel="Betriebsferien (Urlaub)"
              value={sheet.meldeblaetter_companyurlaub}
              inputType="number"
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
              inputType="number"
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
              inputType="number"
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
              inputType="number"
              proposalValue={sheet.remaining_holidays}
              proposalText="Übriges Guthaben: "
              showComment={true}
              commentId="meldeblaetter_holiday_comment"
              commentValue={sheet.meldeblaetter_holiday_comment}
              self={this}
            />

            <InputField
              id="meldeblaetter_urlaub"
              label="Persönlicher Urlaub"
              value={sheet.meldeblaetter_urlaub}
              self={this}
              inputType="number"
            />
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

            <div class="form-group">
              <label class="control-label col-sm-3" for="state">
                Status
              </label>
              <div class="col-sm-9">
                <select value={'' + sheet['state']} id="state" name="state" class="form-control" onChange={e => this.handleChange(e)}>
                  <option value="0">Offen</option>
                  <option value="1">Bereit für Auszahlung</option>
                  <option value="2">Auszahlung in Verarbeitung</option>
                  <option value="3">Erledigt</option>
                </select>
              </div>
            </div>
            <hr />

            <div class="container">
              <button
                type="submit"
                name="saveExpense"
                class="btn btn-primary col-sm-3"
                onClick={() => {
                  this.save();
                }}
              >
                <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true" /> Speichern und aktualisieren
              </button>
              <div class="col-sm-2" />
              <button
                type="button"
                name="showProfile"
                class="btn btn-danger col-sm-2"
                onClick={() => {
                  this.deleteReportSheet();
                }}
              >
                <span class="glyphicon glyphicon-trash" aria-hidden="true" /> Löschen
              </button>
              <a
                type="button"
                name="print"
                class="btn btn-warning col-sm-2"
                href={
                  ApiService.BASE_URL +
                  'pdf/zivireportsheet?reportSheetId=' +
                  this.props.match.params.report_sheet_id +
                  '&jwttoken=' +
                  encodeURI(localStorage.getItem('jwtToken'))
                }
                target="_blank"
              >
                <span class="glyphicon glyphicon-print" aria-hidden="true" /> Drucken
              </a>
              <div class="col-sm-1" />
              <button
                type="button"
                name="deleteReport"
                class="btn btn-default col-sm-2"
                onClick={() => {
                  this.router.history.push('/profile/' + this.state['report_sheet']['user']);
                }}
              >
                Profil anzeigen
              </button>
            </div>
            <br />
            <br />

            <div class="container">
              <InputCheckbox
                id="force_save"
                value={this.state.force_save}
                label="Speichern erzwingen"
                self={this}
                callback={e => this.handleForceSave(e)}
              />
            </div>
          </form>
          <br />
          <br />
          <br />
          <br />
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
