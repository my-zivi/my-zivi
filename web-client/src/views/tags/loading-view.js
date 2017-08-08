import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';
import axios from 'axios';
import ApiService from '../../utils/api';

export default class LoadingView extends Component {
  constructor(props) {
    super(props);
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.error != null) {
      if (nextProps.error.response != null && nextProps.error.response.status == 401) {
        localStorage.removeItem('jwtToken');
        this.context.router.push('/');
      }
    }
  }

  componentDidMount() {
    if (localStorage.getItem('jwtToken') !== null) {
      axios
        .request({
          url: ApiService.BASE_URL + 'auth/refresh',
          method: 'patch',
          headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
        })
        .then(response => {
          localStorage.setItem('jwtToken', response.data.data.token);
        })
        .catch(error => {
          console.log(error);
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
      <div style="background:rgba(255,255,255,0.9); width:100%; height:100%; z-index:99999999; position:fixed; left:0px; top:0px; display: table; text-align:center;">
        <div style="display:table-cell; vertical-align: middle;">{content}</div>
      </div>
    );
  }
}
