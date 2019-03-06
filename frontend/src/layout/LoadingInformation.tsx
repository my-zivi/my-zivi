import * as React from 'react';
import { Component } from 'react';

class LoadingInformation extends Component {
  componentDidMount(): void {
    let loadingDots = document.getElementById('loading-dots');
    window.setInterval(function() {
      if (loadingDots!.innerHTML.length > 3) loadingDots!.innerHTML = '';
      else loadingDots!.innerHTML += '.';
    }, 100);
  }

  render(): React.ReactNode {
    return (
      <>
        Inhalt wird geladen, einen Moment <span id={'loading-dots'}>.</span>
      </>
    );
  }
}

export { LoadingInformation };
