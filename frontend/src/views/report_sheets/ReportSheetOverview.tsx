import * as React from 'react';
import { Column, ReportSheet } from '../../types';
import Overview from '../../layout/Overview';
import { inject, observer } from 'mobx-react';
import { ReportSheetStore } from '../../stores/reportSheetStore';
import { Link } from 'react-router-dom';
import { MainStore } from '../../stores/mainStore';

interface Props {
  mainStore?: MainStore;
  reportSheetStore?: ReportSheetStore;
}

@inject('mainStore', 'reportSheetStore')
@observer
export class ReportSheetOverview extends React.Component<Props> {
  public columns: Array<Column<ReportSheet>>;

  constructor(props: Props) {
    super(props);
    this.columns = [
      {
        id: 'zdp',
        label: 'ZDP',
        format: (r: ReportSheet) => <>{String(r.user.zdp)}</>,
      },
      {
        id: 'first_name',
        label: 'Name',
        format: (r: ReportSheet) => <>{`${r.user.first_name} ${r.user.last_name}`}</>,
      },
      {
        id: 'start',
        label: 'Von',
        format: (r: ReportSheet) => this.props.mainStore!.formatDate(r.start),
      },
      {
        id: 'end',
        label: 'Bis',
        format: (r: ReportSheet) => this.props.mainStore!.formatDate(r.end),
      },
    ];
  }

  public render() {
    return (
      <Overview
        columns={this.columns}
        store={this.props.reportSheetStore!}
        title={'Spesenblätter'}
        renderActions={(e: ReportSheet) => (
          <>
            <Link to={'/report_sheets/' + e.id}>Spesenblatt bearbeiten</Link>
          </>
        )}
      />
    );
  }
}
