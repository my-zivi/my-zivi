import * as React from 'react';
import { SpecificationStore } from '../../stores/specificationStore';
import { inject } from 'mobx-react';
import IziviContent from '../../layout/IziviContent';
import { MissionStore } from '../../stores/missionStore';
import moment from 'moment';
import { Mission } from '../../types';
import { SelectField } from '../../form/common';
import createStyles from '../../utilities/createStyles';
import { WithSheet } from 'react-jss';
import injectSheet from 'react-jss';
import Table from 'reactstrap/lib/Table';
import { CheckboxField } from '../../form/CheckboxField';
import Row from 'reactstrap/lib/Row';
import Col from 'reactstrap/lib/Col';
import Button from 'reactstrap/lib/Button';
import { LoadingInformation } from '../../layout/LoadingInformation';
import { ReactNode } from 'react';
import Container from 'reactstrap/lib/Container';
import { MissionRow } from './MissionRow';

const styles = () =>
  createStyles({
    rowTd: {
      padding: '5px 1px !important',
      fontSize: '14px',
      textAlign: 'center',
      minWidth: '25px',
    },
    shortName: {
      minWidth: '40px',
      width: '40px',
    },
    zdp: {
      minWidth: '100px',
      width: '100px',
    },
    namen: {
      minWidth: '150px',
      width: '150px',
      textAlign: 'left',
    },
    einsatzDraft: {
      background: '#fc9',
    },
    einsatz: {
      background: '#0c6',
    },
  });

interface MissionOverviewProps extends WithSheet<typeof styles> {
  specificationStore?: SpecificationStore;
  missionStore?: MissionStore;
}

interface MissionOverviewState {
  loadingMissions: boolean;
  loadingSpecifications: boolean;
  selectedSpecifications: Map<number, boolean>;
  fetchYear: string;
  missionCells: Map<number, ReactNode>;
  monthHeaders: Array<ReactNode>;
  weekHeaders: Array<ReactNode>;
  totalCount: number;
  averageHeaders: Array<ReactNode>;
  weekCount: Map<number, Map<number, number>>;
}

