import { Mission } from '../../types';
import * as React from 'react';

interface MissionRowProps {
  mission: Mission;
  cells: Array<any>;
  classes: Record<string, string>;
}

function MissionRow(props: MissionRowProps) {
  const { classes } = props;

  return (
    <tr className={'mission-row-' + props.mission.specification_id}>
      <td className={classes.shortName + ' ' + classes.rowTd}>{props.mission.specification!.short_name}</td>

      <td className={classes.zdp + ' ' + classes.rowTd}>
        <div className="no-print">{props.mission.user!.zdp}</div>
      </td>

      <td className={classes.namen + ' ' + classes.rowTd}>
        <a href={'/users/' + props.mission.user_id}>{props.mission.user!.first_name + ' ' + props.mission.user!.last_name}</a>
      </td>
      {props.cells}
    </tr>
  );
}

export { MissionRow };
