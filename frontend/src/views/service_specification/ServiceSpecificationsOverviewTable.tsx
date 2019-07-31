import { ary, compact, flatMap, partial } from 'lodash';
import * as React from 'react';
import { WithSheet } from 'react-jss';
import Table from 'reactstrap/lib/Table';
import Tooltip from 'reactstrap/lib/Tooltip';
import serviceSpecificationStyles from './serviceSpecificationOverviewStyle';

interface TableHeader {
  label: string;
  tooltip?: string;
  span?: {
    col?: number;
    row?: number;
  };
  subcolumns?: TableHeader[];
}

const DAILY_EXPENSES_SUBCOLUMNS = [
  { label: 'Erster Tag' },
  { label: 'Arbeit' },
  { label: 'Frei' },
  { label: 'Letzter Tag' },
];

const COLUMNS: TableHeader[] = [
  { label: 'Aktiv', span: { row: 2 } },
  { label: 'ID', tooltip: 'Pflichtenheft Nummer', span: { row: 2 } },
  { label: 'Name', span: { row: 2 } },
  { label: 'KN', tooltip: 'Kurz-Name', span: { row: 2 } },
  { label: 'Taschengeld', tooltip: 'Taschengeld (Fixer Betrag)', span: { row: 2 } },
  { label: 'Unterkunft', span: { row: 2 } },
  { label: 'Kleider', span: { row: 2 } },
  { label: 'Frühstück', span: { col: 4 }, subcolumns: DAILY_EXPENSES_SUBCOLUMNS },
  { label: 'Mittagessen', span: { col: 4 }, subcolumns: DAILY_EXPENSES_SUBCOLUMNS },
  { label: 'Abendessen', span: { col: 6 }, subcolumns: DAILY_EXPENSES_SUBCOLUMNS },
];

const TableHeaderTooltip: React.FunctionComponent<{tableHeader: TableHeader, id: string}> = params => {
  const [isOpen, setIsOpen] = React.useState(false);

  if (params.tableHeader.tooltip) {
    return (
      <>
        <div id={params.id}>{params.children}</div>
        <Tooltip placement="bottom" target={params.id} isOpen={isOpen} toggle={ary(partial(setIsOpen, !isOpen), 0)}>
          {params.tableHeader.tooltip}
        </Tooltip>
      </>
    );
  } else {
    return <>{params.children}</>;
  }
};

const OverviewTableHeader = (params: { tableHeaderClasses: string[] }) => {
  const [mainTableHeaderClass, secondaryTableHeaderClass] = params.tableHeaderClasses;
  const secondaryTableHeaders = compact(
    flatMap<TableHeader[], TableHeader | undefined>(COLUMNS, header => (header as TableHeader).subcolumns),
  );

  const layout = [
    { class: mainTableHeaderClass, columns: COLUMNS },
    { class: secondaryTableHeaderClass, columns: secondaryTableHeaders },
  ];

  return (
    <>
      {layout.map((headerRow, headerIndex) => {
        return (
          <tr key={headerIndex}>
            {headerRow.columns.map((column, columnIndex) => (
              <th
                className={headerRow.class}
                key={columnIndex}
                rowSpan={column.span ? column.span.row || 1 : 1}
                colSpan={column.span ? column.span.col || 1 : 1}
              >
                <TableHeaderTooltip tableHeader={column} id={`header-${headerIndex}-${columnIndex}`}>
                  {column.label}
                </TableHeaderTooltip>
              </th>
            ))}
          </tr>
        );
      })}
    </>
  );
};

export const ServiceSpecificationsOverviewTable: React.FunctionComponent<WithSheet<typeof serviceSpecificationStyles>> = props => {
  const { classes } = props;

  return (
    <Table hover={true} responsive={true}>
      <thead>
        <OverviewTableHeader tableHeaderClasses={[classes.th, classes.secondTh]}/>
      </thead>
      <tbody>{props.children}</tbody>
    </Table>
  );
};