@inject('missionStore', 'specificationStore')
class MissionOverviewContent extends React.Component<MissionOverviewProps, MissionOverviewState> {
  cookiePrefixSpec = 'mission-overview-checkbox-';
  cookieYear = 'mission-overview-year';
  currYear = new Date().getFullYear();
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
      averageHeaders: [],
      missionCells: new Map<number, ReactNode>(),
      weekCount: new Map<number, Map<number, number>>(),
    };

    this.props.specificationStore!.fetchAll().then(() => {
      let newSpecs = this.state.selectedSpecifications;
      this.props.specificationStore!.entities.forEach(spec => {
        newSpecs[spec.id!] =
          window.localStorage.getItem(this.cookiePrefixSpec + spec.id!) === null
            ? true
            : window.localStorage.getItem(this.cookiePrefixSpec + spec.id!) === 'true';
      });
      this.setState({ selectedSpecifications: newSpecs, loadingSpecifications: false });
    });

    this.props.missionStore!.fetchByYear(this.state.fetchYear).then(() => {
      this.calculateMissionCells();
      this.setState({ loadingMissions: false });
    });
  }

  calculateMissionCells(): void {
    let fetchYear = parseInt(this.state.fetchYear);
    const { classes } = this.props;

    let weekCount = this.getEmptyWeekCount();

    // First and last date of weeks for popOver
    let startDates: Array<string> = [];
    let endDates: Array<string> = [];
    for (let x = 1; x <= 52; x++) {
      startDates[x] = moment(fetchYear + ' ' + x + ' 1', 'YYYY WW E').format('DD.MM.YYYY');
      endDates[x] = moment(fetchYear + ' ' + x + ' 5', 'YYYY WW E').format('DD.MM.YYYY');
    }

    let missionCells = new Map<number, ReactNode>();

    let doneMissions: number[] = [];

    this.props.missionStore!.entities.forEach(mission => {
      // if we've already added the row for this user and specification, cancel
      if (doneMissions.includes(mission.id!)) {
        return;
      }

      // getting all missions of current user with same specification
      let currMissions = this.props.missionStore!.entities.filter(val => {
        if (val.user_id == mission.user_id && val.specification_id == mission.specification_id) {
          doneMissions.push(val.id!);
          return true;
        }
        return false;
      });

      let cells: ReactNode[] = [];
      // filling MissionRow for currMissions
      for (let currWeek = 1; currWeek <= 52; currWeek++) {
        let popOverStart = startDates[currWeek];
        let popOverEnd = endDates[currWeek];
        let title = popOverStart + ' - ' + popOverEnd;

        if (!this.isWeekDuringAMission(currWeek, currMissions)) {
          // no mission in this week
          cells.push(
            <td title={title} className={classes.rowTd}>
              {''}
            </td>
          );
        } else {
          // mission in this week, increasing weekCount for this specification
          if (weekCount[mission.specification_id]) {
            weekCount[mission.specification_id][currWeek]++;
          }
          // different styling depending on whether the mission is a draft or not
          let einsatz = this.isWeekADraft(currWeek, currMissions) ? classes.einsatzDraft : classes.einsatz;
          if (this.isWeekAStartWeek(currWeek, currMissions)) {
            cells.push(
              <td title={title} className={classes.rowTd + ' ' + einsatz}>
                {this.getStartDateOfCurrentMission(currWeek, currMissions).toString()}
              </td>
            );
          } else if (this.isWeekAnEndWeek(currWeek, currMissions)) {
            cells.push(
              <td title={title} className={classes.rowTd + ' ' + einsatz}>
                {this.getEndDateOfCurrentMission(currWeek, currMissions).toString()}
              </td>
            );
          } else {
            // Week must be during a mission, but not the ending or starting week
            cells.push(
              <td title={title} className={classes.rowTd + ' ' + einsatz}>
                {'x'}
              </td>
            );
          }
        }
      }

      missionCells.set(
        mission.id!,
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
      );
    });

    this.setState(
      {
        weekCount,
        missionCells,
      },
      () => {
        this.updateAverageHeaders();
        this.setWeekAndMonthHeaders();
      }
    );
  }

  changeSelectedSpecifications(v: boolean, id: number) {
    let newSpec = this.state.selectedSpecifications;
    newSpec[id] = v;
    this.setState({ selectedSpecifications: newSpec }, () => this.updateAverageHeaders());
    window.localStorage.setItem(this.cookiePrefixSpec + id, v.toString());
  }

  selectYear(year: string) {
    window.localStorage.setItem(this.cookieYear, year);
    this.setState({ loadingMissions: true, fetchYear: year }, () => {
      this.props.missionStore!.fetchByYear(year).then(() => {
        this.calculateMissionCells();
        this.setState({ loadingMissions: false });
      });
    });
  }

  render() {
    // Specifications that are in use by at least one mission
    let specIdsOfMissions = this.props
      .missionStore!.entities.map(mission => mission.specification_id)
      .filter((elem, index, arr) => index === arr.indexOf(elem));
    specIdsOfMissions.sort();

    const { classes, specificationStore } = this.props;

    return (
      <IziviContent loading={this.state.loadingSpecifications} title={'Planung'} card={true}>
        <Container fluid={true}>
          <Row style={{ marginBottom: '2vh' }}>
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
                  let currSpec = specificationStore!.entities.filter(spec => spec.id! === id)[0];
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
              <Button>Drucken</Button>
            </Col>
          </Row>

          {this.state.loadingMissions ? (
            <LoadingInformation />
          ) : (
            <Row>
              <Table responsive={true} className={'table table-striped table-bordered table-no-padding'} id="mission_overview_table">
                <thead>
                  <tr>
                    <td colSpan={3} rowSpan={2} className={classes.rowTd}>
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
                    {this.state.averageHeaders}
                  </tr>
                </thead>
                <tbody>
                  {this.props.missionStore!.entities.map(mission => {
                    if (this.state.selectedSpecifications[mission.specification_id]) {
                      return this.state.missionCells.get(mission.id!);
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

    let weekHeaders = [];
    let monthHeaders = [];
    let monthColCount = 0;

    let startDate = new Date(this.state.fetchYear + '-01-01');
    while (moment(startDate).isoWeek() > 50) {
      startDate.setDate(startDate.getDate() + 1);
    }
    let prevMonth = moment(startDate)
      .isoWeekday(1)
      .month();

    for (let i = 1; i <= 52; i++) {
      weekHeaders.push(
        <td className={classes.rowTd} key={i}>
          {i}
        </td>
      );
      if (
        moment(startDate)
          .isoWeekday(1)
          .month() !== prevMonth
      ) {
        // cell width (25px) must be the same as in mission_overview.sass
        monthHeaders.push(
          <td
            className={classes.rowTd}
            style={{ fontWeight: 'bold', maxWidth: 25 * monthColCount + 'px', overflow: 'hidden', wordWrap: 'normal' }}
            colSpan={monthColCount}
            key={'month_header_' + i}
          >
            {this.monthNames[prevMonth]}
          </td>
        );
        monthColCount = 0;
        prevMonth = startDate.getMonth();
      }
      monthColCount++;
      startDate.setDate(startDate.getDate() + 7);
    }

    monthHeaders.push(
      <td
        className={classes.rowTd}
        style={{ fontWeight: 'bold' }}
        colSpan={monthColCount}
        key={this.monthNames.indexOf(this.monthNames[prevMonth])}
      >
        {this.monthNames[prevMonth]}
      </td>
    );

    this.setState({ monthHeaders: monthHeaders, weekHeaders: weekHeaders });
  }

  updateAverageHeaders(): void {
    const { classes } = this.props;
    let averageHeaders = [];
    let totalCount = 0;
    let weekCount = this.state.weekCount;
    for (let i = 1; i <= 52; i++) {
      let weekCountSum = 0;

      this.props.specificationStore!.entities.forEach(val => {
        if (this.state.selectedSpecifications[val.id!] && weekCount[val.id!]) {
          weekCountSum += weekCount[val.id!][i];
        }
      });
      averageHeaders.push(
        <td className={classes.rowTd} key={i}>
          {weekCountSum}
        </td>
      );
      totalCount += weekCountSum;
    }
    this.setState({ averageHeaders: averageHeaders, totalCount: totalCount });
  }

  getStartDateOfCurrentMission(currWeek: number, currMissions: Mission[]): number {
    let ret: number = 0;
    currMissions.forEach(currMission => {
      if (this.isWeekDuringMission(currWeek, currMission)) {
        ret = new Date(currMission.start!).getDate();
      }
    });
    return ret;
  }

  getEndDateOfCurrentMission(currWeek: number, currMissions: Mission[]): number {
    let ret: number = 0;
    currMissions.forEach(currMission => {
      if (this.isWeekDuringMission(currWeek, currMission)) {
        ret = new Date(currMission.end!).getDate();
      }
    });
    return ret;
  }

  isWeekADraft(currWeek: number, currMissions: Mission[]): boolean {
    let draft = false;
    currMissions.forEach(currMission => {
      if (this.isWeekDuringMission(currWeek, currMission)) {
        draft = currMission.draft == null;
      }
    });
    return draft;
  }

  isWeekStartWeek(currWeek: number, currMission: Mission): boolean {
    return currWeek == this.getStartWeek(currMission);
  }

  isWeekAStartWeek(currWeek: number, currMissions: Mission[]): boolean {
    let ret = false;
    currMissions.forEach(currMission => {
      if (this.isWeekStartWeek(currWeek, currMission)) {
        ret = true;
      }
    });
    return ret;
  }

  isWeekMiddleWeek(currWeek: number, currMission: Mission): boolean {
    let startWeek = this.getStartWeek(currMission);
    let endWeek = this.getEndWeek(currMission);

    return currWeek > startWeek && currWeek < endWeek;
  }

  // isWeekAMiddleWeek(currWeek: number, currMissions: Mission[]): boolean {
  //   let ret = false;
  //   currMissions.forEach((currMission) => {
  //     if (this.isWeekMiddleWeek(currWeek, currMission)) {
  //       ret = true;
  //     }
  //   });
  //   return ret;
  // }

  isWeekEndWeek(currWeek: number, currMission: Mission): boolean {
    return currWeek == this.getEndWeek(currMission);
  }

  isWeekAnEndWeek(currWeek: number, currMissions: Mission[]): boolean {
    let ret = false;
    currMissions.forEach(currMission => {
      if (this.isWeekEndWeek(currWeek, currMission)) {
        ret = true;
      }
    });
    return ret;
  }

  isWeekDuringMission(currWeek: number, currMission: Mission): boolean {
    return (
      this.isWeekStartWeek(currWeek, currMission) ||
      this.isWeekMiddleWeek(currWeek, currMission) ||
      this.isWeekEndWeek(currWeek, currMission)
    );
  }

  isWeekDuringAMission(currWeek: number, currMissions: Mission[]): boolean {
    let ret = false;
    currMissions.forEach(currMission => {
      if (this.isWeekDuringMission(currWeek, currMission)) {
        ret = true;
      }
    });
    return ret;
  }

  getStartWeek(mission: Mission): number {
    let startWeek = moment(mission.start!).isoWeek();
    if (new Date(mission.start!).getFullYear() < parseInt(this.state.fetchYear)) {
      startWeek = -1;
    }
    return startWeek;
  }

  getEndWeek(mission: Mission): number {
    let endWeek = moment(mission.end!).isoWeek();
    if (new Date(mission.end!).getFullYear() > parseInt(this.state.fetchYear)) {
      endWeek = 55;
    }
    return endWeek;
  }

  getEmptyWeekCount(): Map<number, Map<number, number>> {
    let weekCount = new Map<number, Map<number, number>>();
    for (let spec of this.props.specificationStore!.entities) {
      weekCount[spec.id!] = [];
      for (let i = 1; i <= 52; i++) {
        weekCount[spec.id!][i] = 0;
      }
    }
    return weekCount;
  }
}

export const MissionOverview = injectSheet(styles)(MissionOverviewContent);
