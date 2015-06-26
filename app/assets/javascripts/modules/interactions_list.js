Box.Application.addModule('interactions-list', function(context) {
  'use strict';

  var $;

  var cabinet_db,
      module_el;

  function fill_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#interactions').empty();
    for (var k in med.interactions) {
      $module_el.find('#interactions').append('<li class="' + k + '">' + med.primary + ' & ' + k + '</li>' )
    }
  }

  return {
    messages: ['reload_data'],
    behaviors: [ 'navigation' ],

    init: function() {
      $ = context.getGlobal('jQuery');
      cabinet_db = context.getService('cabinet-db');
      cabinet_db.load(gon.meds);
      module_el = context.getElement();
    },

    destroy: function() {
      cabinet_db = null;
      module_el = null;
    },

    onmessage: function (name, data) {
      switch(name) {
        case 'reload_data':
          fill_information(data);
          $("#interactions").children().first().css("background-color", '#ececec');
          break;
      }
    },

    onclick: function (event, element, elementType) {
      if ($(event.target).is('li')) {
        $("#interactions").children().css("background-color", "");
        $(event.target).css("background-color", '#ececec');
        context.broadcast('highlight_interactions', event.target.className);
      }
    }

  }
});
