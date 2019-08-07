import { FormikProps } from 'formik';
import { curryRight } from 'lodash';
import * as React from 'react';
import { Link } from 'react-router-dom';
import Button from 'reactstrap/lib/Button';
import Form from 'reactstrap/lib/Form';
import { FormValues as RegisterFormValues } from './RegisterForm';
import { WithPageValidationsProps } from './ValidatablePage';

interface PagedFormProps {
  formikProps: FormikProps<RegisterFormValues>;
  pages: Array<React.ComponentType<WithPageValidationsProps>>;
  currentPage: number;
}

function getNextButton(toPage: number, currentPageIsValid: boolean) {
  const title = currentPageIsValid ? undefined : 'Das Formular hat noch ungültige Felder';
  return (
    <Link to={`/register/${toPage}`}>
      <Button disabled={!currentPageIsValid} title={title}>Vorwärts</Button>
    </Link>
  );
}

function getSubmitButton(formikProps: FormikProps<RegisterFormValues>, currentPageIsValid: boolean) {
  return (
    <Button
      color={'primary'}
      disabled={formikProps.isSubmitting || !currentPageIsValid}
      onClick={formikProps.submitForm}
    >
      Registrieren
    </Button>
  );
}

export const PagedForm: React.FunctionComponent<PagedFormProps> = props => {
  const { formikProps, pages, currentPage } = props;
  const [currentPageIsValid, setCurrentPageValidity] = React.useState(false);

  const sanitizedPage = Math.max(Math.min(currentPage, pages.length), 1);
  const CurrentPage = pages[sanitizedPage - 1];
  const isLast = currentPage === pages.length;

  const nextButton = getNextButton(sanitizedPage + 1, currentPageIsValid);
  const submitButton = getSubmitButton(formikProps, currentPageIsValid);

  return (
    <Form onSubmit={formikProps.handleSubmit}>
      <CurrentPage onValidityChange={setCurrentPageValidity}/>
      <Link to={`/register/${sanitizedPage - 1}`}>
        <Button disabled={sanitizedPage === 1} className={'mr-2'}>Zurück</Button>
      </Link>
      {isLast ? submitButton : nextButton}
    </Form>
  );
};

const withPageImplementation = (page: number, EnhancedComponent: React.ComponentType<any & { currentPage: number }>) =>
  (props: any) => <EnhancedComponent currentPage={page} {...props} />;

export const withPage = curryRight(withPageImplementation);
