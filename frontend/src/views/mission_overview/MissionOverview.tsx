import * as React from 'react';
import { SpecificationStore } from '../../stores/specificationStore';
import { inject } from 'mobx-react';
import { UserStore } from '../../stores/userStore';
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
  userStore?: UserStore;
  missionStore?: MissionStore;
}

interface MissionOverviewState {
  loadingMissions: boolean;
  loadingSpecifications: boolean;
  selectedSpecifications: Map<number, boolean>;
  fetchYear: string;
}

const cookiePrefix = 'mission-overview-checkbox-';

@inject('userStore', 'missionStore', 'specificationStore')
class MissionOverviewContent extends React.Component<MissionOverviewProps, MissionOverviewState> {
  constructor(props: MissionOverviewProps) {
    super(props);

    this.state = {
      loadingMissions: true,
      loadingSpecifications: true,
      fetchYear: '2019',
      selectedSpecifications: new Map<number, boolean>(),
    };

    this.props.specificationStore!.fetchAll().then(() => {
      this.props.specificationStore!.entities.forEach(spec => {
        let newSpecs = this.state.selectedSpecifications;
        newSpecs[spec.id!] =
          window.localStorage.getItem(cookiePrefix + spec.id!) == null
            ? true
            : window.localStorage.getItem(cookiePrefix + spec.id!) == 'true';
        this.setState({ selectedSpecifications: newSpecs, loadingSpecifications: false });
      });
    });

    this.props.missionStore!.fetchByYear(this.state.fetchYear).then(() => {
      this.setState({ loadingMissions: false });
    });
  }

  componentDidMount(): void {
    //this.setState({ loading: true });
  }

  changeSelectedSpecifications(v: boolean, id: number) {
    let newSpec = this.state.selectedSpecifications;
    newSpec[id] = v;
    this.setState({ selectedSpecifications: newSpec });
    window.localStorage.setItem(cookiePrefix + id, v.toString());
  }

  selectYear(year: string) {
    this.setState({ loadingMissions: true, fetchYear: year }, () => {
      this.props.missionStore!.fetchByYear(year).then(() => {
        this.setState({ loadingMissions: false });
      });
    });
  }

  monthNames = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  render() {
    let specIdsOfMissions = this.props
      .missionStore!.entities.map(mission => mission.specification_id)
      .filter((elem, index, arr) => index === arr.indexOf(elem));
    specIdsOfMissions.sort();

    const { classes, specificationStore } = this.props;

    let weekCount = new Map<number, Map<number, number>>();
    for (let spec of specificationStore!.entities) {
      weekCount[spec.id!] = [];
      for (let i = 1; i <= 52; i++) {
        weekCount[spec.id!][i] = 0;
      }
    }

    let currYear = new Date().getFullYear();

    let startDates: Array<string> = [];
    let endDates: Array<string> = [];

    for (let x = 1; x <= 52; x++) {
      startDates[x] = moment(currYear + ' ' + x + ' 1', 'YYYY WW E').format('DD.MM.YYYY');
      endDates[x] = moment(currYear + ' ' + x + ' 5', 'YYYY WW E').format('DD.MM.YYYY');
    }

    let averageCount = 0;
    let weekHeaders = [];
    let averageHeaders = [];
    let monthHeaders = [];
    let startDate = new Date(this.state.fetchYear + '-01-01');
    while (moment(startDate).isoWeek() > 50) {
      startDate.setDate(startDate.getDate() + 1);
    }
    let prevMonth = moment(startDate)
      .isoWeekday(1)
      .month();
    let monthColCount = 0;
    for (let i = 1; i <= 52; i++) {
      let weekCountSum = 0;

      specificationStore!.entities.forEach(val => {
        if (this.state.selectedSpecifications[val.id!] && weekCount[val.id!]) {
          weekCountSum += weekCount[val.id!][i];
        }
      });
      weekHeaders.push(
        <td className={classes.rowTd} key={i}>
          {i}
        </td>
      );
      averageHeaders.push(
        <td className={classes.rowTd} key={i}>
          {weekCountSum}
        </td>
      );
      averageCount += weekCountSum;
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

    //

    return (
      <IziviContent loading={this.state.loadingSpecifications} title={'Planung'} card={true}>
        {/*<Container>*/}
        <Row style={{ marginBottom: '2vh' }}>
          <Col sm="12" md="2">
            <div>
              <SelectField
                options={Array.from(Array(currYear - 2003).keys())
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
              {/*<select onChange={e => this.selectYear(e.target.value)} defaultValue={this.state.fetchYear}>*/}
              {/*{yearOptions}*/}
              {/*</select>*/}
            </div>
          </Col>
          <Col sm="12" md="8">
            <div>
              {specIdsOfMissions.map(v => {
                let currSpec = specificationStore!.entities.filter(spec => spec.id! === v)[0];
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
              })
              // specificationStore!.entities.filter((spec) => {
              //   return spec.active;
              // }).map((spec) => (
              //   <CheckboxField
              //     key={spec.id!}
              //     onChange={(v: boolean) => this.changeSelectedSpecifications(v, spec.id!)}
              //     name={spec.id!.toString()}
              //     value={this.state.selectedSpecifications[spec.id!]}
              //     label={spec.name}
              //     horizontal={false}
              //   />
              // ))
              }
              {/*<CheckboxField id={72466}*/}
              {/*onChange={(v: boolean) => this.changeSelectedSpecifications(v, 'F')}*/}
              {/*name={'F'} checked={this.state.selectedSpecifications['F']}*/}
              {/*label={'Feldarbeiten (ab 06.07.2016)'}/>*/}
              {/*<MissionTypeCheckbox id={72467}*/}
              {/*onChange={(e: any, sn: string) => this.changeSelectedSpecifications(e, sn)}*/}
              {/*name={'A'} checked={this.state.selectedSpecifications['A']}*/}
              {/*label={'Admin (ab 06.07.2016)'}/>*/}
              {/*<MissionTypeCheckbox id={72468}*/}
              {/*onChange={(e: any, sn: string) => this.changeSelectedSpecifications(e, sn)}*/}
              {/*name={'K'} checked={this.state.selectedSpecifications['K']}*/}
              {/*label={'Admin; Ressourcen-, Arten- und Naturschutz (ab 06.07.2016)'}/>*/}
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
                  {monthHeaders}
                </tr>
                <tr>{weekHeaders}</tr>
                <tr>
                  <td
                    colSpan={3}
                    style={{ textAlign: 'left', paddingLeft: '8px !important', fontWeight: 'bold' }}
                    className={classes.rowTd}
                  >
                    Ø / Woche: {(averageCount / 52).toFixed(2)}
                  </td>
                  {averageHeaders}
                </tr>
              </thead>
              <tbody>
                {this.props.missionStore!.entities.map(mission => {
                  if (this.state.selectedSpecifications[mission.specification_id]) {
                    return (
                      <MissionRow
                        key={mission.id}
                        mission={mission}
                        startDates={startDates}
                        endDates={endDates}
                        weekCount={weekCount}
                        year={parseInt(this.state.fetchYear)}
                        classes={classes}
                      />
                    );
                  }
                  return;
                })}
                <tr>
                  {/*<td>Mission Length: {this.props.missionStore!.entities.length}</td>*/}
                  {/*{*/}
                  {/*this.props.missionStore!.entities.map(mission =>*/}
                  {/*<td>{mission.user!.first_name}</td>*/}
                  {/*)*/}
                  {/*}*/}
                </tr>
              </tbody>
            </Table>
          </Row>
        )}

        {/*</Container>*/}
      </IziviContent>
    );
  }
}

