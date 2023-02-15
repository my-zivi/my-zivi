import $ from 'jquery';

const changeHandler = (e) => {
  const $submitButton = $(e.currentTarget).closest('form').find('[type="submit"]');
  if (e.currentTarget.checked) {
    $submitButton.removeAttr('disabled');
  } else {
    $submitButton.attr('disabled', 'disabled');
  }
};

const loadHandler = () => {
  $('[data-toggle-submit]').on('change', changeHandler);
  $('turbo-frame').on('turbo:load turbo:frame-load', loadHandler);
};

$(document).on('turbo:load turbo:frame-load', loadHandler);
