import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { Link } from 'react-router-dom';
import Button from 'reactstrap/lib/Button';
import ButtonGroup from 'reactstrap/lib/ButtonGroup';
import IziviContent from '../../layout/IziviContent';
import { OverviewTable } from '../../layout/OverviewTable';
import { ExpenseSheetStore } from '../../stores/expenseSheetStore';
import { MainStore } from '../../stores/mainStore';
import { Column, ExpenseSheetListing } from '../../types';
import { ExpenseSheetStatisticFormDialog } from './ExpenseSheetStatisticFormDialog';

interface Props {
  mainStore?: MainStore;
  expenseSheetStore?: ExpenseSheetStore;
}

interface State {
  loading: boolean;
  modalOpen: boolean;
  expenseSheetStateFilter: string | null;
}

@inject('mainStore', 'expenseSheetStore')
@observer
export class ExpenseSheetOverview extends React.Component<Props, State> {
  columns: Array<Column<ExpenseSheetListing>>;

  constructor(props: Props) {
    super(props);
    this.columns = [
      {
        id: 'zdp',
        label: 'ZDP',
        format: ({ user: { zdp } }: ExpenseSheetListing) => zdp,
      },
      {
        id: 'first_name',
        label: 'Name',
        format: ({ user: { id, full_name } }: ExpenseSheetListing) => (
          <Link to={'/users/' + id}>{full_name}</Link>
        ),
      },
      {
        id: 'start',
        label: 'Von',
        format: ({ beginning }: ExpenseSheetListing) => this.props.mainStore!.formatDate(beginning),
      },
      {
        id: 'end',
        label: 'Bis',
        format: ({ ending }: ExpenseSheetListing) => this.props.mainStore!.formatDate(ending),
      },
    ];

    this.state = {
      loading: true,
      modalOpen: false,
      expenseSheetStateFilter: 'pending',
    };
  }

  componentDidMount(): void {
    this.loadContent();
  }

  loadContent = () => {
    this.props.expenseSheetStore!.fetchAll({ filter: this.state.expenseSheetStateFilter }).then(() => this.setState({ loading: false }));
  }

  updateSheetFilter = (state: string | null) => {
    this.setState({ loading: true, expenseSheetStateFilter: state }, () => this.loadContent());
  }

  render() {
    return (
      <IziviContent card loading={this.state.loading} title={'Spesen'}>
        <Button outline className="mb-4 d-block" onClick={() => this.toggle()}>
          Spesenstatistik generieren
        </Button>
        <ButtonGroup className="mb-4">
          <Button
            outline={this.state.expenseSheetStateFilter !== null}
            color={this.state.expenseSheetStateFilter === null ? 'primary' : 'secondary'}
            onClick={() => this.updateSheetFilter(null)}
          >
            Alle Spesenblätter
          </Button>
          <Button
            outline={this.state.expenseSheetStateFilter !== 'pending'}
            color={this.state.expenseSheetStateFilter === 'pending' ? 'primary' : 'secondary'}
            onClick={() => this.updateSheetFilter('pending')}
          >
            Pendente Spesenblätter
          </Button>
          <Button
            outline={this.state.expenseSheetStateFilter !== 'current'}
            color={this.state.expenseSheetStateFilter === 'current' ? 'primary' : 'secondary'}
            onClick={() => this.updateSheetFilter('current')}
          >
            Aktuelle Spesenblätter
          </Button>
        </ButtonGroup>
        <ExpenseSheetStatisticFormDialog isOpen={this.state.modalOpen} mainStore={this.props.mainStore!} toggle={() => this.toggle()}/>
        <OverviewTable
          columns={this.columns}
          data={this.props.expenseSheetStore!.expenseSheets}
          renderActions={(e: ExpenseSheetListing) => <Link to={'/expense_sheets/' + e.id}>Spesenblatt bearbeiten</Link>}
        />
      </IziviContent>
    );
  }

  protected toggle() {
    this.setState({ modalOpen: !this.state.modalOpen });
  }
}
