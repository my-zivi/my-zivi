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
          <div class="form-group">
            <label for="start">Anfang:</label>
            <input type="date" class="form-control" name="start" id="start" />
          </div>
          <div class="form-group">
            <label for="email">Ende:</label>
            <input type="date" class="form-control" name="end" id="end" />
          </div>
          <button class="btn btn-primary" type="submit">
            Absenden
          </button>
        </form>
      </Card>
    </div>
  );
}
