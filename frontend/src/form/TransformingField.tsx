import * as React from 'react';
import { IziviCustomFieldProps, IziviInputField } from './common';

export type TransformingFieldProps<T> = IziviCustomFieldProps<T | null>;

const UnsafeIziviInputField = IziviInputField as any;

interface Props<T> extends TransformingFieldProps<T> {
  toValue: (s: string) => T;
  toString: (value: T) => string;
}

export class TransformingField<T> extends React.Component<Props<T>> {
  get format() {
    return this.props.value === null || this.props.value === undefined ? '' : this.props.toString(this.props.value);
  }

  state = {
    representation: '',
  };

  constructor(props: Props<T>) {
    super(props);
    this.state.representation = this.format;
  }

  handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const representation = e.target.value;
    this.setState({ representation });
    if (representation === '') {
      this.props.onChange(null);
    } else {
      this.props.onChange(this.props.toValue(representation));
    }
  }

  render = () => {
    const { toValue, toString, ...rest } = this.props;
    return <UnsafeIziviInputField {...rest} value={this.state.representation} onChange={this.handleChange} />;
  }
}
