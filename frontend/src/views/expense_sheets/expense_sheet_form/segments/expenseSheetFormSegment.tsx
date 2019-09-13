import * as React from 'react';
import { SolidHorizontalRow } from '../../../../layout/SolidHorizontalRow';

export const expenseSheetFormSegment: <T>(Component: React.ComponentType<T>) => (props: T) => React.ReactElement = Component => props => (
  <>
    <Component {...props}/>
    <SolidHorizontalRow/>
  </>
);
