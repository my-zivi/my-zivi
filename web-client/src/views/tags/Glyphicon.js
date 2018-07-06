export function Glyphicon({ name, spin, ...props }) {
  return <span className={`glyphicon glyphicon-${name} ${spin ? 'gly-spin' : ''}`} aria-hidden="true" {...props} />;
}
