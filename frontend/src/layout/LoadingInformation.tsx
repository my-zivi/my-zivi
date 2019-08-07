import * as React from 'react';
import { Spinner } from '../utilities/Spinner';

class LoadingInformation extends React.Component<{ message?: string, className?: any }> {
  render(): React.ReactNode {
    return (
      <div className={this.props.className}>
        <Spinner size="sm" color="primary" className="mr-2" />
        {this.props.message || 'Inhalt wird geladen, einen Moment'}
      </div>
    );
  }
}

export { LoadingInformation };
