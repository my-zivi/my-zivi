import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Formik, FormikActions } from 'formik';
import { inject } from 'mobx-react';
import * as React from 'react';
import injectSheet, { WithSheet } from 'react-jss';
import Button from 'reactstrap/lib/Button';
import Table from 'reactstrap/lib/Table';
import Tooltip from 'reactstrap/lib/Tooltip';
import { CheckboxField } from '../../form/CheckboxField';
import { TextField } from '../../form/common';
import { WiredField } from '../../form/formik';
import IziviContent from '../../layout/IziviContent';
import { MainStore } from '../../stores/mainStore';
import { ServiceSpecificationStore } from '../../stores/serviceSpecificationStore';
import { ServiceSpecification } from '../../types';
import { PlusSquareRegularIcon, SaveRegularIcon } from '../../utilities/Icon';
import serviceSpecificationStyles from './serviceSpecificationOverviewStyle';
import serviceSpecificationSchema from './serviceSpecificationSchema';

interface ServiceSpecificationProps extends WithSheet<typeof serviceSpecificationStyles> {
  serviceSpecificationStore?: ServiceSpecificationStore;
  mainStore?: MainStore;
}

interface ServiceSpecificationState {
  loading: boolean;
  openThTooltips: boolean[][];
}

interface Th<T> {
  label: string;
  tooltip?: string;
  span?: {
    col?: number;
    row?: number;
  };
  className?: string;
}

@inject('serviceSpecificationStore', 'mainStore')
export class ServiceSpecificationsOverviewInner extends React.Component<ServiceSpecificationProps, ServiceSpecificationState> {
  columns: Array<Array<Th<ServiceSpecification>>> = [];

  constructor(props: ServiceSpecificationProps) {
    super(props);

    this.props.serviceSpecificationStore!.fetchAll().then(() => {
      this.setState({ loading: false });
    });

    this.state = {
      loading: true,
      openThTooltips: [[], []],
    };

    this.columns[0] = [
      {
        label: 'Aktiv',
        span: {
          row: 2,
        },
      },
      {
        label: 'ID',
        span: {
          row: 2,
        },
      },
      {
        label: 'Name',
        span: {
          row: 2,
        },
      },
      {
        label: 'KN',
        tooltip: 'Kurz-Name',
        span: {
          row: 2,
        },
      },
      {
        label: 'Taschengeld',
        span: {
          row: 2,
        },
      },
      {
        label: 'Unterkunft',
        span: {
          row: 2,
        },
      },
      {
        label: 'Kleider',
        span: {
          row: 2,
        },
      },
      {
        label: 'Frühstück',
        span: {
          col: 4,
        },
      },
      {
        label: 'Mittagessen',
        span: {
          col: 4,
        },
      },
      {
        label: 'Abendessen',
        span: {
          col: 6,
        },
      },
    ];

    this.columns[1] = [
      {
        label: 'Erster Tag',
      },
      {
        label: 'Arbeit',
      },
      {
        label: 'Frei',
      },
      {
        label: 'Letzter Tag',
      },
      {
        label: 'Erster Tag',
      },
      {
        label: 'Arbeit',
      },
      {
        label: 'Frei',
      },
      {
        label: 'Letzter Tag',
      },
      {
        label: 'Erster Tag',
      },
      {
        label: 'Arbeit',
      },
      {
        label: 'Frei',
      },
      {
        label: 'Letzter Tag',
      },
      {
        label: '',
        span: {
          col: 2,
        },
      },
    ];
  }

  handleThTooltip = (row: number, id: number): void => {
    const opens = this.state.openThTooltips;

    opens[row][id] = opens[row][id] ? !opens[row][id] : true;

    this.setState({ openThTooltips: opens });
  }

  handleSubmit = async (entity: ServiceSpecification, actions: FormikActions<ServiceSpecification>) => {
    this.props.serviceSpecificationStore!.put(serviceSpecificationSchema.cast(entity)).then(() => actions.setSubmitting(false));
  }

  handleAdd = async (entity: ServiceSpecification, actions: FormikActions<ServiceSpecification>) => {
    await this.props.serviceSpecificationStore!.post(serviceSpecificationSchema.cast(entity)).then(() => {
      actions.setSubmitting(false);
      actions.resetForm();
    });
  }

