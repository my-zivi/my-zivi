import { inject } from 'mobx-react';
import moment from 'moment';
import * as React from 'react';

import injectSheet, { WithSheet } from 'react-jss';
import Button from 'reactstrap/lib/Button';
import Col from 'reactstrap/lib/Col';
import Container from 'reactstrap/lib/Container';
import Row from 'reactstrap/lib/Row';
import Table from 'reactstrap/lib/Table';
import { CheckboxField } from '../../form/CheckboxField';
import { SelectField } from '../../form/common';
import IziviContent from '../../layout/IziviContent';
import { LoadingInformation } from '../../layout/LoadingInformation';
import { ServiceStore } from '../../stores/serviceStore';
import { SpecificationStore } from '../../stores/specificationStore';
import { Service } from '../../types';
import { ServiceRow } from './ServiceRow';
import { ServiceStyles } from './ServiceStyles';

interface ServiceOverviewProps extends WithSheet<typeof ServiceStyles> {
  specificationStore?: SpecificationStore;
  serviceStore?: ServiceStore;
}

interface ServiceOverviewState {
  loadingServices: boolean;
  loadingSpecifications: boolean;
  selectedSpecifications: Map<number, boolean>;
  fetchYear: string;
  serviceRows: Map<number, React.ReactNode>;
  monthHeaders: React.ReactNode[];
  weekHeaders: React.ReactNode[];
  totalCount: number;
  weekTotalHeaders: React.ReactNode[];
  weekCount: Map<number, Map<number, number>>;
}

@inject('serviceStore', 'specificationStore')
class ServiceOverviewContent extends React.Component<ServiceOverviewProps, ServiceOverviewState> {
  cookiePrefixSpec = 'service-overview-checkbox-';
  cookieYear = 'service-overview-year';
  currYear = moment().year();
  monthNames = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  constructor(props: ServiceOverviewProps) {
    super(props);

    const localCookieYear = window.localStorage.getItem(this.cookieYear);
    this.state = {
      loadingServices: true,
      loadingSpecifications: true,
      fetchYear: localCookieYear == null ? this.currYear.toString() : localCookieYear!,
      selectedSpecifications: new Map<number, boolean>(),
      monthHeaders: [],
      weekHeaders: [],
      totalCount: 0,
      weekTotalHeaders: [],
      serviceRows: new Map<number, React.ReactNode>(),
      weekCount: new Map<number, Map<number, number>>(),
    };
  }

  componentDidMount(): void {
    this.loadSpecifications();
    this.loadServices();
  }

  scrollTableHeader(table: HTMLTableElement | null) {
    if (table !== null) {
      const onScroll = () => {
        const offset = window.pageYOffset;
        const tableOffsetTop = table!.getBoundingClientRect().top + window.pageYOffset;
        const thead = table!.querySelector('thead');

        thead!.style.top = offset > tableOffsetTop ? `${offset - tableOffsetTop}px` : '0';
      };

      document.addEventListener('scroll', onScroll);
      onScroll();
    }
  }

  loadSpecifications() {
    this.props.specificationStore!.fetchAll().then(() => {
      const newSpecs = this.state.selectedSpecifications;
      this.props.specificationStore!.entities.forEach(spec => {
        newSpecs[spec.id!] =
          window.localStorage.getItem(this.cookiePrefixSpec + spec.id!) === null
            ? true
            : window.localStorage.getItem(this.cookiePrefixSpec + spec.id!) === 'true';
      });
      this.setState({ selectedSpecifications: newSpecs, loadingSpecifications: false });
    });
  }

  loadServices() {
    this.props.serviceStore!.fetchByYear(this.state.fetchYear).then(() => {
      this.calculateServiceRows();
      this.setState({ loadingServices: false }, () => {
        this.scrollTableHeader(document.querySelector('table'));
      });
    });
  }

