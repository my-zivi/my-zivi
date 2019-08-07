import { connect, ErrorMessage, FormikProps } from 'formik';
import { curry, isEmpty, pick } from 'lodash';
import * as React from 'react';

type ValidityCallback = (valid: boolean) => void;

export interface ValidatablePageInnerProps {
  validatableFields: string[];
  onValidityChange: ValidityCallback;
}

interface ValidatablePageInnerState {
  isValid: boolean;
}

type ValidatablePageInnerFullProps = ValidatablePageInnerProps & { formik: FormikProps<any> };

class ValidatablePageInner extends React.Component<ValidatablePageInnerFullProps, ValidatablePageInnerState> {
  constructor(props: ValidatablePageInnerFullProps) {
    super(props);

    this.state = { isValid: false };
  }

  componentDidMount() {
    this.setState({ isValid: this.isValid() });
  }

  componentDidUpdate(prevProps: any, prevState: Readonly<ValidatablePageInnerState>) {
    const isValid = this.isValid();

    if (isValid !== prevState.isValid) {
      this.props.onValidityChange(isValid);
      this.setState({ isValid });
    }
  }

  isValid() {
    return isEmpty(pick(this.props.formik.errors, this.props.validatableFields));
  }

  render() {
    return (
      <>
        {this.props.validatableFields.map(field => (
          <div style={{color: 'red'}} key={field}>
            <ErrorMessage name={field} />
          </div>
        ))}

        {this.props.children}
      </>
    );
  }
}

const ValidatablePage = connect<ValidatablePageInnerProps, any>(ValidatablePageInner);

export interface WithPageValidationsProps {
  onValidityChange: ValidityCallback;

  [key: string]: any;
}

export const withPageValidations = curry(
  (validatableFields: string[], Component: React.ComponentType) =>
    ({ onValidityChange, ...rest }: WithPageValidationsProps) => (
      <ValidatablePage validatableFields={validatableFields} onValidityChange={onValidityChange}>
        <Component {...rest}/>
      </ValidatablePage>
    ),
);
