import { Component } from 'inferno';
import { api } from '../../utils/api';
import Auth from '../../utils/auth';

export default class LoadingView extends Component {
  componentWillReceiveProps(nextProps) {
    if (nextProps.error != null) {
      if (nextProps.error.response != null && nextProps.error.response.status === 401) {
        localStorage.removeItem('jwtToken');
        this.context.router.history.push('/login?path=' + encodeURI(this.context.router.route.location.pathname));
      }
    }
  }

  componentDidMount() {
    if (Auth.isLoggedIn()) {
      api()
        .patch('auth/refresh')
        .then(response => {
          localStorage.setItem('jwtToken', response.data.data.token);
        })
        .catch(error => {
          console.log(error);
          if (error.response && error.response.status === 401) {
            localStorage.removeItem('jwtToken');
            this.context.router.history.push('/login?path=' + this.context.router.route.location.pathname);
          }
        });
    }
  }

  render() {
    var content = [];
    if (this.props.error != null) {
      content.push(<div>Error: {this.props.error.message}</div>);
    } else if (this.props.loading) {
      content.push(
        <div>
          <span class="glyphicon-left glyphicon glyphicon-refresh gly-spin" /> Laden...
        </div>
      );
    } else {
      return;
    }

    return (
      <div
        style={{
          background: 'rgba(255,255,255,0.9)',
          width: '100%',
          height: '100%',
          zIndex: '99999999',
          position: 'fixed',
          left: '0px',
          top: '0px',
          display: 'table',
          textAlign: 'center',
        }}
      >
        <div style={{ display: 'table-cell', verticalAlign: 'middle' }}>{content}</div>
      </div>
    );
  }
}
