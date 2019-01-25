import React from 'react';
import { inject, observer } from 'mobx-react';
import Input from 'reactstrap/lib/Input';
import { SpecificationStore } from 'src/stores/specificationStore';
import { FieldProps } from 'formik';
import Label from 'reactstrap/lib/Label';
import { withColumn } from '../common';
import FormGroup from 'reactstrap/lib/FormGroup';
import { Specification } from 'src/types';

type Props = {
  specificationStore?: SpecificationStore;
  label?: string;
  required?: boolean;
  horizontal?: boolean;
} & FieldProps;

@inject('specificationStore')
@observer
export class SpecificationSelect extends React.Component<Props> {
  public get options() {
    return this.props
      .specificationStore!.entities.filter((sp: Specification) => sp.active)
      .map(e => ({
        value: e.id,
        label: e.name,
      }));
  }

  public render() {
    const { field, label, horizontal, required } = this.props;

    const SpecificationSelectInner = () => (
      <Input {...field} type={'select'}>
        <option value="" key="-1" />
        {this.options.map(option => (
          <option value={option.value} key={option.value}>
            {option.label}
          </option>
        ))}
      </Input>
    );

    return (
      <FormGroup row={horizontal}>
        <Label for={field.name} md={horizontal ? 3 : undefined}>
          {label} {required && '*'}
        </Label>
        {horizontal && withColumn()(<SpecificationSelectInner />)}
        {!horizontal && <SpecificationSelectInner />}
      </FormGroup>
    );
  }
}
