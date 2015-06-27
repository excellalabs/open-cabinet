Box.Application.addModule('information', function(context) {
  'use strict';

  var module_el;

  function fill_information(med) {
    var $module_el = $(module_el);
    $module_el.find('#empty-message-row').html('');
    $module_el.find('#medicine-general-info').show();
    $module_el.find('#unselected-content').remove();
    $module_el.find('.read-more').remove();
    $module_el.find('.read-less').remove();
    $module_el.find('.primary-name').text(med.primary);
    var interaction_count = interactions_length(med);

    if (interaction_count >= 1) {
      display_medicine_wordage(interaction_count, med.primary);
      $module_el.find('#interactions-count-container').slideDown();
    } else {
      $module_el.find('#interactions-count-container').slideUp();
    }

    var html = '';
    html += build_section('Description', 'indications-and-usage', med.indications_and_usage);
    html += build_section('Dosage', 'dosage-and-administration', med.dosage_and_administration);
    html += build_section('Warnings', 'warnings', med.warnings);
    $('.medicine-details').html(html);

    read_more($module_el.find('#indications-and-usage'));
    read_more($module_el.find('#dosage-and-administration'));
    read_more($module_el.find('#warnings'));

    toggle_loader(false);
  }

  function build_section(name, id, text) {
    return '<section>' + 
           '<h3>' + name + '</h3>' +
           '<div>' +
           '  <p id="' + id + '" class="multiline-ellipsis">' + text_or_default(text) + '</p>' +
           '</div>' +
           '</section>';
  }

  function interactions_length(med) {
    if('interactions' in med && med.interactions) {
      return Object.keys(med.interactions).length
    } else {
      return 0;
    }
  }

  function text_or_default(text) {
    if (!text) {
      text = 'No information was found for this section on this medicine.';
    }
    return text;
  }

  function read_more(element) {
    $(module_el).append(element.clone().attr('id', 'delete-this').removeClass('multiline-ellipsis'));
    if ($('#delete-this').height() >= 120 ) {
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

  function display_medicine_wordage(count, name){
    var $module_el = $(module_el);

    var text = count + ' medication in your cabinet interact with ' + name + '.';
    
    if (count > 1){
      text = count + ' medications in your cabinet interact with ' + name + '.';
    } 

    $('#potential-interactions').text(text);
  }

  function clear_information() {
    var $module_el = $(module_el);
    $module_el.find('.primary-name').empty();
    $module_el.find('#medicine-general-info').hide();
    $module_el.find('#potential-interactions').empty();

    toggle_loader(false);

    $module_el.find('#empty-message-row').html(
      '<div class="row" id="unselected-content"> \
        <div class="col-span-12" id="interactions"> \
          <h1 class="primary-font green">ADD MEDICINES TO YOUR MEDICINE CABINET.</h1> \
          <p>Then compare your drugs to make sure there are no known interactions between them.</p> \
        </div> \
      </div>'
    )
  }

  return {
    messages: ['reload_data'],
    behaviors: [ 'navigation' ],

    init: function() {
      $ = context.getGlobal('jQuery');
      module_el = context.getElement();
      toggle_loader(true);
    },

    onmessage: function (name, data) {
      if (Object.keys(data).length) {
        fill_information(data);
      } else {
        clear_information();
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
