import { connect, FormikProps } from 'formik';
import { curry, debounce, isEqual } from 'lodash';
import * as React from 'react';

const DEBOUNCE_DELAY = 500;

export interface PersistedFormInnerProps {
  name: string;
}

type FormikConnectedProps = PersistedFormInnerProps & { formik: FormikProps<any> };

class PersistedFormInner extends React.Component<FormikConnectedProps, {}> {
  private saveCurrentState = debounce((data: FormikProps<{}>) => {
    window.sessionStorage.setItem(this.props.name, JSON.stringify(data));
  }, DEBOUNCE_DELAY);

  componentDidUpdate(prevProps: FormikConnectedProps) {
    if (!isEqual(prevProps.formik, this.props.formik)) {
      this.saveCurrentState(this.props.formik);
    }
  }

  componentDidMount() {
    const restoredState = window.sessionStorage.getItem(this.props.name);
    if (restoredState && restoredState.length >= 0) {
      this.props.formik.setFormikState({
        ...JSON.parse(restoredState),
        isSubmitting: false,
        isValidating: false,
      });
    }
  }

  render() {
    return this.props.children;
  }
}

const PersistedForm = connect<PersistedFormInnerProps, any>(PersistedFormInner);

type WithFormPersistenceHOC =
  <T, S extends FormikProps<T>>(name: string, WrappedComponent: React.ComponentType<S>) =>
    (props: S) => React.ReactNode;

const withFormPersistenceImplementation: WithFormPersistenceHOC = (name, WrappedComponent) => {
  return props => (
    <PersistedForm name={name}>
      <WrappedComponent {...props} />
    </PersistedForm>
  );
};

export const withFormPersistence = curry(withFormPersistenceImplementation);
