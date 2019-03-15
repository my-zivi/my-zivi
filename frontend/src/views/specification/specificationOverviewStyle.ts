import createStyles from '../../utilities/createStyles';

const specificationStyles = () =>
  createStyles({
    smallFontSize: {
      fontSize: '14px',
    },
    inputs: {
      composes: '$smallFontSize',
      padding: '3px 6px !important',
      width: 'auto !important',
    },

    rowTd: {
      composes: '$smallFontSize',
      padding: '5px 2px !important',
      verticalAlign: 'top',
    },
    th: {
      composes: '$smallFontSize',
      padding: '10px 8px !important',
      whiteSpace: 'nowrap',
    },
    secondTh: {
      composes: '$smallFontSize $th',
      fontWeight: 400,
      whiteSpace: 'nowrap',
    },
    buttonsTd: {
      composes: '$inputs',
      padding: '5px !important',
    },

    checkboxes: {
      composes: '$inputs',
      marginLeft: '0px !important',
      marginTop: '0.75rem',
    },
  });

export default specificationStyles;
