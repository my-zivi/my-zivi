import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';

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

  getReportSheet() {
    let self = this;
    axios
      .get(ApiService.BASE_URL + 'reportsheet/' + self.props.params.report_sheet_id, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(function(response) {
        self.setState({
          report_sheet: response.data,
        });
      })
      .catch(function(error) {
        console.log(error);
      });
  }

  render() {
    var content = [];
    var sheet = this.state.report_sheet;

    if (sheet != null) {
      content.push(
        <form action="/editSpesenrapport.php?id=208" method="post" enctype="multipart/form-data">
          <div>
            <h1>Spesenrapport erstellen für Thomas Honegger</h1>
          </div>
          <table border="0" cellspacing="0" cellpadding="4" class="table">
            <tbody>
              <tr>
                <td class="todd">Pflichtenheft</td>
                <td class="todd">37391.1 Feldarbeiten (bis 31. März 2010)</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
              </tr>
              <tr>
                <td class="teven">Beginn Einsatz</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  {sheet.einsaetze_start}
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
              </tr>
              <tr>
                <td class="teven">Ende Einsatz</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  {sheet.einsaetze_end}
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
              </tr>
              <tr>
                <td class="teven">Ferienanspruch für Einsatz</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  0
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
              </tr>
              <tr>
                <td class="todd">Beginn Meldeblattperiode</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="right">
                  {sheet.meldeblaetter_start}
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
              </tr>
              <tr>
                <td class="teven">Ende Meldeblattperiode</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  {sheet.meldeblaetter_end}
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
              </tr>
              <tr>
                <td class="todd">Dauer</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="right">
                  {sheet.sum_tage} Tage
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
              </tr>
              <tr>
                <td class="teven">Arbeit</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">8 Tage</td>
                <td class="teven" align="right">
                  <input type="text" name="fArbeit" value="8" size="2" /> Tage
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="left">
                  Bemerkungen: <input type="text" name="fArbeitcomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="todd">Arbeitsfrei</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">2 Tage</td>
                <td class="todd" align="right">
                  <input type="text" name="fArbeitsfrei" value="2" size="2" /> Tage
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="left">
                  Bemerkungen: <input type="text" name="fArbeitsfreicomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="teven">Betriebsferien (Urlaub)</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">0 Tage</td>
                <td class="teven" align="right">
                  <input type="text" name="fBetriebsferienurlaub" value="0" size="2" /> Tage
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="left">
                  Bemerkungen: <input type="text" name="fBetriebsferiencomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="todd">Betriebsferien (Ferien)</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">0 Tage</td>
                <td class="todd" align="right">
                  <input type="text" name="fBetriebsferienferien" value="0" size="2" /> Tage
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="left">
                  &nbsp;
                </td>
              </tr>
              <tr>
                <td class="teven">zusätzlich Arbeitsfrei</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  0 Tage
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">
                  Bemerkungen: <input type="text" name="fZarbeitsfreicomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="todd">Krankheit (Übriges Guthaben: 77 Tage)</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="right">
                  <input type="text" name="fKrankheit" value="0" size="2" /> Tage
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd">
                  Bemerkungen: <input type="text" name="fKrankheitcomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="teven">Ferien (Übriges Guthaben: 0 Tage)</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  <input type="text" name="fFerien" value="0" size="2" /> Tage
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">
                  Bemerkungen: <input type="text" name="fFeriencomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="todd">Persönlicher Urlaub</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="right">
                  <input type="text" name="fUrlaub" value="0" size="2" /> Tage
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd">
                  Bemerkungen: <input type="text" name="fUrlaubcomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="teven">Kleiderspesen</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">23.00 Fr.</td>
                <td class="teven" align="right">
                  <input type="text" name="fKleiderspesen" value="23.00" size="5" /> Fr.
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">
                  Bemerkungen: <input type="text" name="fKleidercomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="todd">Fahrspesen</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="right">
                  <input type="text" name="fFahrspesen" value="0.00" size="5" /> Fr.
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd">
                  Bemerkungen: <input type="text" name="fFahrspesencomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="teven">Ausserordentliche Spesen</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  <input type="text" name="fAusserordentlich" value="0.00" size="5" /> Fr.
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">
                  Bemerkungen: <input type="text" name="fAusserordentlichcomment" value="" size="45" />
                </td>
              </tr>
              <tr>
                <td class="todd">
                  <b>Total</b>
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="right">
                  <b>437.00 Fr.</b>
                </td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
              </tr>
              <tr>
                <td class="teven">Konto-Nr.</td>
                <td class="teven" />
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  <input type="text" size="9" name="fKonto" value="4470 (200)" />
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
              </tr>
              <tr>
                <td class="todd">Beleg-Nr.</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="right">
                  <input type="text" size="9" name="fBeleg" value="" />
                </td>{' '}
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
              </tr>
              <tr>
                <td class="teven">Verbucht</td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
                <td class="teven" align="right">
                  <input type="text" size="9" name="fVerbucht" value="" />
                </td>
                <td class="teven">&nbsp;</td>
                <td class="teven">&nbsp;</td>
              </tr>
              <tr>
                <td class="todd">Bezahlt</td>
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
                <td class="todd" align="right">
                  <input type="text" size="9" name="fBezahlt" value="" />
                </td>{' '}
                <td class="todd">&nbsp;</td>
                <td class="todd">&nbsp;</td>
              </tr>

              <tr>
                <td>
                  <input type="checkbox" name="fDone" id="fidDone" checked="" />
                  <label for="fidDone"> Erledigt</label>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">
                  <input type="submit" name="fSubmit" value="Speichern und Aktualisieren" />&nbsp;
                  <a href={ApiService.BASE_URL + 'pdf/zivireportsheet?reportSheetId=' + this.props.params.report_sheet_id}>PDF anzeigen</a>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      );
    }

    return (
      <div className="page page__expense">
        <Card>{content}</Card>
      </div>
    );
  }
}
