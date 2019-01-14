import * as React from 'react';
import { InputFieldProps, NumberField } from './common';

const factor = 100;

export default class CurrencyField extends React.Component<InputFieldProps> {
  constructor(props: InputFieldProps) {
    super(props);
    this.state.value = this.format;
  }

  public state = {
    value: '',
  };

  public get format() {
    return this.props.field.value ? (this.props.field.value / factor).toFixed(2) : '';
  }

  public handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    this.setState({ value });
    if (value === '') {
      this.props.form.setFieldValue(this.props.field.name, null);
    } else {
      this.props.form.setFieldValue(this.props.field.name, Number(value) * factor);
    }
  };

  public render = () => {
    const labels: string[] = Boolean(this.props.appendedLabels) ? this.props.appendedLabels! : [];
    labels.unshift('CHF');

    return <NumberField {...this.props} appendedLabels={labels} onChange={this.handleChange} value={this.state.value} />;
  };
}
