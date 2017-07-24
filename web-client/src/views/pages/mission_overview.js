import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';

export default function(props) {
  return (
    <div className="page page__mission_overview">
      <Card>
        <h1>Einsatzübersicht</h1>
      </Card>
    </div>
  );
}
