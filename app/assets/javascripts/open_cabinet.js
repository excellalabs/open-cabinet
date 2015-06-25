var owl;

$(document).on('ready page:load', function() {
  $('.search-bar').attr('data-module', 'autocomplete_search');
  Box.Application.init();
  if ($('.shelves').length > 0) {
    $('.shelves').attr('data-module', 'cabinet');
    var elm = document.getElementById('shelves');
    Box.Application.start(elm);
  }

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

  } else {
    $('.mobile-menu .lines-button').off('click');
    $('.pill-container').off('click');
    $('.reaction-list li').iff('click');
  }
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
