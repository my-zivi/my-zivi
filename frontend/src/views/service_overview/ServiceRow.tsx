import * as React from 'react';

interface ServiceRowProps {
  service_specification_id: string;
  shortName: string;
  user_id: number;
  zdp: number;
  userName: string;
  cells: React.ReactNode[];
  classes: Record<string, string>;
}

function ServiceRow(props: ServiceRowProps) {
  const { classes } = props;

  return (
    <tr className={'service-row-' + props.service_specification_id}>
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

export { ServiceRow };
