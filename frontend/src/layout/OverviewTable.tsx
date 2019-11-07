import * as _ from 'lodash';
import { observer } from 'mobx-react';
import * as React from 'react';
import Table from 'reactstrap/lib/Table';
import { Column } from '../types';
import { SafeClickableTableRow } from '../utilities/SafeClickableTableRow';

// tslint:disable:no-any ; this is adapted from the docs. It should be typed eventually.

function format<T>(def: Column<T>, row: T): React.ReactNode {
  if (def.format) {
    return def.format(row);
  } else {
    return row[def.id];
  }
}

function calcsum(arr: any[]): number {
  return _.sumBy(arr, object => object.total) / 100;
}

// tslint:enable:no-any

interface TableProps<T> {
  columns: Array<Column<T>>;
  renderActions?: (e: T) => React.ReactNode;
  data: T[];
  onClickRow?: (e: T, index: number) => void;
  firstRow?: React.ReactNode;
}

@observer
export class OverviewTable<T> extends React.Component<TableProps<T>> {
  handleRowClick = (row: T, index: number) => (e: React.MouseEvent<HTMLElement>) => {
    if (this.props.onClickRow) {
      this.props.onClickRow(row, index);
    }
  }

  render() {
    const { columns, data } = this.props;

    return (
      <Table responsive>
        <thead>
          <tr>
            {columns.map(col => (
              <th key={col.id}>{col.label}</th>
            ))}
            {this.props.renderActions && <th />}
          </tr>
        </thead>
        <tbody>
          {this.props.firstRow && <>{this.props.firstRow}</>}
          {data.map((row, index) => (
            <SafeClickableTableRow key={index} onClick={this.handleRowClick(row, index)}>
              {columns.map(col => (
                <td key={col.id}>{format(col, row)}</td>
              ))}
              {this.props.renderActions && (
                <td>
                  <span className={'actions'}>{this.props.renderActions(row)}</span>
                </td>
              )}
            </SafeClickableTableRow>
          ))}
        </tbody>
        {calcsum(data).toFixed(2) !== 'NaN' &&
        <tfoot>
          <tr>
            <td>
              <b>Betrag Total: {calcsum(data).toFixed(2)} CHF</b>
            </td>
          </tr>
        </tfoot>}
      </Table>
    );
  }
}