  changeSelectedSpecifications(v: boolean, id: string) {
    const newSpec = this.state.selectedSpecifications;
    newSpec[id] = v;
    this.setState({ selectedSpecifications: newSpec }, () => this.updateAverageHeaders());
    window.localStorage.setItem(this.cookiePrefixSpec + id, v.toString());
  }

  selectYear(year: string) {
    window.localStorage.setItem(this.cookieYear, year);
    this.setState({ loadingServices: true, fetchYear: year }, () => {
      this.loadServices();
    });
  }

  calculateServiceRows(): void {
    const fetchYear = parseInt(this.state.fetchYear, 10);
    const { classes } = this.props;

    const weekCount = this.getEmptyWeekCount();

    // First and last date of weeks for popOver
    const startDates: string[] = [];
    const endDates: string[] = [];
    for (let x = 1; x <= 52; x++) {
      startDates[x] = moment(fetchYear + ' ' + x + ' 1', 'YYYY WW E').format('DD.MM.YYYY');
      endDates[x] = moment(fetchYear + ' ' + x + ' 5', 'YYYY WW E').format('DD.MM.YYYY');
    }

    const serviceRows = new Map<number, React.ReactNode>();

    const doneServices: number[] = [];

    this.props.serviceStore!.entities.forEach(service => {
      // if we've already added the row for this user and specification, skip
      if (doneServices.includes(service.id!)) {
        return;
      }

      // getting all services of current user with same specification
      const currServices = this.props.serviceStore!.entities.filter(val => {
        if (val.user_id === service.user_id && val.specification_id === service.specification_id) {
          doneServices.push(val.id!);
          return true;
        }
        return false;
      });

      const cells = this.getServiceCells(startDates, endDates, currServices, weekCount);

      // can use any service in currServices here, because user and specification are the same for each service in array
      // TODO: Make it work
      serviceRows.set(
        service.id!,
        (
          <ServiceRow
            key={'service-row-' + service.id!}
            shortName={service.specification!.short_name}
            specification_id={service.specification_id}
            user_id={service.user_id}
            zdp={1234}
            userName={'Hanspeter'}
            cells={cells}
            classes={classes}
          />
        ),
      );
    });

    this.setState(
      {
        weekCount,
        serviceRows,
      },
      () => {
        this.updateAverageHeaders();
        this.setWeekAndMonthHeaders();
      },
    );
  }

  render() {
    // Specifications that are in use by at least one service
    const specIdsOfServices = this.props
      .serviceStore!.entities.map(service => service.specification_id)
      .filter((elem, index, arr) => index === arr.indexOf(elem));
    specIdsOfServices.sort();

    const { classes, specificationStore } = this.props;

    const title = 'Einsatzübersicht';

    return (
      <IziviContent loading={this.state.loadingSpecifications} title={title} card={true}>
        <Container fluid={true}>
          <Row className={classes.filter} style={{ marginBottom: '2vh' }}>
            <Col sm="12" md="2">
              <div>
                {/* All years from 2005 to next year */}
                <SelectField
                  options={Array.from(Array(this.currYear - 2003).keys())
                    .map(k => {
                      return {
                        id: (2005 + k).toString(),
                        name: (2005 + k).toString(),
                      };
                    })
                    .reverse()}
                  onChange={e => this.selectYear(e.target.value)}
                  value={this.state.fetchYear}
                />
              </div>
            </Col>

            <Col sm="12" md="8">
              <div>
                {// Mapping a CheckboxField to every specification in use
                specIdsOfServices.map(id => {
                  const currSpec = specificationStore!.entities.filter(spec => spec.id! === id)[0];
                  return (
                    <CheckboxField
                      key={currSpec.id!}
                      onChange={(v: boolean) => this.changeSelectedSpecifications(v, currSpec.id!)}
                      name={currSpec.id!.toString()}
                      value={this.state.selectedSpecifications[currSpec.id!]}
                      label={currSpec.name}
                      horizontal={false}
                    />
                  );
                })}
              </div>
            </Col>

            <Col sm="12" md="2">
              <Button
                onClick={() => {
                  window.print();
                }}
              >
                Drucken
              </Button>
            </Col>
          </Row>

          {this.state.loadingServices ? (
            <LoadingInformation />
          ) : (
            <Row>
              <Table responsive={true} striped={true} bordered={true} className={'table-no-padding'} id="service_overview_table">
                <thead>
                  <tr>
                    <td colSpan={3} rowSpan={2} className={classes.rowTd + ' mo-name-header'}>
                      Name
                    </td>
                    {this.state.monthHeaders}
                  </tr>
                  <tr>{this.state.weekHeaders}</tr>
                  <tr>
                    <td
                      colSpan={3}
                      style={{ textAlign: 'left', paddingLeft: '8px !important', fontWeight: 'bold', whiteSpace: 'nowrap' }}
                      className={classes.rowTd}
                    >
                      Ø / Woche: {(this.state.totalCount / 52).toFixed(2)}
                    </td>
                    {this.state.weekTotalHeaders}
                  </tr>
                </thead>
                <tbody>
                  {this.props.serviceStore!.entities.map(service => {
                    if (this.state.selectedSpecifications[service.specification_id]) {
                      return this.state.serviceRows.get(service.id!);
                    }
                    return;
                  })}
                </tbody>
              </Table>
            </Row>
          )}
        </Container>
      </IziviContent>
    );
  }

