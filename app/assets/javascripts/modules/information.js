Box.Application.addModule('information', function(context) {
  'use strict';

  var $;

  var cabinet_db,
    module_el;

  function fill_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#unselected-content').remove();
    $module_el.find('.read-more').remove();
    $module_el.find('.read-less').remove();
    $module_el.find('.primary-name').text(med.name);
    var interaction_count = cabinet_db.interactions_length(med.name);
    $module_el.find('#interactions-count').text(interaction_count);

    if (interaction_count >= 1) {
      display_medicine_wordage(interaction_count);
      $module_el.find('#interactions-count-container').slideDown();
    } else {
      $module_el.find('#interactions-count-container').slideUp();
    }

    $module_el.find('#indications-and-usage').text(med.indications_and_usage);
    read_more($module_el.find('#indications-and-usage'));
    $module_el.find('#dosage-and-administration').text(med.dosage_and_administration);
    read_more($module_el.find('#dosage-and-administration'));
    $module_el.find('#warnings').text(med.warnings);
    read_more($module_el.find('#warnings'));

    $('#medicine_interactions .content').show();
    $('#medicine_interactions .fa-refresh').hide();
  }

  function read_more(element) {
    $(module_el).append(element.clone().attr('id', 'delete-this'));
    if ($('#delete-this').height() > 130 ) {
      element.after("<a class='read-more'>Read More</a><a class='read-less' style='display: none;'>Read Less</a>")
    }
    $('#delete-this').remove();
  }

  function toggle_ellipsis(element) {
    if (element.hasClass('read-more')) {
      element.siblings('p').removeClass('multiline-ellipsis');
      element.siblings('.read-less').show();
    } else {
      element.siblings('p').addClass('multiline-ellipsis');
      element.siblings('.read-more').show();
    }
    element.hide(); 
  }

  function display_medicine_wordage(count){
    var $module_el = $(module_el);
    if (count > 1){
      $module_el.find('.plural').show();
      $module_el.find('.singular').hide();
    } else {
      $module_el.find('.plural').hide();
      $module_el.find('.singular').show();
    }
  }

  function clear_information() {
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
    messages: ['medicine_active', 'medicine_inactive', 'data_loaded', 'medicine_deleted'],
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
        case 'medicine_active':
          $('#medicine_interactions .content').hide();
          $('#medicine_interactions .fa-refresh').show();
          cabinet_db.get_information(data);
          break;

        case 'data_loaded':
          fill_information(cabinet_db.get(data));

          break;

        case 'medicine_deleted':
          if(cabinet_db.getList().length < 1){
            clear_information();
          }
      }

      if (name == 'refresh_shelves') {
        redraw_shelf(data.html);
        make_last_active();
      }
    },

    onclick: function(event, element, elementType) {
      if (elementType === 'interactions-warning') {
        context.broadcast('go_to', 2);
      } else if (event.target.className == 'read-more' || event.target.className == 'read-less') {
        toggle_ellipsis($(event.target));
      }
    }
  }
});
