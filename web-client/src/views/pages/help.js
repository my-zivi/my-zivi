import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import Header from '../tags/header';

export default function(props) {
  return (
    <Header>
      <div className="page page__help">
        <Card>
          <h1>Hilfe</h1>
        </Card>
      </div>
    </Header>
  );
}
