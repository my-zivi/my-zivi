import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';

// localStorage.removeItem('jwtToken');

export default function(props) {
  return (
    <div className="page page__logout">
      <Card>
        <h1>Logout</h1>
      </Card>
    </div>
  );
}