  render() {
    const entities = this.props.serviceSpecificationStore!.entities;
    const { classes } = this.props!;
    const { openThTooltips } = this.state;

    return (
      <IziviContent loading={this.state.loading} title={'Pflichtenheft'} card={true}>
        <Table hover={true} responsive={true}>
          <thead>
            {this.columns.map((col, colI) => {
              const thClass = colI === 0 ? classes.th : classes.secondTh;

              return (
                <tr key={colI}>
                  {/*{' '}*/}
                  {col.map((th, thI) => {
                    let content = <>{th.label}</>;

                    if (th.tooltip) {
                      content = (
                        <>
                          <div id={'thTooltips' + thI}>{th.label}</div>
                          <Tooltip
                            placement="bottom"
                            target={'thTooltips' + thI}
                            isOpen={(openThTooltips[colI] && openThTooltips[colI][thI]) || false}
                            toggle={() => this.handleThTooltip(thI, colI)}
                          >
                            {th.tooltip}
                          </Tooltip>
                        </>
                      );
                    }

                    return (
                      <th
                        className={thClass}
                        key={thI}
                        rowSpan={th.span ? th.span.row || 1 : 1}
                        colSpan={th.span ? th.span.col || 1 : 1}
                      >
                        {content}
                      </th>
                    );
                  })}
                </tr>
              );
            })}
          </thead>
          <tbody>
            <Formik
              validationSchema={serviceSpecificationSchema}
              initialValues={{
                id: '',
                name: '',
                short_name: '',
                accommodation: 0,
                active: false,
                firstday_breakfast_expenses: 0,
                firstday_dinner_expenses: 0,
                firstday_lunch_expenses: 0,
                lastday_breakfast_expenses: 0,
                lastday_dinner_expenses: 0,
                lastday_lunch_expenses: 0,
                pocket: 0,
                sparetime_breakfast_expenses: 0,
                sparetime_dinner_expenses: 0,
                sparetime_lunch_expenses: 0,
                working_breakfast_expenses: 0,
                working_clothes_expense: 0,
                working_clothes_payment: '',
                working_dinner_expenses: 0,
                working_lunch_expenses: 0,
                working_time_model: 0,
                working_time_weekly: '',
              }}
              onSubmit={this.handleAdd}
              render={formikProps => (
                <tr>
                  <ServiceSpecificationFormFields {...this.props} />
                  <td className={classes.buttonsTd}>
                    <Button
                      className={classes.smallFontSize}
                      color={'success'}
                      disabled={formikProps.isSubmitting}
                      onClick={formikProps.submitForm}
                    >
                      <FontAwesomeIcon icon={PlusSquareRegularIcon} />
                    </Button>
                  </td>
                  <td />
                </tr>
              )}
            />
            {entities.map(serviceSpecification => (
              <Formik
                key={serviceSpecification.id}
                validationSchema={serviceSpecificationSchema}
                initialValues={serviceSpecification}
                onSubmit={this.handleSubmit}
                render={formikProps => (
                  <tr>
                    <ServiceSpecificationFormFields {...this.props} />
                    <td className={classes.buttonsTd}>
                      <Button
                        className={classes.smallFontSize}
                        color={'success'}
                        disabled={formikProps.isSubmitting}
                        onClick={formikProps.submitForm}
                      >
                        <FontAwesomeIcon icon={SaveRegularIcon} />
                      </Button>
                    </td>
                  </tr>
                )}
              />
            ))}
          </tbody>
        </Table>
      </IziviContent>
    );
  }
}

interface SpecFormFieldProps extends WithSheet<typeof serviceSpecificationStyles> {}

const ServiceSpecificationFormFields = ({ classes }: SpecFormFieldProps) => (
  <>
    <td className={classes.rowTd}>
      <WiredField className={classes.checkboxes} component={CheckboxField} name={'active'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'id'} size={'3'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'name'} size={'20'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'short_name'} size={'1'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'pocket'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'accommodation'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'working_clothes_expense'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'firstday_breakfast_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'working_breakfast_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'sparetime_breakfast_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'lastday_breakfast_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'firstday_breakfast_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'working_breakfast_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'sparetime_breakfast_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'lastday_breakfast_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'firstday_dinner_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'working_dinner_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'sparetime_dinner_expenses'} size={'5'} />
    </td>
    <td className={classes.rowTd}>
      <WiredField className={classes.inputs} component={TextField} name={'lastday_dinner_expenses'} size={'5'} />
    </td>
  </>
);

export const ServiceSpecificationsOverview = injectSheet(serviceSpecificationStyles)(ServiceSpecificationsOverviewInner);