  setWeekAndMonthHeaders(): void {
    const { classes } = this.props;

    const weekHeaders = [];
    const monthHeaders = [];
    let monthColCount = 0;

    // setting currDate to monday in fetchYear's ISO week 1
    const currDate = moment()
      .year(parseInt(this.state.fetchYear, 10))
      .isoWeek(1)
      .isoWeekday(1)
      .toDate();
    // get month of monday in currDate's week (= fetchYear's week 1)
    let currMonth = moment(currDate)
      .isoWeekday(1)
      .month();

    // looping through every week of the year
    for (let currWeek = 1; currWeek <= 52; currWeek++) {
      weekHeaders.push(
        (
          <td className={classes.rowTd} key={currWeek}>
            {currWeek}
          </td>
        ),
      );
      if (
        moment(currDate)
          .isoWeekday(1)
          .month() !== currMonth
      ) {
        // if we're in a new month
        monthHeaders.push(
          (
            <td
              className={classes.rowTd}
              style={{ fontWeight: 'bold', maxWidth: 25 * monthColCount + 'px', overflow: 'hidden', wordWrap: 'normal' }}
              colSpan={monthColCount}
              key={'month_header_' + currWeek}
            >
              {this.monthNames[currMonth]}
            </td>
          ),
        );
        monthColCount = 0;
        // setting currMonth to the new month
        currMonth = moment(currDate).month();
      }
      // making month cell bigger by one col, to fit one week
      monthColCount++;
      // increasing date by a week
      currDate.setDate(currDate.getDate() + 7);
    }

    // pushing final month
    monthHeaders.push(
      (
        <td
          className={classes.rowTd}
          style={{ fontWeight: 'bold' }}
          colSpan={monthColCount}
          key={this.monthNames.indexOf(this.monthNames[currMonth])}
        >
          {this.monthNames[currMonth]}
        </td>
      ),
    );

    this.setState({ monthHeaders, weekHeaders });
  }

  updateAverageHeaders(): void {
    const { classes } = this.props;
    const weekTotalHeaders = [];
    let totalCount = 0;
    for (let currWeek = 1; currWeek <= 52; currWeek++) {
      let weekCountSum = 0;

      this.props.specificationStore!.entities.forEach(spec => {
        if (this.state.selectedSpecifications[spec.id!]) {
          weekCountSum += this.state.weekCount[spec.id!][currWeek];
        }
      });
      weekTotalHeaders.push(
        (
          <td className={classes.rowTd} key={currWeek}>
            {weekCountSum}
          </td>
        ),
      );
      totalCount += weekCountSum;
    }
    this.setState({ weekTotalHeaders, totalCount });
  }

