import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import InputField from './InputField';

export default class InputCheckbox extends InputField {
  render() {
    let isChecked = this.props.value == 1;

    return this.getFormGroup(
      <input
        type="checkbox"
        id={this.props.id}
        name={this.props.id}
        checked={isChecked}
        className="form-control"
        onChange={this.props.onChange}
        disabled={this.props.disabled}
      />,
      null,
      1
    );
  }
}
