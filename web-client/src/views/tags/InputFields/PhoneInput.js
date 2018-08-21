import React from 'react';
import InputField from './InputField';
import { api } from '../../../utils/api';

export default class PhoneInput extends InputField {
  constructor(props) {
    super(props);

    this.state = {
      everValidated: false,
    };

    this.validate = this.validate.bind(this);
  }

  async validate() {
    const phonenumber = this.props.value || '';

    if (!(phonenumber.trim() === '')) {
      const {
        data: { is_valid: isValid, formatted },
      } = await api().post('phonenumber/validate', { phonenumber });

      if (isValid) {
        this.props.changeResult(this.props.id, formatted);
        this.props.deleteFormError(this.props.id);
      } else {
        this.props.addFormError(this.props.id);
      }

      this.setState({ everValidated: true });
    }
  }

  render() {
    let groupClasses = '';

    if (this.state.everValidated) {
      groupClasses = this.props.fieldHasError(this.props.id) ? 'has-error' : 'has-success';
    }

    return this.getFormGroup({
      inputField: (
        <input
          type="tel"
          id={this.props.id}
          name={this.props.id}
          value={this.props.value || ''}
          className={'form-control'}
          onBlur={this.validate}
          onChange={e => this.props.onChange(e)}
          readOnly={this.props.disabled}
        />
      ),
      groupClass: groupClasses,
    });
  }
}
