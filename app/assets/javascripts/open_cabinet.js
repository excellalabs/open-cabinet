$(document).on('ready page:load', function() {
  $('.search-bar').attr('data-module', 'autocomplete_search');
  Box.Application.init();

  $('.pill-bottle').on('click', function() {
    $('.o-wrapper').addClass('is-active');
    $('.c-menu--push-right').addClass('is-active');
  })
});