import iziToast, { IziToastSettings } from 'izitoast';

const defaults: IziToastSettings = {
  messageSize: '14',
  messageLineHeight: '20',
  position: 'bottomLeft',
  transitionIn: 'flipInX',
  transitionOut: 'flipOutX',
  layout: 2,
  // timeout: 2000,
};

export function displaySuccess(message: string) {
  iziToast.show({
    ...defaults,
    id: 'toast-success',
    icon: 'glyphicon glyphicon-thumbs-up',
    color: 'green',
    progressBarColor: 'rgb(0, 255, 0)',
    message,
  });
}

export function displayError(message: string) {
  iziToast.show({
    ...defaults,
    id: 'toast-failed',
    icon: 'glyphicon glyphicon-fire',
    color: 'red',
    progressBarColor: 'rgb(255, 0, 0)',
    message,
  });
}

export function displayWarning(message: string) {
  iziToast.show({
    id: 'toast-warning',
    color: 'orange',
    progressBarColor: 'rgb(255, 0, 0)',
    message,
  });
}