  getServiceCells(
    startDates: string[],
    endDates: string[],
    currServices: Service[],
    weekCount: Map<number, Map<number, number>>,
  ): React.ReactNode[] {
    const cells: React.ReactNode[] = [];
    const { classes } = this.props;

    // filling ServiceRow for currServices
    for (let currWeek = 1; currWeek <= 52; currWeek++) {
      const popOverStart = startDates[currWeek];
      const popOverEnd = endDates[currWeek];
      const title = popOverStart + ' - ' + popOverEnd;

      const currService = this.getActiveServiceInWeek(currWeek, currServices);

      if (currService == null) {
        // no service in this week
        cells.push(
          (
            <td key={currWeek} title={title} className={classes.rowTd}>
              {''}
            </td>
          ),
        );
      } else {
        // service in this week
        if (weekCount[currService.specification_id]) {
          // increasing weekCount for this specification
          weekCount[currService.specification_id][currWeek]++;
        }

        // different styling depending on whether the service is a draft or not
        const einsatz = currService.confirmation_date == null ? classes.einsatzDraft : classes.einsatz;

        if (this.isWeekStartWeek(currWeek, currService)) {
          const content = moment(currService.beginning!)
            .date()
            .toString();
          cells.push(
            (
              <td key={currWeek} title={title} className={classes.rowTd + ' ' + einsatz}>
                {content}
              </td>
            ),
          );
        } else if (this.isWeekEndWeek(currWeek, currService)) {
          const content = moment(currService.ending!)
            .date()
            .toString();
          cells.push(
            (
              <td key={currWeek} title={title} className={classes.rowTd + ' ' + einsatz}>
                {content}
              </td>
            ),
          );
        } else {
          // Week must be during a service, but not the ending or starting week
          cells.push(
            (
              <td key={currWeek} title={title} className={classes.rowTd + ' ' + einsatz}>
                {'x'}
              </td>
            ),
          );
        }
      }
    }

    return cells;
  }

  isWeekStartWeek(week: number, service: Service): boolean {
    return week === this.getStartWeek(service);
  }

  isWeekMiddleWeek(week: number, service: Service): boolean {
    const startWeek = this.getStartWeek(service);
    const endWeek = this.getEndWeek(service);

    return week > startWeek && week < endWeek;
  }

  isWeekEndWeek(week: number, service: Service): boolean {
    return week === this.getEndWeek(service);
  }

  isWeekDuringService(week: number, service: Service): boolean {
    return this.isWeekStartWeek(week, service) || this.isWeekMiddleWeek(week, service) || this.isWeekEndWeek(week, service);
  }

  getActiveServiceInWeek(week: number, services: Service[]): Service | null {
    let ret: Service | null = null;
    services.forEach(service => {
      if (this.isWeekDuringService(week, service)) {
        ret = service;
      }
    });
    return ret;
  }

  getStartWeek(service: Service): number {
    let startWeek = moment(service.beginning!).isoWeek();
    if (moment(service.beginning!).year() < parseInt(this.state.fetchYear, 10)) {
      startWeek = -1;
    }
    return startWeek;
  }

  getEndWeek(service: Service): number {
    let endWeek = moment(service.ending!).isoWeek();
    if (moment(service.ending!).year() > parseInt(this.state.fetchYear, 10)) {
      endWeek = 55;
    }
    return endWeek;
  }

  getEmptyWeekCount(): Map<number, Map<number, number>> {
    const weekCount = new Map<number, Map<number, number>>();
    for (const spec of this.props.specificationStore!.entities) {
      weekCount[spec.id!] = [];
      for (let i = 1; i <= 52; i++) {
        weekCount[spec.id!][i] = 0;
      }
    }
    return weekCount;
  }
}

export const ServiceOverview = injectSheet(ServiceStyles)(ServiceOverviewContent);
