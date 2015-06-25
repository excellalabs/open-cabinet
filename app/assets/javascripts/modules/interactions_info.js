Box.Application.addModule('interactions-info', function(context) {
  'use strict';

  var $;

  var cabinet_db,
    module_el;

  function fill_information(med) {
    var $module_el = $(module_el);

    var text = '';
    if (med.interactions && med.interactions_text) {
      text = highlight_keywords(med.interactions, med.interactions_text)
    } else {
      text = 'There is no interaction information for this medicine.'
    }
    $module_el.find('#interactions-text').html(text);
  }

  function clear_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#interactions-text').empty();
  }

  function highlight_keywords(meds, text) {
    var html = '';
    $.each(meds, function(key, med) {
      var reg = new RegExp(med.join('|'), 'gi');
      html = text.replace(reg, '<span class="' + key + ' highlight">$&</span>')
    });

    return html;
  }

  return {
    messages: ['medicine_active', 'medicine_inactive', 'data_loaded'],
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
        case 'medicine_inactive':
          clear_information();
          break;

        case 'data_loaded':
          fill_information(cabinet_db.get(data));
          break
      }


      if (name == 'refresh_shelves') {
        redraw_shelf(data.html);
        make_last_active();
      }
    }
  }
});
