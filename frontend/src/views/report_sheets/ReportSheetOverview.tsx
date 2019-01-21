import * as React from 'react';
import { Column, ReportSheetListing } from '../../types';
import { inject, observer } from 'mobx-react';
import { ReportSheetStore } from '../../stores/reportSheetStore';
import { Link } from 'react-router-dom';
import { MainStore } from '../../stores/mainStore';
import Button from 'reactstrap/lib/Button';
import { ReportSheetStatisticFormDialog } from './ReportSheetStatisticFormDialog';
import ButtonGroup from 'reactstrap/lib/ButtonGroup';
import { OverviewTable } from '../../layout/OverviewTable';
import IziviContent from '../../layout/IziviContent';

interface Props {
  mainStore?: MainStore;
  reportSheetStore?: ReportSheetStore;
}

interface State {
  loading: boolean;
  modalOpen: boolean;
  reportSheetStateFilter: string | null;
}

@inject('mainStore', 'reportSheetStore')
@observer
export class ReportSheetOverview extends React.Component<Props, State> {
  public columns: Array<Column<ReportSheetListing>>;

  constructor(props: Props) {
    super(props);
    this.columns = [
      {
        id: 'zdp',
        label: 'ZDP',
      },
      {
        id: 'first_name',
        label: 'Name',
        format: (r: ReportSheetListing) => `${r.first_name} ${r.last_name}`,
      },
      {
        id: 'start',
        label: 'Von',
        format: (r: ReportSheetListing) => this.props.mainStore!.formatDate(r.start),
      },
      {
        id: 'end',
        label: 'Bis',
        format: (r: ReportSheetListing) => this.props.mainStore!.formatDate(r.end),
      },
    ];

    this.state = {
      loading: true,
      modalOpen: false,
      reportSheetStateFilter: 'pending',
    };
  }

  public componentDidMount(): void {
    this.loadContent();
  }

  public loadContent = () => {
    this.props.reportSheetStore!.fetchAll({ state: this.state.reportSheetStateFilter }).then(() => this.setState({ loading: false }));
  };

  public updateSheetFilter = (state: string | null) => {
    this.setState({ loading: true, reportSheetStateFilter: state }, () => this.loadContent());
  };

  protected toggle() {
    this.setState({ modalOpen: !this.state.modalOpen });
  }

  public render() {
    return (
      <IziviContent card loading={this.state.loading} title={'Spesen'}>
        <Button outline onClick={() => this.toggle()}>
          Spesenstatistik generieren
        </Button>{' '}
        <br /> <br />
        <ButtonGroup>
          <Button
            outline={this.state.reportSheetStateFilter !== null}
            color={this.state.reportSheetStateFilter === null ? 'primary' : 'secondary'}
            onClick={() => this.updateSheetFilter(null)}
          >
            Alle Spesenblätter
          </Button>
          <Button
            outline={this.state.reportSheetStateFilter !== 'pending'}
            color={this.state.reportSheetStateFilter === 'pending' ? 'primary' : 'secondary'}
            onClick={() => this.updateSheetFilter('pending')}
          >
            Pendente Spesenblätter
          </Button>
          <Button
            outline={this.state.reportSheetStateFilter !== 'current'}
            color={this.state.reportSheetStateFilter === 'current' ? 'primary' : 'secondary'}
            onClick={() => this.updateSheetFilter('current')}
          >
            Aktuelle Spesenblätter
          </Button>
        </ButtonGroup>
        <ReportSheetStatisticFormDialog isOpen={this.state.modalOpen} mainStore={this.props.mainStore!} toggle={() => this.toggle()} />
        <br /> <br />
        <OverviewTable
          columns={this.columns}
          data={this.props.reportSheetStore!.reportSheets}
          renderActions={(e: ReportSheetListing) => <Link to={'/report_sheets/' + e.id}>Spesenblatt bearbeiten</Link>}
        />
      </IziviContent>
    );
  }
}
