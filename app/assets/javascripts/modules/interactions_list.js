Box.Application.addModule('interactions-list', function(context) {
  'use strict';

  var $;

  var cabinet_db,
    module_el;

  function fill_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#interactions').empty();
    for (var k in med.interactions) {
      $module_el.find('#interactions').append('<li>' + med.name + ' & ' + k + '</li>' )
    }
  }

  function clear_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#interactions').empty();
  }

  return {
    messages: ['medicine_inactive', 'data_loaded'],

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
        case 'medicine_inactive':
          clear_information();
          break;

        case 'data_loaded':
          fill_information(cabinet_db.get(data));
          break;
      }
    }
  }
});
