import Inferno from 'inferno';
import { Link } from 'inferno-router';

export default function CardLink(props) {
  return (
    <Link to={props.to} className="card">
      {props.children}
    </Link>
  );
}
