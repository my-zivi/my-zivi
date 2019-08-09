import { FormikProps } from 'formik';
import * as H from 'history';
import { clamp, curryRight } from 'lodash';
import * as React from 'react';
import { Link } from 'react-router-dom';
import Button from 'reactstrap/lib/Button';
import Form from 'reactstrap/lib/Form';
import { Spinner } from '../../utilities/Spinner';
import { FormValues as RegisterFormValues } from './RegisterForm';
import { ValidatablePageRefType, WithPageValidationsProps } from './ValidatablePage';

interface PagedFormProps {
  formikProps: FormikProps<RegisterFormValues>;
  pages: Array<React.RefForwardingComponent<ValidatablePageRefType, WithPageValidationsProps>>;
  currentPage: number;
  history: H.History;
}

const getNextButton = (isDisabled: boolean, onClick: () => void) => {
  const title = isDisabled ? 'Das Formular hat noch ungültige Felder' : undefined;
  return (
    <Button
      disabled={isDisabled}
      onClick={() => onClick()}
      title={title}
    >
      Vorwärts
    </Button>
  );
};

const getSubmitButton = (formikProps: FormikProps<RegisterFormValues>, isDisabled: boolean, onClick: () => void) => {
  return (
    <Button
      color={'primary'}
      disabled={formikProps.isSubmitting || isDisabled}
      onClick={onClick}
    >
      Registrieren
    </Button>
  );
};

export class PagedForm extends React.Component<PagedFormProps, { currentPageIsValid: boolean, isValidating: boolean }> {
  private ref = React.createRef<ValidatablePageRefType>();

  get sanitizedPage() {
    return clamp(this.props.currentPage, 1, this.props.pages.length);
  }

  constructor(props: PagedFormProps) {
    super(props);

    this.state = { currentPageIsValid: false, isValidating: false };
  }

  validateWithServer = (successCallback: () => void) => {
    this.setState({ isValidating: true });
    this.ref.current!.validateWithServer()
      .then(isValid => this.setState({ isValidating: false }, isValid ? successCallback : undefined))
      .catch(() => this.setState({ isValidating: false }));
  }

  nextButtonClicked = () => {
    this.validateWithServer(() => this.props.history.push(`/register/${this.sanitizedPage + 1}`));
  }

  submitButtonClicked = () => {
    this.validateWithServer(this.props.formikProps.submitForm);
  }

  render() {
    const { formikProps, pages, currentPage } = this.props;

    const CurrentPageComponent = pages[this.sanitizedPage - 1];
    const isLast = currentPage === pages.length;

    const isDisabled = !this.state.currentPageIsValid || this.state.isValidating;
    const nextButton = getNextButton(isDisabled, this.nextButtonClicked);
    const submitButton = getSubmitButton(formikProps, isDisabled, this.submitButtonClicked);

    return (
      <Form onSubmit={formikProps.handleSubmit}>
        <CurrentPageComponent onValidityChange={valid => this.setState({ currentPageIsValid: valid })} ref={this.ref}/>
        <Link to={`/register/${this.sanitizedPage - 1}`}>
          <Button disabled={this.sanitizedPage === 1} className={'mr-2'}>Zurück</Button>
        </Link>
        {isLast ? submitButton : nextButton}
        {this.state.isValidating && <Spinner size="sm" className="ml-3" />}
      </Form>
    );
  }
}

const withPageImplementation = (page: number, EnhancedComponent: React.ComponentType<any & { currentPage: number }>) =>
  (props: any) => <EnhancedComponent currentPage={page} {...props} />;

export const withPage = curryRight(withPageImplementation);
