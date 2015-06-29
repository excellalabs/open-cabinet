Box.Application.addModule('interactions-info', function(context) {
  'use strict';

  var module_el;
  var med_data;

  function interaction_text_or_default(med_name, interaction_name, data) {
    var interaction_text = data.all_interactions[med_name].interaction_text;
    if(!interaction_text) return "No interaction label data is present.";
    return highlight_keywords(data.all_interactions[med_name], interaction_text);
  }

  function fill_information(med, selected_med) {
    var $module_el = $(module_el);
    var med_name = med.primary;
    $module_el.find('#primary-medicine-interactions-text').html(interaction_text_or_default(med_name, selected_med, med));
    $module_el.find('.primary-name').text(med.primary);
    $module_el.find('#interaction-medicine-interactions-text').html(interaction_text_or_default(selected_med, med_name, med));
    $module_el.find('.interaction-name').text(selected_med);
    $('#interaction-data-container').show();
    $('#no-data-loaded-container').hide();
  }

  function add_highlight(selector) {
    $(selector).each(function (index, span) {
      $(span).addClass('neon');
      $(span).addClass('scroll-to-' + index);
    });

    $(event.target).addClass("active");
  }

  function highlight_interactions(event) {
    $('.neon').removeClass('neon');

    $("#interactions").children().removeClass("active");
    var interaction_element = $(event.target).attr('data-interaction-name');
    var primary_element = $(event.target).attr('data-primary-name');

    add_highlight('.' + interaction_element + '.highlight');
    add_highlight('.' + primary_element + '.highlight');

    var offset_height = 80;
    if(is_tablet_and_down()) {
      offset_height = $('ul#interactions').height();
    }
    if($('.scroll-to-0').length) {
      $('#interactions-info').parent().animate({
      scrollTop: ($('.scroll-to-0').position().top - offset_height)
     }, 'slow');
    }
  }

  return {
    messages: ['reload_data', 'highlight_interactions'],
    behaviors: ['navigation'],

    init: function() {
      module_el = context.getElement();
    },
    onmessage: function(name, data) {
      switch(name) {

        case 'reload_data':
          med_data = data;
          $('#interaction-data-container').hide();
          $('#no-data-loaded-container').show();
          break;

        case 'highlight_interactions':
          var selected_med = $(data.target).attr('data-interaction-name');
          fill_information(med_data, selected_med);
          highlight_interactions(data);
          break;
      }
    }
  }
});
