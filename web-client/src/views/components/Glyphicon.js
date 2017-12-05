import Inferno from 'inferno';

export const Glyphicon = ({ name, spin, ...props }) => (
  <span class={`glyphicon glyphicon-${name} ${spin ? 'gly-spin' : ''}`} aria-hidden="true" {...props} />
);
