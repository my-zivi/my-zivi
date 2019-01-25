import * as React from 'react';
import { TransformingField, TransformingFieldProps } from './TransformingField';

const factor = 100;
const toString = ((n: number) => (n / factor).toFixed(2)) as any;
const toValue = (s: string) => Math.round(Number(s) * factor);

const CurrencyField = (props: TransformingFieldProps<number>) => {
  const labels = ['CHF', ...(props.appendedLabels || [])];
  return <TransformingField {...props} toString={toString} toValue={toValue} type={'number'} appendedLabels={labels} />;
};
export default CurrencyField;
