import React from 'react';
import InputField from './InputField';

export default class InputCheckbox extends InputField {
  render() {
    let isChecked = !!this.props.value;

    return this.getFormGroup({
      inputField: (
        <input
          type="checkbox"
          id={this.props.id}
          name={this.props.id}
          checked={isChecked}
          className="form-control"
          onChange={this.props.onChange}
          disabled={this.props.disabled}
        />
      ),
      contentWidth: 1,
    });
  }
}
