import iziToast from 'izitoast/dist/js/iziToast.js';

function showSuccess(title, msg) {
  iziToast.show({
    id: 'save-success',
    theme: 'light',
    color: 'green',
    title: title,
    message: msg,
    position: 'topCenter',
    transitionIn: 'flipInX',
    transitionOut: 'flipOutX',
    progressBarColor: 'rgb(0, 255, 0)',
    layout: 2,
    timeout: 2000,
    onClose: function() {
      // console.info('onClose');
    },
  });
}

function showError(title, msg) {
  iziToast.show({
    id: 'save-success',
    theme: 'dark',
    color: 'red',
    title: title,
    message: msg,
    position: 'topCenter',
    transitionIn: 'flipInX',
    transitionOut: 'flipOutX',
    progressBarColor: 'rgb(255, 0, 0)',
    layout: 2,
    timeout: 4000,
    onClose: function() {
      // console.info('onClose');
    },
  });
}

// Export
const Toast = { showSuccess, showError };
export default Toast;
