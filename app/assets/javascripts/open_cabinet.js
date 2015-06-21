$(document).ready(init_cabinet);
$(document).on('page:load', init_cabinet);

function init_cabinet() {
  $('.search-area').attr('data-module', 'autocomplete_search');
  Box.Application.init();
}