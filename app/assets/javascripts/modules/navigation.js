Box.Application.addModule('navigation', function(context) {
  'use strict';
  var $component = $(context.getElement());
  var $owl,
      ajax_service;

  function createOwlNavigation() {
    $owl = $($component);
    $owl.owlCarousel({
      items: 2,
      autoHeight: true,
      navigation : false,
      slideSpeed: 800,
      mouseDrag: false,
      touchDrag: false,
      afterMove: pin_to_top,
      scrollPerPage: true,
      itemsCustom : [
          [0, 1],
          [850, 2]
        ]
    });
  }

  function getCarousel() {
    return $owl.data('owlCarousel');
  }

  function refresh_information(data) {
    $('<div>' + data + '</div>').find('.view-pane').each(function() {
      var id = $(this).attr('id');
      $('.owl-wrapper').find('#' + id).html($(this).html());
    });

    read_more();
    load_tooltips();
    $('#medicine_information .content').show();
    $('#medicine_information .loader').hide();
  }

  function navigate(go_to) {
    $owl.trigger('owl.goTo', go_to);
  }

  function pin_to_top() {
    var field = '.owl-item';
    if(is_mobile()) {
      field = 'html, body';
    }

    $(field).animate({ scrollTop: 0 }, 0);
  }

  function get_medicine_information() {
    return ajax_service.get('/medicine_information').done(refresh_information);
  }

  function initialize_highlight(elm) {
    $('#interaction-data-container').show();
    $('#no-data-loaded-container').hide();
    $('.interactions-container').hide();

    var interaction_element = $(elm).attr('data-interaction-name');
    var primary_element = $(elm).attr('data-primary-name');

    if(is_mobile()) {
      $('.scroll-to-top').show();
    }

    $('.' + class_name(interaction_element)).show();

    $('ul#interactions-list li').removeClass('active');
    $(elm).addClass('active');

    var scroll_elm = $('#interactions-info').closest('.owl-item');
    var top = $('.scroll-to:visible').first().position().top - 80;

    if(is_tablet_and_down()) {
      var offset_height = $('ul#interactions-list').height() + 140;
      top = $('.scroll-to:visible').first().offset().top - offset_height;
    }

    if(is_mobile()) {
      scroll_elm = $('html, body');
    }
    
    if($('.scroll-to').length) {
      scroll_elm.animate({
        scrollTop: top
     }, 'slow');
    }
  }

  return {
    messages: ['go_to', 'refresh_information'],
    behaviors: ['navigation'],

    init: function() {
      ajax_service = context.getService('ajax-service');
      createOwlNavigation();
      readMoreReadLessVisibility();
    },
    onclick: function (event, element, elementType) {
      var target_elm = $(event.target);
      if (target_elm.parents('#interactions-list').length) {
        initialize_highlight(target_elm);
      }
    },
    onmessage: function (name, data) {
      switch(name) {
        case 'go_to':
          navigate(data);
          break;
        case 'refresh_information':
          get_medicine_information();
          break;
      }
    }
  }
});
