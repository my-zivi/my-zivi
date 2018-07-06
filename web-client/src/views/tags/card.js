export default function Card(props) {
  return (
    <div className="card">
      {props.children}
      <br />
    </div>
  );
}
