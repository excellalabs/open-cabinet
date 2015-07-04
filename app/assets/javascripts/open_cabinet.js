var owl;

$(document).ready(open_cabinet);
$(document).on('page:load', open_cabinet);

function open_cabinet() {
  toggle_responsiveness();
  $(window).on('resize', toggle_responsiveness);

  Box.Application.init({
    debug: true
  });

  // if($('.shelves').length > 0) {
  //   $('.shelves').attr('data-module', 'cabinet');
  //   var elm = document.getElementById('shelves');
  //   Box.Application.start(elm);
  // }

   fix_flip();
}

function fix_flip() {
  $('.strategy-wrapper form').each(function(idx, elm) {
    var $this = $(this);
    $this.find('.onoffswitch-checkbox').attr('id', 'myonoffswitch' + idx);
    $this.find('label').attr('for', 'myonoffswitch' + idx)

  });
}

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
    $('.reaction-list li').off('click');
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