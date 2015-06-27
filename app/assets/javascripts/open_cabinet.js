var owl;

$(document).ready(open_cabinet);
$(document).on('page:load', open_cabinet);

function open_cabinet() {
  toggle_responsiveness();
  $(window).on('resize', toggle_responsiveness);

  Box.Application.init({
    debug: true
  });

  if ($('.shelves').length > 0) {
    $('.shelves').attr('data-module', 'cabinet');
    var elm = document.getElementById('shelves');
    Box.Application.start(elm);
  }
}

function toggle_responsiveness() {
  if(is_mobile()) {
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

function class_name(str) {
  return str.replace(/[^a-z0-9\s]/gi, '').replace(/[_\s]/g, '-')
}

function load_interaction_text(med) {
  var text = '';
  if (med.interactions && med.interactions_text) {
    text = highlight_keywords(med.interactions, med.interactions_text)
  } else {
    text = 'There is no interaction information for this medicine.'
  }

  return text;
}

function highlight_keywords(meds, text) {
  $.each(meds, function(key, med) {
    var reg = new RegExp(med.filter(Boolean).join('|'), 'gi');
    text = text.replace(reg, '<span class="' + class_name(key) + ' highlight">$&</span>')
  });

  return text;
}

function toggle_loader(show_loader) {
  if(show_loader) {
    $('#medicine_information .content').hide();
    $('#medicine_information .fa-refresh').show();
  } else {
    $('#medicine_information .content').show();
    $('#medicine_information .fa-refresh').hide();
  }
}
