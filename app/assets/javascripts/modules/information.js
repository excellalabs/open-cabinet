Box.Application.addModule('information', function(context) {
  'use strict';

  var $;

  var cabinet_db,
    module_el;

  function fill_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#unselected-content').remove();
    $module_el.find('.primary-name').text(med.name);
    $module_el.find('#interactions-count').text(Object.keys(med.interactions).length);

    if (Object.keys(med.interactions).length > 1) {
      $module_el.find('.plural').show();
      $module_el.find('.singular').hide();
    } else {
      $module_el.find('.singular').show();
      $module_el.find('.plural').hide();
    }

    $module_el.find('#indications-and-usage').text(med.indications_and_usage);
    $module_el.find('#dosage-and-administration').text(med.dosage_and_administration);
    $module_el.find('#warnings').text(med.warnings);
  }

  function clear_information(med) {
    var $module_el = $(module_el);
    $module_el.find('.primary-name').empty();
    $module_el.find('#interactions-count').text('0');
    $module_el.find('.plural').show();
    $module_el.find('.singular').hide();
    $module_el.find('#indications-and-usage').empty();
    $module_el.find('#dosage-and-administration').empty();
    $module_el.find('#warnings').empty();
    $module_el.find('#interactions-text').empty();

    $module_el.prepend(
      '<div class="row" id="unselected-content"> \
        <div class="col-span-10" id="interactions"> \
          <h1 class="primary-font green">ADD MEDICINES TO YOUR MEDICINE CABINET.</h1> \
          <p>Then compare your drugs to make sure there are no known interactions between them.</p> \
        </div> \
      </div>'
    )
  }

  return {
    messages: ['medicine_active', 'medicine_inactive', 'data_loaded'],

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
        case 'medicine_active':
          cabinet_db.get_information(data);
          break;

        case 'medicine_inactive':
          clear_information();
          break;

        case 'data_loaded':
          fill_information(cabinet_db.get(data));
          break;
      }


      if (name == 'refresh_shelves') {
        redraw_shelf(data.html);
        make_last_active();
      }
    },

    onclick: function(event, element, elementType) {
      if (elementType === 'interactions-warning') {
        owl.trigger('owl.goTo', 2);
      }
    }
  }
});
