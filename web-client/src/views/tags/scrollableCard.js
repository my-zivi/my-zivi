import Inferno from 'inferno';

export default function(props) {
  return <div className="container-fluid pre-x-scrollable scrollableCard">{props.children}</div>;
}
