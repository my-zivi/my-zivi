import { MainStore } from '../../stores/mainStore';
import * as React from 'react';
import { User, ReportSheet } from '../../types';
import { OverviewTable } from 'src/layout/OverviewTable';
import { EditSolidIcon, CheckSquareRegularIcon, ClockRegularIcon, HourGlassRegularIcon, PrintSolidIcon } from 'src/utilities/Icon';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { inject } from 'mobx-react';
import injectSheet, { WithSheet } from 'react-jss';
import createStyles from 'src/utilities/createStyles';
import moment from 'moment';
import Tooltip from 'reactstrap/lib/Tooltip';
import Button from 'reactstrap/lib/Button';

interface Props extends WithSheet<typeof styles> {
  mainStore?: MainStore;
  user: User;
}

interface ReportSheetSubformState {
  openTooltips: Array<boolean>;
}

const styles = () =>
  createStyles({
    hideButtonText: {
      '@media (max-width: 1024px)': {
        '& button': {
          width: '40px',
        },
        '& span': {
          display: 'none',
        },
      },
    },
  });

@inject('mainStore')
class ReportSheetSubformInner extends React.Component<Props, ReportSheetSubformState> {
  constructor(props: Props) {
    super(props);

    this.state = { openTooltips: [] };
  }

  public render() {
    const { user, mainStore, classes } = this.props;

    return (
      <>
        <h3>Spesenblätter</h3>
        <br />
        <br />
        {user && (
          <>
            <OverviewTable
              data={user.report_sheets}
              columns={[
                {
                  id: 'start',
                  label: 'Von',
                  format: (reportSheet: ReportSheet) => (reportSheet.start ? mainStore!.formatDate(reportSheet.start) : ''),
                },
                {
                  id: 'end',
                  label: 'Bis',
                  format: (reportSheet: ReportSheet) => (reportSheet.end ? mainStore!.formatDate(reportSheet.end) : ''),
                },
                {
                  id: 'days',
                  label: 'Anzahl Tage',
                  format: (reportSheet: ReportSheet) =>
                    reportSheet.end && reportSheet.start
                      ? moment(reportSheet.end).diff(moment(reportSheet.start), 'd') +
                        1 -
                        reportSheet.company_holiday_holiday -
                        reportSheet.holiday
                      : 0,
                },
                {
                  id: 'state',
                  label: 'Status',
                  format: reportSheet => {
                    let icon;
                    let tooltip: string;
                    let color = 'black';

                    switch (reportSheet.state) {
                      case 0:
                        icon = ClockRegularIcon;
                        tooltip = 'Noch nicht fällig';
                        break;
                      case 1:
                        icon = HourGlassRegularIcon;
                        tooltip = 'In Bearbeitung';
                        color = 'orange';
                        break;
                      case 2:
                        icon = HourGlassRegularIcon;
                        tooltip = 'In Bearbeitung';
                        color = 'orange';
                        break;
                      case 3:
                        icon = CheckSquareRegularIcon;
                        tooltip = 'Erledigt';
                        color = 'green';
                        break;
                      default:
                        icon = ClockRegularIcon;
                        tooltip = 'Noch nicht fällig';
                        break;
                    }

                    return (
                      <>
                        <span id={'reportSheetState' + reportSheet.id}>
                          <FontAwesomeIcon icon={icon} color={color} />
                        </span>
                        <Tooltip
                          placement="bottom"
                          target={'reportSheetState' + reportSheet.id}
                          isOpen={this.state.openTooltips[reportSheet.id!]}
                          toggle={() => this.handleOpenTooltip(reportSheet.id!)}
                        >
                          {tooltip}
                        </Tooltip>
                      </>
                    );
                  },
                },
              ]}
              renderActions={(reportSheet: ReportSheet) => (
                <div>
                  {mainStore!.isAdmin() ? (
                    <div className={classes.hideButtonText}>
                      <Button
                        color={'link'}
                        href={mainStore!.apiURL('report_sheets/' + String(reportSheet.id!) + '/download')}
                        tag={'a'}
                        target={'_blank'}
                      >
                        <FontAwesomeIcon icon={PrintSolidIcon} /> <span>Drucken</span>
                      </Button>
                      <Button color={'warning'} href={'/report_sheets/' + reportSheet.id} tag={'a'} target={'_blank'}>
                        <FontAwesomeIcon icon={EditSolidIcon} /> <span>Bearbeiten</span>
                      </Button>
                    </div>
                  ) : (
                    <></>
                  )}
                </div>
              )}
            />
          </>
        )}
        {!user && <div>Loading...</div>}
      </>
    );
  }

  handleOpenTooltip = (id: number): void => {
    let opens = this.state.openTooltips;

    if (opens[id]) {
      opens[id] = !opens[id];
    } else {
      opens[id] = true;
    }

    this.setState({ openTooltips: opens });
  };
}

export const ReportSheetSubform = injectSheet(styles)(ReportSheetSubformInner);
