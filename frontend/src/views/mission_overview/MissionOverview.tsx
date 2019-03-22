import { inject } from 'mobx-react';
import moment from 'moment';
import * as React from 'react';
import { SelectField } from '../../form/common';
import IziviContent from '../../layout/IziviContent';
import { MissionStore } from '../../stores/missionStore';
import { SpecificationStore } from '../../stores/specificationStore';
import { Mission } from '../../types';

import injectSheet, { WithSheet } from 'react-jss';
import Button from 'reactstrap/lib/Button';
import Col from 'reactstrap/lib/Col';
import Container from 'reactstrap/lib/Container';
import Row from 'reactstrap/lib/Row';
import Table from 'reactstrap/lib/Table';
import { CheckboxField } from '../../form/CheckboxField';
import { LoadingInformation } from '../../layout/LoadingInformation';
import { MissionRow } from './MissionRow';
import { MissionStyles } from './MissionStyles';

interface MissionOverviewProps extends WithSheet<typeof MissionStyles> {
  specificationStore?: SpecificationStore;
  missionStore?: MissionStore;
}

interface MissionOverviewState {
  loadingMissions: boolean;
  loadingSpecifications: boolean;
  selectedSpecifications: Map<number, boolean>;
  fetchYear: string;
  missionRows: Map<number, React.ReactNode>;
  monthHeaders: React.ReactNode[];
  weekHeaders: React.ReactNode[];
  totalCount: number;
  weekTotalHeaders: React.ReactNode[];
  weekCount: Map<number, Map<number, number>>;
}

@inject('missionStore', 'specificationStore')
class MissionOverviewContent extends React.Component<MissionOverviewProps, MissionOverviewState> {
  cookiePrefixSpec = 'mission-overview-checkbox-';
  cookieYear = 'mission-overview-year';
  currYear = moment().year(); // new Date().getFullYear();
  monthNames = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  constructor(props: MissionOverviewProps) {
    super(props);

    this.state = {
      loadingMissions: true,
      loadingSpecifications: true,
      fetchYear:
        window.localStorage.getItem(this.cookieYear) == null ? this.currYear.toString() : window.localStorage.getItem(this.cookieYear)!,
      selectedSpecifications: new Map<number, boolean>(),
      monthHeaders: [],
      weekHeaders: [],
      totalCount: 0,
      weekTotalHeaders: [],
      missionRows: new Map<number, React.ReactNode>(),
      weekCount: new Map<number, Map<number, number>>(),
    };
  }

