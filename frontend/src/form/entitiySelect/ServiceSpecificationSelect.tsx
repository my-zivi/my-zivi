import { inject, observer } from 'mobx-react';
import React from 'react';
import FormGroup from 'reactstrap/lib/FormGroup';
import Input from 'reactstrap/lib/Input';
import Label from 'reactstrap/lib/Label';
import { ServiceSpecificationStore } from '../../stores/serviceSpecificationStore';
import { ServiceSpecification } from '../../types';
import { IziviCustomFieldProps, withColumn } from '../common';

type Props = {
  serviceSpecificationStore?: ServiceSpecificationStore;
  label?: string;
  required?: boolean;
  horizontal?: boolean;
} & IziviCustomFieldProps<string>;

@inject('serviceSpecificationStore')
@observer
export class ServiceSpecificationSelect extends React.Component<Props> {
  get options() {
    return this.props
      .serviceSpecificationStore!
      .entities
      .filter((serviceSpecification: ServiceSpecification) => serviceSpecification.active)
      .map(serviceSpecification => ({
        value: serviceSpecification.id,
        label: serviceSpecification.name,
      }));
  }

  render() {
    const { name, value, onChange, label, horizontal, required } = this.props;

    const ServiceSpecificationSelectInner = () => (
      <Input value={value} onChange={e => onChange(e.target.value)} type={'select'}>
        <option value="" />
        {this.options.map(option => (
          <option value={option.value} key={option.value}>
            {option.label}
          </option>
        ))}
      </Input>
    );

    return (
      <FormGroup row={horizontal}>
        <Label for={name} md={horizontal ? 3 : undefined}>
          {label} {required && '*'}
        </Label>
        {horizontal && withColumn()(<ServiceSpecificationSelectInner />)}
        {!horizontal && <ServiceSpecificationSelectInner />}
      </FormGroup>
    );
  }
}
