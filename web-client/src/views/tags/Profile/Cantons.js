import Inferno from 'inferno';
import VNodeFlags from 'inferno-vnode-flags';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import axios from 'axios';
import ApiService from '../../utils/api';

export default class Cantons extends Component {
  renderCantons(state) {
    var options = [];
    options.push(<option value="" />);

    for (let i = 0; i < state.cantons.length; i++) {
      let isSelected = false;
      if (parseInt(state.result['canton']) == i + 1) {
        isSelected = true;
      }

      options.push(
        <option value={state.cantons[i].id} selected={isSelected}>
          {state.cantons[i].short_name}
        </option>
      );
    }

    return options;
  }

  getCantons(self) {
    axios
      .get(ApiService.BASE_URL + 'canton', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        self.setState({
          cantons: response.data,
        });
      })
      .catch(error => {
        self.setState({ error: error });
      });
  }
}
