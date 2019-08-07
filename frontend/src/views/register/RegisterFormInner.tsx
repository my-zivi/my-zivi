import { FormikProps } from 'formik';
import * as React from 'react';
import injectSheet, { WithSheet } from 'react-jss';
import { Link } from 'react-router-dom';
import Breadcrumb from 'reactstrap/lib/Breadcrumb';
import BreadcrumbItem from 'reactstrap/lib/BreadcrumbItem';
import createStyles from '../../utilities/createStyles';
import { PagedForm } from './PagedForm';
import { REGISTER_FORM_PAGES } from './pages';
import { FormValues } from './RegisterForm';

const breadcrumbStyles = () => createStyles({
  activeBreadcrumb: {
    color: '#1565C0',
  },
  disabledBreadcrumb: {
    'color': '#b6b6b6',
    '&:hover': {
      color: '#b6b6b6',
      textDecoration: 'none',
      cursor: 'default',
    },
  },
  pastBreadcrumb: {
    color: '#1E88E5',
  },
});

function getBreadcrumbClassName(breadcrumbPage: number, currentPage: number, classes: any) {
  if (currentPage === breadcrumbPage) {
    return classes.activeBreadcrumb;
  } else if (breadcrumbPage < currentPage) {
    return classes.pastBreadcrumb;
  } else {
    return classes.disabledBreadcrumb;
  }
}

function getBreadcrumbItem(index: number, title: string, currentPage: number, classes: any) {
  const breadcrumbPage = index + 1;

  const className = getBreadcrumbClassName(breadcrumbPage, currentPage, classes);
  const isDisabled = className === classes.disabledBreadcrumb;

  return (
    <BreadcrumbItem
      tag="span"
      key={index}
      href={'#'}
      onClick={(event: any) => event.preventDefault()}
    >
      <Link to={isDisabled ? '#' : '/register/' + breadcrumbPage} className={className}>
        {title}
      </Link>
    </BreadcrumbItem>
  );
}

interface RegisterFormInnerProps extends WithSheet<typeof breadcrumbStyles> {
  currentPage: number;
}

const RegisterFormInnerImplementation = (props: FormikProps<FormValues> & RegisterFormInnerProps) => {
  const { currentPage, ...formikProps } = props;

  return (
    <>
      <Breadcrumb>
        {
          [...REGISTER_FORM_PAGES, { title: 'Registration' }]
            .map(({ title }, index) => getBreadcrumbItem(index, title, currentPage, props.classes))}
      </Breadcrumb>
      <PagedForm formikProps={formikProps} currentPage={currentPage} pages={REGISTER_FORM_PAGES.map(({ component }) => component)}/>
    </>
  );
};
export const RegisterFormInner = injectSheet(breadcrumbStyles)(RegisterFormInnerImplementation);
