import iziToast from 'izitoast/dist/js/iziToast.js';
import Auth from './auth';

function showSuccess(title, msg) {
  iziToast.show({
    id: 'toast-success',
    //theme: 'light',
    titleSize: 18,
    titleLineHeight: 20,
    messageSize: 14,
    messageLineHeight: 20,
    icon: 'glyphicon glyphicon-thumbs-up',
    color: 'green',
    title: title,
    message: msg,
    position: 'bottomLeft',
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

function showError(title, msg, error, redirectFn) {
  if (error != null && error.response != null && error.response.status === 401) {
    Auth.removeToken();
    redirectFn('/');
  }

  iziToast.show({
    id: 'toast-failed',
    titleSize: 18,
    titleLineHeight: 20,
    messageSize: 14,
    messageLineHeight: 20,
    icon: 'glyphicon glyphicon-fire',
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

function showWarning(title, msg) {
  iziToast.show({
    id: 'toast-warning',
    titleSize: 24,
    titleLineHeight: 30,
    messageSize: 16,
    messageLineHeight: 30,
    color: 'orange',
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

/*
*
    id: null,
    class: '',
    title: '',
    titleColor: '',
    titleSize: '',
    titleLineHeight: '',
    message: '',
    messageColor: '',
    messageSize: '',
    messageLineHeight: '',
    backgroundColor: '',
    theme: 'light', // dark
    color: '', // blue, red, green, yellow
    icon: '',
    iconText: '',
    iconColor: '',
    image: '',
    imageWidth: 50,
    maxWidth: null,
    zindex: null,
    layout: 1,
    balloon: false,
    close: true,
    rtl: false,
    position: 'bottomRight', // bottomRight, bottomLeft, topRight, topLeft, topCenter, bottomCenter, center
    target: '',
    targetFirst: true,
    toastOnce: false,
    timeout: 5000,
    drag: true,
    pauseOnHover: true,
    resetOnHover: false,
    progressBar: true,
    progressBarColor: '',
    animateInside: true,
    buttons: {},
    transitionIn: 'fadeInUp',
    transitionOut: 'fadeOut',
    transitionInMobile: 'fadeInUp',
    transitionOutMobile: 'fadeOutDown',
    onOpening: function () {},
    onOpened: function () {},
    onClosing: function () {},
    onClosed: function () {}
*
*/

// Export
const Toast = { showSuccess, showError, showWarning };
export default Toast;
