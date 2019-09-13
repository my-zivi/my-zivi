import * as React from 'react';
// @ts-ignore
import ReactstrapSpinner from 'reactstrap/lib/Spinner';

interface SpinnerProps {
  type?: string;
  size?: string;
  color?: string;
  className?: string;
  cssModule?: any;
}

// Wrapped untyped reactstrap spinner
export const Spinner = (props: SpinnerProps) => <ReactstrapSpinner {...props} />;
