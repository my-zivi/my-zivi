import * as React from 'react';
import { SafeClickableTableRow } from '../utilities/SafeClickableTableRow';
import { observer } from 'mobx-react';
import { Column } from '../types';
import Table from 'reactstrap/lib/Table';

//tslint:disable:no-any ; this is adapted from the docs. It should be typed eventually.

function format<T>(def: Column<T>, row: T): React.ReactNode {
  if (def.format) {
    return def.format(row);
  } else {
    return row[def.id];
  }
}

//tslint:enable:no-any

interface TableProps<T> {
  columns: Array<Column<T>>;
  renderActions?: (e: T) => React.ReactNode;
  data: Array<T>;
  onClickRow?: (e: T, index: number) => void;
}

@observer
export class OverviewTable<T> extends React.Component<TableProps<T>> {
  public handleRowClick = (row: T, index: number) => (e: React.MouseEvent<HTMLElement>) => {
    if (this.props.onClickRow) {
      this.props.onClickRow(row, index);
    }
  };

  public render() {
    const { columns, data } = this.props;
    return (
      <Table>
        <thead>
          <tr>
            {columns.map(col => (
              <th key={col.id}>{col.label}</th>
            ))}
            {this.props.renderActions && <th />}
          </tr>
        </thead>
        <tbody>
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
      </Table>
    );
  }
}