  componentDidMount(): void {
    this.loadSpecifications();
    this.loadMissions();
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

  loadMissions() {
    this.props.missionStore!.fetchByYear(this.state.fetchYear).then(() => {
      this.calculateMissionRows();
      this.setState({ loadingMissions: false }, () => {
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
    this.setState({ loadingMissions: true, fetchYear: year }, () => {
      this.loadMissions();
      // this.props.missionStore!.fetchByYear(year).then(() => {
      //   this.calculateMissionRows();
      //   this.setState({ loadingMissions: false });
      // });
    });
  }

  calculateMissionRows(): void {
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

    const missionRows = new Map<number, React.ReactNode>();

    const doneMissions: number[] = [];

    this.props.missionStore!.entities.forEach(mission => {
      // if we've already added the row for this user and specification, skiip
      if (doneMissions.includes(mission.id!)) {
        return;
      }

      // getting all missions of current user with same specification
      const currMissions = this.props.missionStore!.entities.filter(val => {
        if (val.user_id === mission.user_id && val.specification_id === mission.specification_id) {
          doneMissions.push(val.id!);
          return true;
        }
        return false;
      });

      const cells = this.getMissionCells(startDates, endDates, currMissions, weekCount);

      // can use any mission in currMissions here, because user and specification are the same for each mission in array
      missionRows.set(
        mission.id!,
        (
          <MissionRow
            key={'mission-row-' + mission.id!}
            shortName={mission.specification!.short_name}
            specification_id={mission.specification_id}
            user_id={mission.user_id}
            zdp={mission.user!.zdp}
            userName={mission.user!.first_name + ' ' + mission.user!.last_name}
            cells={cells}
            classes={classes}
          />
        ),
      );
    });

    this.setState(
      {
        weekCount,
        missionRows,
      },
      () => {
        this.updateAverageHeaders();
        this.setWeekAndMonthHeaders();
      },
    );
  }

  render() {
    // Specifications that are in use by at least one mission
    const specIdsOfMissions = this.props
      .missionStore!.entities.map(mission => mission.specification_id)
      .filter((elem, index, arr) => index === arr.indexOf(elem));
    specIdsOfMissions.sort();

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
                {// Mapping a CheckboxField to every specfication in use
                specIdsOfMissions.map(id => {
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

          {this.state.loadingMissions ? (
            <LoadingInformation />
          ) : (
            <Row>
              <Table responsive={true} striped={true} bordered={true} className={'table-no-padding'} id="mission_overview_table">
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
                  {this.props.missionStore!.entities.map(mission => {
                    if (this.state.selectedSpecifications[mission.specification_id]) {
                      return this.state.missionRows.get(mission.id!);
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

    // let currDate = new Date(this.state.fetchYear + '-01-01');
    // while (moment(currDate).isoWeek() > 50) {
    //   currDate.setDate(currDate.getDate() + 1);
    // }

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
        <td className={classes.rowTd} key={currWeek}>
          {currWeek}
        </td>,
      );
      if (
        moment(currDate)
          .isoWeekday(1)
          .month() !== currMonth
      ) {
        // if we're in a new month
        monthHeaders.push(
          <td
            className={classes.rowTd}
            style={{ fontWeight: 'bold', maxWidth: 25 * monthColCount + 'px', overflow: 'hidden', wordWrap: 'normal' }}
            colSpan={monthColCount}
            key={'month_header_' + currWeek}
          >
            {this.monthNames[currMonth]}
          </td>,
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
      <td
        className={classes.rowTd}
        style={{ fontWeight: 'bold' }}
        colSpan={monthColCount}
        key={this.monthNames.indexOf(this.monthNames[currMonth])}
      >
        {this.monthNames[currMonth]}
      </td>,
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
        <td className={classes.rowTd} key={currWeek}>
          {weekCountSum}
        </td>,
      );
      totalCount += weekCountSum;
    }
    this.setState({ weekTotalHeaders, totalCount });
  }

  getMissionCells(
    startDates: string[],
    endDates: string[],
    currMissions: Mission[],
    weekCount: Map<number, Map<number, number>>,
  ): React.ReactNode[] {
    const cells: React.ReactNode[] = [];
    const { classes } = this.props;

    // filling MissionRow for currMissions
    for (let currWeek = 1; currWeek <= 52; currWeek++) {
      const popOverStart = startDates[currWeek];
      const popOverEnd = endDates[currWeek];
      const title = popOverStart + ' - ' + popOverEnd;

      const currMission = this.getActiveMissionInWeek(currWeek, currMissions);

      if (currMission == null) {
        // no mission in this week
        cells.push(
          <td key={currWeek} title={title} className={classes.rowTd}>
            {''}
          </td>,
        );
      } else {
        // mission in this week
        if (weekCount[currMission.specification_id]) {
          // increasing weekCount for this specification
          weekCount[currMission.specification_id][currWeek]++;
        }

        // different styling depending on whether the mission is a draft or not
        const einsatz = currMission.draft == null ? classes.einsatzDraft : classes.einsatz;

        if (this.isWeekStartWeek(currWeek, currMission)) {
          const content = moment(currMission.start!)
            .date()
            .toString(); // new Date(currMission.start!).getDate().toString();
          cells.push(
            <td key={currWeek} title={title} className={classes.rowTd + ' ' + einsatz}>
              {content}
            </td>,
          );
        } else if (this.isWeekEndWeek(currWeek, currMission)) {
          const content = moment(currMission.end!)
            .date()
            .toString(); // new Date(currMission.end!).getDate().toString();
          cells.push(
            <td key={currWeek} title={title} className={classes.rowTd + ' ' + einsatz}>
              {content}
            </td>,
          );
        } else {
          // Week must be during a mission, but not the ending or starting week
          cells.push(
            <td key={currWeek} title={title} className={classes.rowTd + ' ' + einsatz}>
              {'x'}
            </td>,
          );
        }
      }
    }

    return cells;
  }

  isWeekStartWeek(week: number, mission: Mission): boolean {
    return week === this.getStartWeek(mission);
  }

  isWeekMiddleWeek(week: number, mission: Mission): boolean {
    const startWeek = this.getStartWeek(mission);
    const endWeek = this.getEndWeek(mission);

    return week > startWeek && week < endWeek;
  }

  isWeekEndWeek(week: number, mission: Mission): boolean {
    return week === this.getEndWeek(mission);
  }

  isWeekDuringMission(week: number, mission: Mission): boolean {
    return this.isWeekStartWeek(week, mission) || this.isWeekMiddleWeek(week, mission) || this.isWeekEndWeek(week, mission);
  }

  getActiveMissionInWeek(week: number, missions: Mission[]): Mission | null {
    let ret: Mission | null = null;
    missions.forEach(mission => {
      if (this.isWeekDuringMission(week, mission)) {
        ret = mission;
      }
    });
    return ret;
  }

  getStartWeek(mission: Mission): number {
    let startWeek = moment(mission.start!).isoWeek();
    if (moment(mission.start!).year() < parseInt(this.state.fetchYear, 10)) {
      startWeek = -1;
    }
    return startWeek;
  }

  getEndWeek(mission: Mission): number {
    let endWeek = moment(mission.end!).isoWeek();
    if (moment(mission.end!).year() > parseInt(this.state.fetchYear, 10)) {
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

export const MissionOverview = injectSheet(MissionStyles)(MissionOverviewContent);
