import * as React from 'react';

class LoadingInformation extends React.Component {
  componentDidMount(): void {
    const loadingDots = document.getElementById('loading-dots');
    window.setInterval(() => {
      if (loadingDots!.innerHTML.length > 3) {
        loadingDots!.innerHTML = '';
      } else {
        loadingDots!.innerHTML += '.';
      }
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
