import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import ApiService from '../../utils/api';

export default function(props) {
  return (
    <div className="page page__user_phone_list">
      <Card>
        <h1>Telefonliste</h1>
        <p>
          Geben Sie ein Anfangsdatum und ein Enddatum ein um eine Telefonliste mit allen Zivis zu erhalten, die in diesem Zeitraum arbeiten.
        </p>

        <form action={ApiService.BASE_URL + 'pdf/phoneList'} method="GET">
          <table class="swoPane" width="500" cellpadding="5">
            <tbody>
              <tr>
                <td>Anfang:</td>
                <td>
                  <input class="SWOInput" name="start" type="date" value="" />
                </td>
              </tr>
              <tr>
                <td>Ende:</td>
                <td>
                  <input class="SWOInput" name="end" type="date" value="" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <input class="SWOButton" type="submit" value="Absenden" />
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      </Card>
    </div>
  );
}
