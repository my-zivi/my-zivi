import React from 'react';
import InputField from './InputField';
import { api } from '../../../utils/api';

export default class PhoneInput extends InputField {
  async validate() {
    let phonenumber = this.props.value;
    if (phonenumber.trim() === '') {
      return this.props.onInput('', undefined);
    }
    let {
      data: { is_valid: isValid, formatted },
    } = await api().post('phonenumber/validate', { phonenumber });

    if (phonenumber === this.props.value) {
      this.props.onInput(formatted, isValid);
    }
  }

  render() {
    return this.getFormGroup(
      <input
        type="tel"
        id={this.props.id}
        name={this.props.id}
        value={this.props.value || ''}
        className={'form-control'}
        onChange={e => this.props.onInput(e.target.value, undefined)}
        onBlur={() => this.validate()}
        readOnly={this.props.disabled}
      />
    );
  }
}
