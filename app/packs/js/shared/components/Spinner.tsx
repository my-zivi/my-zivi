import { FunctionalComponent } from 'preact';
import React from 'preact/compat';

type SpinnerStyle = 'primary' | 'secondary' | 'success' | 'info' | 'warning' | 'danger' | 'light' | 'dark';

interface Props {
  style: SpinnerStyle;
}

const Spinner: FunctionalComponent<Props> = (props) => (
  <div className={`spinner-border text-${props.style}`} />
);

export default Spinner;
