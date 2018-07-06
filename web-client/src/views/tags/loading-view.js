import { Component } from 'inferno';
import { Redirect, withRouter } from 'inferno-router';
import { api } from '../../utils/api';
import Auth from '../../utils/auth';

class LoadingView extends Component {
  constructor(props) {
    super(props);

    this.state = {
      redirectToLogin: false,
    };
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.error != null) {
      if (nextProps.error.response != null && nextProps.error.response.status === 401) {
        this.redirectToLogin();
      }
    }
  }

  async componentDidMount() {
    if (Auth.isLoggedIn()) {
      try {
        let response = await api().patch('auth/refresh');
        Auth.setToken(response.data.data.token);
      } catch (error) {
        console.log(error);
        if (error.response && error.response.status === 401) {
          this.redirectToLogin();
        }
      }
    }
  }

  redirectToLogin() {
    Auth.removeToken();
    this.setState({ redirectToLogin: true });
  }

  render() {
    if (this.state.redirectToLogin) {
      let target = {
        pathname: '/login',
        state: { referrer: this.props.location.pathname },
      };
      return <Redirect to={target} />;
    }

    let Wrapper = ({ children }) => (
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
        <div style={{ display: 'table-cell', verticalAlign: 'middle' }}>{children}</div>
      </div>
    );

    if (this.props.error != null) {
      return (
        <Wrapper>
          <div>Error: {this.props.error.message}</div>
        </Wrapper>
      );
    } else if (this.props.loading) {
      return (
        <Wrapper>
          <div>
            <span className="glyphicon-left glyphicon glyphicon-refresh gly-spin" /> Laden...
          </div>
        </Wrapper>
      );
    }

    return null;
  }
}

export default withRouter(LoadingView);
