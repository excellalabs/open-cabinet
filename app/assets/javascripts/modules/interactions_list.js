Box.Application.addModule('interactions-list', function(context) {
  'use strict';

  var $;

  var module_el;

  function fill_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#interactions').empty();
    for (var k in med.interactions) {
      build_interaction_li(med.primary, k);
    }
    
    if(Object.keys(med.interactions).length == 0 && interactions_length(med) > 0){
      var interactions = med.all_interactions[med.primary];
      for(var k in interactions){
        build_interaction_li(med.primary, k);
      }
    }

    if(is_tablet_and_down()) {
      $module_el.find('#interactions-text-mobile').html(load_interaction_text(med));
    }

    $module_el.find('.primary-name').text(med.primary);
  }

  function build_interaction_li(primary, interaction){
    var $module_el = $(module_el);
    $module_el.find('#interactions')
              .append('<li data-primary-name="' + primary + '" data-interaction-name="' + interaction + '" class="' + class_name(interaction) + '">' + primary + ' & ' + interaction + '</li>' );
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

        context.broadcast('highlight_interactions', event);
      }
    }

  }
});
