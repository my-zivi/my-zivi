import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';

export default function(props) {
  return (
    <div className="page page__user_list">
      <Card>
        <h1>Benutzerliste</h1>
      </Card>
    </div>
  );
}
