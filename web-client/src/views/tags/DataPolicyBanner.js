import { Component } from 'inferno';

export default class DataPolicyBanner extends Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      hidden: localStorage.getItem('dataPolicyHidden') === 'true',
    };
  }

  hide() {
    localStorage.setItem('dataPolicyHidden', 'true');
    this.setState({ hidden: true });
  }

  render() {
    if (this.state.hidden) {
      return null;
    }
    return (
      <div
        style={{
          display: 'block',
          backgroundColor: 'white',
          color: 'black',
          bottom: 0,
          borderTop: '2px solid rgb(68, 68, 68)',
          position: 'fixed',
          margin: '0 auto',
          padding: '16px 0',
          textAlign: 'center',
          width: '100%',
          zIndex: 9999,
          height: 'auto',
        }}
      >
        <span>
          Wir verwenden Cookies und Analyse Tools um die Nutzerfreundlichkeit unserer Webseite zu verbessern. Wenn Sie die Webseite weiter
          nutzen, gehen wir von Ihrem Einverständnis aus.
        </span>
        <button class="btn btn-default" onClick={() => this.hide()} style={{ marginLeft: '10px' }}>
          OK
        </button>
        <a href="https://www.stiftungswo.ch/datenschutzerklaerung/" style={{ marginLeft: '10px' }} target="_blank">
          Weitere Infos: Datenschutzerklärung
        </a>
      </div>
    );
  }
}
