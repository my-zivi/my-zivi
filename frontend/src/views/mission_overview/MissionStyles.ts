import createStyles from '../../utilities/createStyles';

const MissionStyles = () =>
  createStyles({
    'rowTd': {
      padding: '5px 1px !important',
      fontSize: '14px',
      textAlign: 'center',
      minWidth: '25px',
      composes: 'mo-rowTd',
    },
    'shortName': {
      minWidth: '40px',
      width: '40px',
      composes: 'mo-shortname',
    },
    'zdp': {
      minWidth: '100px',
      width: '100px',
      composes: 'mo-zdp',
    },
    'namen': {
      minWidth: '150px',
      width: '150px',
      textAlign: 'left',
      composes: 'mo-namen',
    },
    'einsatzDraft': {
      background: '#fc9',
    },
    'einsatz': {
      background: '#0c6',
      composes: 'mo-einsatz',
    },
    'filter': {
      composes: 'mo-filter',
    },
    '@global': {
      '@media not print': {
        'thead, tbody': {
          display: 'block',
        },
        'thead': {
          position: 'relative',
          top: '0px',
          backgroundColor: 'white',
        },
        '.mo-name-header': {
          width: '290px',
        },
      },
      '@media print': {
        '.table td.einsatz': {
          // here media print styling for einsatz. (!important)
          // backgroundColor: '!important',
        },
        '.table-no-padding': {},
        '.mo-rowTd': {
          padding: '1px 1px 1px 1px !important',
          minWidth: '0px!important',
        },
        'td': {
          fontSize: '6pt !important',
        },
        '.mo-namen': {
          maxWidth: '65px',
          width: '65px',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
          paddingLeft: '1px !important',
        },
        '.mo-namen a': {
          color: 'black!important',
          textDecoration: 'none',
        },
        '.mo-filter': {
          display: 'none',
        },
        '.no-print': {
          width: '0px',
          display: 'none',
        },
        '.mo-zdp': {
          width: '0px',
        },
        '.mo-shortname': {
          width: 'auto',
        },
        '.mo-container': {
          padding: '0px!important',
          margin: '0px!important',
        },
      },
    },
  });

export { MissionStyles };
