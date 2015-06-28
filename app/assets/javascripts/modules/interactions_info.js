Box.Application.addModule('interactions-info', function(context) {
  'use strict';

  var $;

  var module_el;

  function fill_information(med) {
    var $module_el = $(module_el);

    $module_el.find('#interactions-text').html(load_interaction_text(med));
    $module_el.find('.primary-name').text(med.primary);
  }

  function highlight_interactions(event) {
    $('.neon').removeClass('neon');
    $(".interaction-pair-mobile span, #interactions-text span").removeAttr('id');

    $("#interactions").children().removeClass("active");
    var element = event.target.className;

    $("#interactions-text").children().hide();
    $(".interaction-" + element).show();

    $('.' + element + '.highlight').each(function (index, span) {
      $(span).addClass('neon');
      $(span).attr('id', 'scroll-to-' + index);
    });

    $(event.target).addClass("active");

    var offset_height = 80;
    if(is_tablet_and_down()) {
      offset_height = $('ul#interactions').height();
    }

    $('#interactions-info').parent().animate({
      scrollTop: ($('#scroll-to-0').position().top - offset_height)
     }, 'slow');
  }

  return {
    messages: ['reload_data', 'highlight_interactions'],
    behaviors: ['navigation'],

    init: function() {
      $ = context.getGlobal('jQuery');
      module_el = context.getElement();
    },

    destroy: function() {
      module_el = null;
    },

    onmessage: function(name, data) {
      switch(name) {

        case 'reload_data':
          fill_information(data);
          break;

        case 'highlight_interactions':
          highlight_interactions(data);
          break;
      }
    }
  }
});
