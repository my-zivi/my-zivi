import axios from 'axios';
import { connect, ErrorMessage, FormikProps } from 'formik';
import { curry, isEmpty, pick } from 'lodash';
import * as React from 'react';
import { ApiStore, baseUrl } from '../../stores/apiStore';
import { DomainStore } from '../../stores/domainStore';
import { UserStore } from '../../stores/userStore';
import { displayError } from '../../utilities/notification';

type ValidityCallback = (valid: boolean) => void;

export type ValidatablePageRefType = ValidatablePageInner;

export interface ValidatablePageInnerProps {
  validatableFields: string[];
  onValidityChange: ValidityCallback;
  ref: React.Ref<ValidatablePageRefType>;
  userStore?: UserStore;
}

interface ValidatablePageInnerState {
  isValid: boolean;
  dirty: boolean;
}

type ValidatablePageInnerFullProps = ValidatablePageInnerProps & { formik: FormikProps<any> };

class ValidatablePageInner extends React.Component<ValidatablePageInnerFullProps, ValidatablePageInnerState> {
  private axiosClient = axios.create({ baseURL: baseUrl });

  constructor(props: ValidatablePageInnerFullProps) {
    super(props);

    this.state = { isValid: false, dirty: false };
  }

  async validateWithServer() {
    const fieldsToBeValidated = pick(this.props.formik.values, this.props.validatableFields);
    if (fieldsToBeValidated.bank_iban) {
      fieldsToBeValidated.bank_iban = ApiStore.formatIBAN(fieldsToBeValidated.bank_iban);
    }

    try {
      await this.axiosClient.post('/users/validate', { user: fieldsToBeValidated });

      this.setState({ isValid: false });
      this.props.onValidityChange(true);

      return true;
    } catch (error) {
      const { response: { data } } = error;

      this.setState({ isValid: false });
      this.props.onValidityChange(false);

      displayError(DomainStore.buildErrorMessage({ messages: data }, 'Ein Fehler ist aufgetreten'));
      return false;
    } finally {
      this.setState({ dirty: true });
    }
  }

  componentDidMount() {
    this.setState({ isValid: this.isValid() });
  }

  componentDidUpdate(prevProps: any, prevState: Readonly<ValidatablePageInnerState>) {
    const isValid = this.isValid();

    if (isValid !== prevState.isValid  || this.state.dirty) {
      this.props.onValidityChange(isValid);
      this.setState({ isValid, dirty: false });
    }
  }

  isValid() {
    return isEmpty(pick(this.props.formik.errors, this.props.validatableFields));
  }

  render() {
    return (
      <>
        {this.props.validatableFields.map(field => (
          <div className="text-danger" key={field}>
            <ErrorMessage name={field}/>
          </div>
        ))}

        {this.props.children}
      </>
    );
  }
}

const ValidatablePage = React.forwardRef<ValidatablePageInner, React.PropsWithChildren<ValidatablePageInnerProps>>((props, ref) =>
  (connect<ValidatablePageInnerProps, any>(ValidatablePageInner) as React.FunctionComponent<ValidatablePageInnerProps>)({ ...props, ref }),
);

export interface WithPageValidationsProps {
  onValidityChange: ValidityCallback;

  [key: string]: any;
}

export const withPageValidations = curry(
  (validatableFields: string[], EnhancedComponent: React.ComponentType) =>
    React.forwardRef<ValidatablePageRefType, WithPageValidationsProps>(({ onValidityChange, ...rest }, ref) => (
      <ValidatablePage validatableFields={validatableFields} onValidityChange={onValidityChange} ref={ref}>
        <EnhancedComponent {...rest}/>
      </ValidatablePage>
    )),
);
