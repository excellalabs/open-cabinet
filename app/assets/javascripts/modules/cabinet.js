Box.Application.addModule('cabinet', function(context) {
  'use strict';

  var module_el;

  function get_information() {
    return $.ajax({
      url: '/information',
      method: 'get',
      dataType: 'json'
    });
  }

  function add_to_cabinet(name) {
    return $.ajax({
      url: '/add_to_cabinet',
      method: 'POST',
      dataType: 'html',
      data: { medicine: name }
    });
  }

  function set_primary(name) {
    return $.ajax({
      url: '/update_primary_medicine',
      method: 'post',
      dataType: 'html',
      data: { medicine: name }
    });
  }

  function destroy_medicine(name) {
    return $.ajax({
      url: '/destroy',
      method: 'DELETE',
      dataType: 'html',
      data: { medicine: name }
    });
  }

  function load_data(html) {
    $(module_el).html(html);
    context.broadcast('refresh_information', null);
    if(!is_tablet_and_down()) {
      $('.tooltip').tipso({
        background: '#12a3d2',
        border_color: '#0e7fa3'
      });
    }
  }

  function delete_medicine(name_data) {
    destroy_medicine(name_data).done(load_data);
  }

  function click_primary(elm) {
    var name = $(elm).attr('pill-name-text');
    set_primary(name).done(load_data);
  }

  function load_chart(primary_medicine_info) {

    if($('#canvas').length > 0) {
      var labels = [];
      var data = [];

      if(primary_medicine_info.all_interactions) {

        $.each(primary_medicine_info.all_interactions, function(idx, elm) {
          labels.push(idx);
          data.push(Object.keys(elm).length);
        });

        var radarChartData = {
          labels: labels,
          datasets: [
            {
              label: "Interactions",
              fillColor: "rgba(18,163,210,0.2)",
              strokeColor: "rgba(18,163,210,1)",
              pointColor: "rgba(18,163,210,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(151,187,205,1)",
              data: data
            }
          ]
        };

        window.myRadar = new Chart(document.getElementById("canvas").getContext("2d")).Radar(radarChartData, {
          responsive: true
        });
      }
    }

  }

  return {
    messages: ['medicine_added', 'mobile_delete'],
    behaviors: [ 'navigation' ],

    init: function() {
      module_el = context.getElement();
    },
    onmessage: function (name, medicine_name) {
      switch (name) {
        case 'medicine_added':
          add_to_cabinet(medicine_name).done(load_data);
          break;

        case 'mobile_delete':
          var deletes = $('.delete');
          var names = {};
          for (var i = 0; i < deletes.length; i++ ) {
            names[i] = $(deletes[i]).closest('.clickable-pill-container').attr('pill-name-text');
          }
          delete_medicine(names);
          $('.mobile-footer').hide();
          break;
      }

    },

    onclick: function(event, element, elementType) {
      event.preventDefault();

      var $ev_target = $(event.target);

      if ($ev_target.hasClass('pill-delete')) {
        var name = $ev_target.closest('.clickable-pill-container').attr('pill-name-text');
        delete_medicine(name);
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
          click_primary($ev_target.closest('.clickable-pill-container')[0]);
          context.broadcast('go_to', 1);
          $('.delete').removeClass('delete');
          $('.mobile-footer').hide();
        }
      } else if ($ev_target.closest('.clickable-pill-container')) {  
        toggle_loader(true);      
        click_primary($ev_target.closest('.clickable-pill-container')[0]);
      }
    }
  }
});
