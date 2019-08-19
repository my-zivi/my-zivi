import createStyles from '../../../utilities/createStyles';

export const paymentDetailStyles = () => createStyles({
  '@keyframes blur': {
    from: { filter: 'grayscale(0) blur(0px)' },
    to: { filter: 'grayscale(1) blur(2px)' },
  },
  '@keyframes fadeIn': {
    from: { transform: 'scale(1.13) rotate(0)', opacity: 0 },
    to: { transform: 'scale(1) rotate(-10deg)', opacity: 1 },
  },
  'canceledDetailCard': {
    filter: 'grayscale(1) blur(2px)',
    animationName: 'blur',
    animationDuration: '0.25s',
  },
  'cancelBadge': {
    animationName: 'fadeIn',
    animationDuration: '0.25s',
    position: 'absolute',
    zIndex: '2',
    fontSize: '4em',
    color: 'rgba(0,0,0,0.7)',
    border: '4px solid rgba(0,0,0,0.7)',
    borderRadius: '10px',
    padding: '0px 16px',
    top: '88px',
    transform: 'rotate(-10deg)',
    left: '50%',
    marginLeft: '-250px',
  },
});
