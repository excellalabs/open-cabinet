Box.Application.addModule('cabinet', function(context) {
  'use strict';

  var module_el;

  function add_to_cabinet(name) {
    return $.ajax({
      url: '/add_to_cabinet',
      method: 'POST',
      dataType: 'json',
      data: { medicine: name }
    });
  }

  function refresh_shelves() {
    return $.ajax({
      url: '/refresh_shelves',
      method: 'GET',
      dataType: 'html',
      success: function(data) {
        $(module_el).html(data);
      }
    });
  }

  function make_first_active(primary_medicine_info) {
    var elm = module_el.querySelector('.pill-name');
    if (elm) {
      activate($(elm).closest('.pill-container'), primary_medicine_info)
    }
  }

  function activate(element, primary_medicine_info) {
    var $element = $(element);
    var name = $element.find('.pill-name').text();
    $element.removeClass('disabled interact').addClass('active');
    $(module_el).find('.pill-container').not($element).removeClass('active interact').addClass('disabled');
    $(module_el).find('.pill-container').filter(function() {
      return $.inArray($(this).text().trim(), Object.keys(primary_medicine_info.interactions)) >= 0;
    }).toggleClass('interact disabled');
  }

  return {
    messages: ['medicine_added'],
    behaviors: [ 'navigation' ],

    init: function() {
      module_el = context.getElement();
      make_first_active();
    },

    onmessage: function (name, medicine_name) {
      add_to_cabinet(medicine_name).done(function(primary_medicine_info) {
        context.broadcast('reload_data', primary_medicine_info);
        refresh_shelves();
        make_first_active(primary_medicine_info);
      });
    },

    onclick: function(event, element, elementType) {
      /*
      event.preventDefault();
      if ($(event.target).hasClass('pill-delete')) {
        var $element = $(event.target);
        var name = $element.closest('.pill-container').find('.pill-name').text();
      }
      else if (elementType === 'pill-bottle') {
        activate(element);

        if (is_tablet_and_down()) {
          context.broadcast('go_to', 1);
        }
      }
      */
    }
  }
});
