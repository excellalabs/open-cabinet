$(document).ready(init_cabinet);
$(document).on('page:load', init_cabinet);

function init_cabinet() {
  $('#t3_container').attr('data-module', 'hello');
  Box.Application.init(); 
}