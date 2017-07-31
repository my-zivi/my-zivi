import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';

@connect(['accountStore'])
export default class LoadingView extends Component {
  constructor(props) {
    super(props);
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.error != null) {
      if (nextProps.error.response != null && nextProps.error.response.status == 401) {
        this.props.accountStore.isLoggedIn = false;
        this.props.accountStore.isAdmin = false;
        localStorage.setItem('jwtToken', '');
        this.context.router.push('/login');
      }
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
      <div style="background:rgba(255,255,255,0.9); width:100%; height:100%; position:absolute; left:0px; top:0px; display: table; text-align:center;">
        <div style="display:table-cell; vertical-align: middle;">{content}</div>
      </div>
    );
  }
}
