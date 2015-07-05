var owl;

$(document).ready(open_cabinet);
$(document).on('page:load', open_cabinet);

function open_cabinet() {

  console.log('open-cabinet');
  
  Box.Application.init({
    debug: true
  });

  fix_flip();
  responsive_toggle();
  $(window).on('resize', responsive_toggle);
}

function responsive_toggle() {
  if(is_device.any()) {
    //*-- fast click to handle iOS touch latency
    window.addEventListener('load', function() {
        new FastClick(document.body);
    }, false);

  } 

  responsive_autocomplete();
  responsive_menu();
  load_tooltips();
}

//*-- in mobile move input up to accomodate keyboard
function responsive_autocomplete() {
  if(is_device.any()) {
    $('.search-bar input').on('focusin', function() {
      $('html, body').animate({ scrollTop: $('.search-bar').offset().top }, 'slow');
    });
  } else {
    $('.search-bar input').off('focusin');
  }
}

//*-- in mobile + tablet show hamburger menu
function responsive_menu() {
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

//*-- checks for window size
function is_mobile() {
  return $('.mobile-menu').is(':visible');
}

function is_tablet() {
  return $('.tablet-view').is(':visible');
}

function is_tablet_and_down() {
  return $('.tablet-and-down-view').is(':visible');
}

//*-- check if it is a mobile device
var is_device = {
  android: function() {
      return navigator.userAgent.match(/Android/i);
  },
  blackberry: function() {
      return navigator.userAgent.match(/BlackBerry/i);
  },
  ios: function() {
      return navigator.userAgent.match(/iPhone|iPad|iPod/i);
  },
  opera: function() {
      return navigator.userAgent.match(/Opera Mini/i);
  },
  windows: function() {
      return navigator.userAgent.match(/IEMobile/i) || navigator.userAgent.match(/WPDesktop/i);
  },
  any: function() {
    return (is_device.android() || is_device.blackberry() || is_device.ios() || is_device.opera() || is_device.windows());
  }
};

//*-- tooltips
function load_tooltips() {
  if(!is_tablet_and_down()) {
    $('.tooltip').tipso({
      background: '#12a3d2',
      border_color: '#0e7fa3'
    });
  }
}

function fix_flip() {
  $('.strategy-wrapper form').each(function(idx, elm) {
    var $this = $(this);
    $this.find('.onoffswitch-checkbox').attr('id', 'myonoffswitch' + idx);
    $this.find('label').attr('for', 'myonoffswitch' + idx)

  });
}

function class_name(str) {
  return str.replace(/[^a-z0-9\s]/gi, '').replace(/[_\s]/g, '-')
}