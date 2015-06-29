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
  } else if (interactions_length(med) > 0){
    var interactions = med.all_interactions[med.primary];
    for(var k in interactions){
      text += '<span class="interaction-'+ class_name(k) +'">' + med.all_interactions[k].interaction_text +' </span>'
    }
  } else {
    text = 'There is no interaction information for this medicine.'
  }

  return text;
}

function interactions_length(med) {
  if(med.primary in med.all_interactions) {
    var keys = Object.keys(med.all_interactions[med.primary]);
    var non_interaction_item = keys.indexOf('interaction_text');
    if (non_interaction_item != -1 ){
      keys.splice(non_interaction_item, 1);
    }
    return keys.length
  } else {
    return 0;
  }
}

function highlight_keywords(meds, text) {
  $.each(meds, function(key, med) {
    if(key == "interaction_text") return true;
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
