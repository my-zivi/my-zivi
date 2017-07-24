import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';

export default function(props) {
  return (
    <div className="page page__help">
      <Card>
        <h1>Hilfe</h1>
      </Card>
    </div>
  );
}
