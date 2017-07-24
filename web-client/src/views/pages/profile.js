import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';

export default function(props) {
  return (
    <div className="page page__profile">
      <Card>
        <h1>Profile</h1>
      </Card>
    </div>
  );
}
