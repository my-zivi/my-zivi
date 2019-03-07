import * as React from 'react';
import { ReportSheetForm } from './ReportSheetForm';
import { ReportSheetStore } from '../../stores/reportSheetStore';
import { inject, observer } from 'mobx-react';
import { RouteComponentProps } from 'react-router';
import { FormValues, ReportSheet } from '../../types';
import { toJS } from 'mobx';

interface ReportSheetDetailRouterProps {
  id?: string;
}

interface Props extends RouteComponentProps<ReportSheetDetailRouterProps> {
  reportSheetStore?: ReportSheetStore;
}

@inject('reportSheetStore')
@observer
export class ReportSheetUpdate extends React.Component<Props> {
  constructor(props: Props) {
    super(props);
    props.reportSheetStore!.fetchOne(Number(props.match.params.id));
  }

  public handleSubmit = (reportSheet: ReportSheet) => {
    return this.props.reportSheetStore!.put(reportSheet);
  };

  public get reportSheet() {
    const reportSheet = this.props.reportSheetStore!.reportSheet;
    if (reportSheet) {
      return toJS(reportSheet);
      //it's important to detach the mobx proxy before passing it into formik - formik's deepClone can fall into endless recursions with those proxies.
    } else {
      return undefined;
    }
  }

  public render() {
    const reportSheet = this.reportSheet;

    return (
      <ReportSheetForm
        onSubmit={this.handleSubmit}
        reportSheet={reportSheet as FormValues}
        title={
          reportSheet
            ? reportSheet.user
              ? `Spesenblatt von ${reportSheet.user.first_name} ${reportSheet.user.last_name} bearbeiten`
              : 'Spesenbaltt bearbeiten'
            : 'Spesenblatt wird geladen'
        }
      />
    );
  }
}
