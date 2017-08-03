import Inferno from 'inferno';
import VNodeFlags from 'inferno-vnode-flags';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';

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
}
