var owl; 

$(document).on('ready page:load', function() {
  $('.search-bar').attr('data-module', 'autocomplete_search');
  Box.Application.init();

  owl = $(".cabinet");
  
  owl.owlCarousel({
    items: 2, 
    autoHeight: true,
    navigation : false,
    slideSpeed: 800,
    mouseDrag: false,
    itemsCustom : [
        [0, 1],
        [850, 2]
      ]
  });

  toggle_responsiveness();
  $(window).on('resize', toggle_responsiveness);


});

function toggle_responsiveness() {
  if(is_tablet_and_down()) {

    $('.mobile-menu .lines-button').on('click', function() {
      $(this).toggleClass('active');
      $('.mobile-side-menu').toggleClass('open');
      $('.mobile-menu-push').toggleClass('mobile-menu-push-to-left');
    });

    $('.pill-container').on('click', function() {
      owl_to(1);
    });

    $('.reaction-list li').on('click', function() {
      owl_to(3);
    });

  } else {
    $('.mobile-menu .lines-button').off('click');
    $('.pill-container').off('click');
    $('.reaction-list li').iff('click');
  }
}

function owl_to(page) {
  owl.trigger('owl.goTo', page);
}

function is_mobile() {
  return $('.mobile-menu').is(':visible');
}

function is_tablet() {
  return $('.tablet-view').is(':visible');
}

function is_tablet_and_down() {
  return $('.tablet-and-down-view').is(':visible');
}