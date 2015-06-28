Box.Application.addModule('interactions-list', function(context) {
  'use strict';

  var $;

  var module_el;

  function fill_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#interactions').empty();
    for (var k in med.interactions) {
      $module_el.find('#interactions').append('<li class="' + class_name(k) + '">' + med.primary + ' & ' + k + '</li>' )
    }

    if(is_tablet_and_down()) {
      $module_el.find('#interactions-text-mobile').html(load_interaction_text(med));
    }   
    
    $module_el.find('.primary-name').text(med.primary);
  }

  return {
    messages: ['reload_data'],
    behaviors: [ 'navigation' ],

    init: function() {
      $ = context.getGlobal('jQuery');
      module_el = context.getElement();
    },

    destroy: function() {
      module_el = null;
    },

    onmessage: function (name, data) {
      switch(name) {
        case 'reload_data':
          fill_information(data);
          break;
      }
    },

    onclick: function (event, element, elementType) {
      if ($(event.target).is('li')) {     

        if(is_mobile()) {
          $('.scroll-to-top').show();
        }
        
        $("#interactions").children().css("background-color", "");
        $(event.target).css("background-color", '#ececec');
        context.broadcast('highlight_interactions', event.target.className);
      }
    }

  }
});
