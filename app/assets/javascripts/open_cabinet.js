var owl; 

$(document).on('ready page:load', function() {
  $('.search-bar').attr('data-module', 'autocomplete_search');
  Box.Application.init();

  owl = $(".cabinet");
  
  owl.owlCarousel({
    items: 2, 
    autoHeight: true,
    navigation : false,
    slideSpeed: 800
  });
});