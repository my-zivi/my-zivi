import Inferno from 'inferno';
import VNodeFlags from 'inferno-vnode-flags';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import { api } from '../../../utils/api';

export default class RegionalCenters extends Component {
  renderRegionalCenters(state) {
    var options = [];
    options.push(<option value="" />);

    for (let i = 0; i < state.regionalCenters.length; i++) {
      let isSelected = false;
      if (parseInt(state.result['regional_center']) == i + 1) {
        isSelected = true;
      }

      options.push(
        <option value={state.regionalCenters[i].id} selected={isSelected}>
          {state.regionalCenters[i].name}
        </option>
      );
    }

    return options;
  }

  getRegionalCenters(self) {
    api()
      .get('regionalcenter')
      .then(response => {
        self.setState({
          regionalCenters: response.data,
        });
      })
      .catch(error => {
        self.setState({ error: error });
      });
  }
}
