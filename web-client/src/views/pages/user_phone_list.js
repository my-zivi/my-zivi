import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';

export default function(props) {
  return (
    <div className="page page__user_phone_list">
      <Card>
        <h1>Telefonliste</h1>
        <p>Test {5 + 5}</p>
      </Card>
    </div>
  );
}
