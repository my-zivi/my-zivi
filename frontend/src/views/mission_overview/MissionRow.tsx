import * as React from 'react';
import { ReactNode } from 'react';

interface MissionRowProps {
  specification_id: number;
  shortName: string;
  user_id: number;
  zdp: number;
  userName: string;
  cells: Array<ReactNode>;
  classes: Record<string, string>;
}

function MissionRow(props: MissionRowProps) {
  const { classes } = props;

  return (
    <tr className={'mission-row-' + props.specification_id}>
      <td className={classes.shortName + ' ' + classes.rowTd}>{props.shortName}</td>

      <td className={classes.zdp + ' ' + classes.rowTd}>
        <div className="no-print">{props.zdp}</div>
      </td>

      <td className={classes.namen + ' ' + classes.rowTd}>
        <a href={'/users/' + props.user_id}>{props.userName}</a>
      </td>
      {props.cells}
    </tr>
  );
}

export { MissionRow };