export const MissionOverview = injectSheet(styles)(MissionOverviewContent);

interface MissionRowProps {
  mission: Mission;
  startDates: Array<string>;
  endDates: Array<string>;
  weekCount: Map<number, Map<number, number>>;
  year: number;
  classes: Record<string, string>;
}

function MissionRow(props: MissionRowProps) {
  const { classes } = props;

  ///
  let cells = [];

  //let missionCounter = 0;

  for (let weekNr = 1; weekNr <= 52; weekNr++) {
    let popOverStart = props.startDates[weekNr];
    let popOverEnd = props.endDates[weekNr];

    let curMission = props.mission;
    if (!curMission) {
      continue;
    }
    let startWeek = moment(curMission.start!).isoWeek();
    if (new Date(curMission.start!).getFullYear() < props.year) {
      startWeek = -1;
    }
    let endWeek = moment(curMission.end!).isoWeek();
    if (new Date(curMission.end!).getFullYear() > props.year) {
      endWeek = 55;
    }

    if (weekNr < startWeek || weekNr > endWeek) {
      cells.push({
        className: classes.rowTd,
        title: popOverStart + ' - ' + popOverEnd,
        content: '',
      });
    } else {
      if (props.weekCount[curMission.specification_id]) {
        props.weekCount[curMission.specification_id][weekNr]++;
      }
      if (weekNr === startWeek) {
        cells.push({
          className: classes.rowTd + ' ' + (curMission.draft == null ? classes.einsatzDraft : classes.einsatz),
          title: popOverStart + ' - ' + popOverEnd,
          content: new Date(curMission.start!).getDate().toString(),
        });
      } else if (weekNr === endWeek) {
        cells.push({
          className: classes.rowTd + ' ' + (curMission.draft == null ? classes.einsatzDraft : classes.einsatz),
          title: popOverStart + ' - ' + popOverEnd,
          content: new Date(curMission.end!).getDate().toString(),
        });
      } else {
        cells.push({
          className: classes.rowTd + ' ' + (curMission.draft == null ? classes.einsatzDraft : classes.einsatz),
          title: popOverStart + ' - ' + popOverEnd,
          content: 'x',
        });
      }

      // if (x === endWeek && missionCounter < mission.length - 1) {
      //   missionCounter++;
      // }
    }
  }

  ///

  return (
    <tr className={'mission-row-' + props.mission.specification_id}>
      <td className={classes.shortName + ' ' + classes.rowTd}>{props.mission.specification!.short_name}</td>

      <td className={classes.zdp + ' ' + classes.rowTd}>
        <div className="no-print">{props.mission.user!.zdp}</div>
      </td>

      <td className={classes.namen + ' ' + classes.rowTd}>
        <a href={'/users/' + props.mission.user_id}>{props.mission.user!.first_name + ' ' + props.mission.user!.last_name}</a>
      </td>

      {cells.map(({ content, ...props }, index) => (
        <td key={index} {...props}>
          {content}
        </td>
      ))}
    </tr>
  );
}
