Box.Application.addModule('cabinet', function(context) {
  'use strict';

  var module_el;

  function primary_med_name() {
    $(module_el).find('.pill-container .active').find('.pill-name').text();
  }

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

  function delete_medicine(name, primary_med_name) {
    return $.ajax({
      url: '/destroy/',
      method: 'DELETE',
      data: {medicine: name, primary_name: primary_med_name}
    });
  }

  function activate_primary_med(primary_medicine_info) {
    var primary;
    if(primary_medicine_info) {
      primary = $(module_el).find('.pill-name:contains(' + primary_medicine_info.primary + ')').closest('.pill-container');
    } else {
      primary = $(module_el).find('.pill-container:first');
    }
    if(primary.length) {
      make_primary(primary[0]);
    }
  }

  function make_primary(elm) {
    $(elm).removeClass('disabled interact').addClass('active');
    $(module_el).find('.pill-container').not($(elm)).removeClass('active interact').addClass('disabled');
  }
/*
  function activate(element, primary_medicine_info) {
    var $element = $(element);
    var name = $element.find('.pill-name').text();
    $element.removeClass('disabled interact').addClass('active');
    $(module_el).find('.pill-container').not($element).removeClass('active interact').addClass('disabled');
    $(module_el).find('.pill-container').filter(function() {
      return $.inArray($(this).text().trim(), Object.keys(primary_medicine_info.interactions)) >= 0;
    }).toggleClass('interact disabled');
  }
*/
  return {
    messages: ['medicine_added'],
    behaviors: [ 'navigation' ],

    init: function() {
      module_el = context.getElement();
      refresh_shelves();
      activate_primary_med();
    },

    onmessage: function (name, medicine_name) {
      add_to_cabinet(medicine_name).done(function(primary_medicine_info) {
        context.broadcast('reload_data', primary_medicine_info);
        refresh_shelves();
        activate_primary_med(primary_medicine_info);
      });
    },

    onclick: function(event, element, elementType) {
      event.preventDefault();
      var ev_target = $(event.target);
      if ($(ev_target).hasClass('pill-delete')) {
        var name = $(ev_target).closest('.pill-container').find('.pill-name').text();
        delete_medicine(name, primary_med_name());
      }
    }
  }
});
