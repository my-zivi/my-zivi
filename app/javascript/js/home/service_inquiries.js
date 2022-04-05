import $ from 'jquery';

$(document).on('turbo:load turbo:frame-load', () => {
  $('[data-toggle-submit]').on('change', (e) => {
    const $submitButton = $(e.currentTarget).closest('form').find('[type="submit"]');
    if (e.currentTarget.checked) {
      $submitButton.removeAttr('disabled');
    } else {
      $submitButton.attr('disabled', 'disabled');
    }
  });
});
