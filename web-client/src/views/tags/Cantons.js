import Inferno from 'inferno';
import VNodeFlags from 'inferno-vnode-flags';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import axios from 'axios';
import ApiService from '../../utils/api';
import { connect } from 'inferno-mobx';

export default class Cantons extends Component {
  constructor(props) {
    super(props);

    this.state = {
      cantons: [],
    };
  }

  getCantons() {
    axios
      .get(ApiService.BASE_URL + 'canton', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        this.setState({
          cantons: response.data,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  getCantonRender(currentCanton) {
    var options = [];
    options.push(<option value="" />);

    for (let i = 0; i < this.state.cantons.length; i++) {
      let isSelected = false;
      if (currentCanton == i + 1) {
        isSelected = true;
      }

      options.push(
        <option value={this.state.cantons[i].id} selected={isSelected}>
          {this.state.cantons[i].short_name}
        </option>
      );
    }

    return options;
  }
}
