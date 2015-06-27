Box.Application.addModule('cabinet', function(context) {
  'use strict';

  var module_el;

  function primary_med_name() {
    return $(module_el).find('.pill-container .active').find('.pill-name-text').text() ||
            $(module_el).find('.pill-container').first().find('.pill-name-text').text();
  }

  function get_information(name) {
    return $.ajax({
      url: '/information',
      method: 'POST',
      data: { primary_name: name },
      dataType: 'json'
    });
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
      dataType: 'html'
    });
  }

  function delete_medicine(name, primary_med_name) {
    return $.ajax({
      url: '/destroy/',
      method: 'DELETE',
      data: { medicine: name, primary_name: primary_med_name },
      success: function(primary_medicine_info) {
        context.broadcast('reload_data', primary_medicine_info);
        refresh_shelves().done(function(data) {
          $(module_el).html(data);
          activate_primary_med(primary_medicine_info);
          set_interaction_count(primary_medicine_info);
        });
      }
    });
  }

  function activate_primary_med(primary_medicine_info) {
    var primary = $(module_el).find('.pill-name-text').filter(function() {
      return $(this).text().toLowerCase() === primary_medicine_info.primary.toLowerCase();
    }).closest('.pill-container');

    if(!primary) { return; }
    make_primary(primary, primary_medicine_info);
    set_interaction_count(primary_medicine_info);
  }

  function set_interaction_count(primary_medicine_info) {
    if($.isEmptyObject(primary_medicine_info)) { return; }
    var all_interactions = primary_medicine_info.all_interactions;
    $(module_el).find('.pill-name-text').each(function() {
      var count = 0;
      if(all_interactions.hasOwnProperty($(this).text())) {
        count = Object.keys(all_interactions[$(this).text()]).length;
      }
      $(this).siblings('.num-pill-interactions').html(count + ' interaction(s)');
    });
  }

  function make_primary(elm, primary_medicine_info) {
    $(elm).removeClass('disabled interact').addClass('active');
    $(module_el).find('.pill-container').not($(elm)).removeClass('active interact').addClass('disabled').find('.num-pill-interactions').html('');
    $(module_el).find('.pill-container').filter(function() {
      return $.inArray($(this).find('.pill-name-text').text().trim(), Object.keys(primary_medicine_info.interactions)) >= 0;
    }).toggleClass('interact disabled');
  }

  function click_primary(elm) {
    var name = $(elm).find('.pill-name-text').text();
    get_information(name).done(function(primary_medicine_info) {
      context.broadcast('reload_data', primary_medicine_info);
      refresh_shelves().done(function(data) {
        $(module_el).html(data);
        activate_primary_med(primary_medicine_info);
      });
    });
  }

  return {
    messages: ['medicine_added', 'mobile_delete'],
    behaviors: [ 'navigation' ],

    init: function() {
      module_el = context.getElement();
      
      get_information('').done(function(primary_medicine_info) {

        if(!is_tablet_and_down()) {
          context.broadcast('reload_data', primary_medicine_info);
          
          refresh_shelves().done(function(data) {
            $(module_el).html(data);
            activate_primary_med(primary_medicine_info);
            set_interaction_count(primary_medicine_info);
          });
        } else {
          set_interaction_count(primary_medicine_info);
        }
      });
    
    },

    onmessage: function (name, medicine_name) {
      switch (name) {

        case 'medicine_added':
          add_to_cabinet(medicine_name).done(function(primary_medicine_info) {
            context.broadcast('reload_data', primary_medicine_info);
            refresh_shelves().done(function(data) {
              $(module_el).html(data);
              activate_primary_med(primary_medicine_info);
              set_interaction_count(primary_medicine_info);
            });
          });
          break;

        case 'mobile_delete':
          var deletes = $('.delete');
          var names = {};
          for (var i = 0; i < deletes.length; i++ ) {
            names[i] = $(deletes[i]).closest('.pill-container').find('.pill-name-text').text();
          }
          delete_medicine(names, primary_med_name());
          $('.mobile-footer').hide();
          break;
      }

    },

    onclick: function(event, element, elementType) {
      event.preventDefault();

      var $ev_target = $(event.target);

      if ($ev_target.hasClass('pill-delete')) {
        var name = $ev_target.closest('.pill-container').find('.pill-name-text').text();
        delete_medicine(name, primary_med_name());
      } else if (is_tablet_and_down()) {
        if($ev_target.is('img')) {
          $ev_target.toggleClass('delete');

          if($('.cabinet img.delete').length == 0) {
            $('.mobile-footer').slideUp();
            $('.footer').removeClass('active');
          } else {
            $('.mobile-footer').slideDown();
            $('.footer').addClass('active');
          }

        } else {
          toggle_loader(true);
          click_primary($ev_target.closest('.pill-container')[0]);
          context.broadcast('go_to', 1);
          $('.delete').removeClass('delete');
          $('.mobile-footer').hide();
        }
      } else if ($ev_target.closest('.pill-container')) {  
        toggle_loader(true);      
        click_primary($ev_target.closest('.pill-container')[0]);
      }
    }
  }
});
