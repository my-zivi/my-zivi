import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { inject } from 'mobx-react';
import moment from 'moment';
import * as React from 'react';
import injectSheet, { WithSheet } from 'react-jss';
import Button from 'reactstrap/lib/Button';
import Tooltip from 'reactstrap/lib/Tooltip';
import { LoadingInformation } from '../../layout/LoadingInformation';
import { OverviewTable } from '../../layout/OverviewTable';
import { MainStore } from '../../stores/mainStore';
import { ExpenseSheet, ExpenseSheetListing, ExpenseSheetState, ShortExpenseSheetListing, User } from '../../types';
import createStyles from '../../utilities/createStyles';
import { CheckSquareRegularIcon, ClockRegularIcon, EditSolidIcon, HourGlassRegularIcon, PrintSolidIcon } from '../../utilities/Icon';

interface Props extends WithSheet<typeof styles> {
  mainStore?: MainStore;
  user: User;
}

interface ExpenseSheetSubformState {
  openTooltips: boolean[];
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
      'marginTop': '-0.5rem',
    },
  });

@inject('mainStore')
class ExpenseSheetSubformInner extends React.Component<Props, ExpenseSheetSubformState> {
  private static getExpenseSheetColumnProps({ state }: ShortExpenseSheetListing) {
    switch (state) {
      case ExpenseSheetState.payment_in_progress:
        return {
          icon: HourGlassRegularIcon,
          tooltip: 'In Bearbeitung',
          color: 'orange',
        };
      case ExpenseSheetState.ready_for_payment:
        return {
          icon: HourGlassRegularIcon,
          tooltip: 'In Bearbeitung',
          color: 'orange',
        };
      case ExpenseSheetState.paid:
        return {
          icon: CheckSquareRegularIcon,
          tooltip: 'Erledigt',
          color: 'green',
        };
      default:
        return {
          icon: ClockRegularIcon,
          tooltip: 'Noch nicht fällig',
          color: 'black',
        };
    }
  }

  constructor(props: Props) {
    super(props);

    this.state = { openTooltips: [] };
  }

  handleOpenTooltip = (id: number) => {
    const { openTooltips } = this.state;

    openTooltips[id] = !openTooltips[id];

    this.setState({ openTooltips });
  }

  render() {
    const { user, mainStore, classes } = this.props;

    return (
      <div id="expense-sheets">
        <h3 className="mb-3">Spesenblätter</h3>
        {user && (
          <OverviewTable
            data={user.expense_sheets}
            columns={this.getColumns()}
            renderActions={(expenseSheet: ExpenseSheetListing) => (
              <div>
                {mainStore!.isAdmin() && (
                  <div className={classes.hideButtonText}>
                    <Button color={'warning'} href={'/expense_sheets/' + expenseSheet.id} tag={'a'} target={'_blank'}>
                      <FontAwesomeIcon icon={EditSolidIcon}/> <span>Bearbeiten</span>
                    </Button>
                  </div>
                )}
              </div>
            )}
          />
        )}
        {!user && <LoadingInformation/>}
      </div>
    );
  }

  private getColumns() {
    return [
      {
        id: 'beginning',
        label: 'Von',
        format: (expenseSheet: ShortExpenseSheetListing) => this.safeFormatDate(expenseSheet.beginning),
      },
      {
        id: 'end',
        label: 'Bis',
        format: (expenseSheet: ShortExpenseSheetListing) => this.safeFormatDate(expenseSheet.ending),
      },
      {
        id: 'days',
        label: 'Anzahl Tage',
        format: (expenseSheet: ShortExpenseSheetListing) => expenseSheet.duration,
      },
      {
        id: 'state',
        label: 'Status',
        format: this.formatExpenseSheetStateColumn.bind(this),
      },
      {
        id: 'print',
        label: 'Drucken',
        format: this.formatExpenseSheetPrintColumn.bind(this),
      },
    ];
  }

  private formatExpenseSheetPrintColumn(expenseSheet: ShortExpenseSheetListing) {
    if (expenseSheet.state === ExpenseSheetState.paid && this.props.mainStore!.isAdmin()) {
      return (
        <div className={this.props.classes.hideButtonText}>
          <Button
            color={'link'}
            href={this.props.mainStore!.apiURL('expense_sheets/' + String(expenseSheet.id!) + '/download')}
            tag={'a'}
            target={'_blank'}
          >
            <FontAwesomeIcon icon={PrintSolidIcon}/> <span>Drucken</span>
          </Button>
        </div>
      );
    } else {
      return <React.Fragment/>;
    }
  }

  private formatExpenseSheetStateColumn(expenseSheet: ShortExpenseSheetListing) {
    const { icon, tooltip, color } = ExpenseSheetSubformInner.getExpenseSheetColumnProps(expenseSheet);

    return (
      <>
        <span id={'expenseSheetState' + expenseSheet.id}>
          <FontAwesomeIcon icon={icon} color={color}/>
        </span>
        <Tooltip
          placement="bottom"
          target={'expenseSheetState' + expenseSheet.id}
          isOpen={this.state.openTooltips[expenseSheet.id!]}
          toggle={() => this.handleOpenTooltip(expenseSheet.id!)}
        >
          {tooltip}
        </Tooltip>
      </>
    );
  }

  private safeFormatDate(date: string) {
    return date ? this.props.mainStore!.formatDate(date) : '';
  }
}

export const ExpenseSheetSubform = injectSheet(styles)(ExpenseSheetSubformInner);
