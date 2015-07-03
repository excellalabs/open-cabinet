Box.Application.addModule('navigation', function(context) {
  'use strict';
  var $component = $(context.getElement());
  var $owl;

  function createOwlNavigation() {
    $owl = $($component);
    $owl.owlCarousel({
      items: 2,
      autoHeight: true,
      navigation : false,
      slideSpeed: 800,
      mouseDrag: false,
      touchDrag: false,
      afterAction: scroll_to_top,
      itemsCustom : [
          [0, 1],
          [850, 2]
        ]
    });
  }

  function getCarousel() {
    return $owl.data('owlCarousel');
  }

  function readMoreReadLessClickHandler(elm) {
    $(elm).toggle();
    $(elm).siblings('.ellipsis-controller').toggle();
    $(elm).siblings('.ellipsis-paragraph').toggleClass('multiline-ellipsis');
  }

  function readMoreReadLessVisibility() {
    $component.find('.ellipsis-paragraph').each(function() {
      if($(this).height() < 115) return true;
      $(this).siblings('.read-more').show();
    });
  }

  function refresh_information(data) {
    $('<div>' + data + '</div>').find('.view-pane').each(function() {
      var id = $(this).attr('id');
      $('.owl-wrapper').find('#' + id).html($(this).html());
    });

    readMoreReadLessVisibility();
  }

  function navigate(go_to) {
    $owl.trigger('owl.goTo', go_to);
  }

  function scroll_to_top() {
    $('.owl-item').animate({ scrollTop: 0 }, 'slow');
  }

  function get_medicine_information() {
    return $.ajax({
      url: '/medicine_information',
      method: 'get',
      dataType: 'html',
    }).done(refresh_information);
  }

  function initialize_highlight(elm) {
    $('#interaction-data-container').show();
    $('#no-data-loaded-container').hide();

    var interaction_element = $(this).attr('data-interaction-name');
    var primary_element = $(this).attr('data-primary-name');

    if(is_mobile()) {
      $('.scroll-to-top').show();
    }

    $('ul#interactions-list li').removeClass('active');
    $(elm).addClass('active');

    var offset_height = 80;

    if(is_tablet_and_down()) {
      offset_height = $('ul#interactions-list').height();
    }
    
    if($('.scroll-to').length) {
      $('#interactions-info').parent().animate({
      scrollTop: ($('.scroll-to').position().top - offset_height)
     }, 'slow');
    }
  }

  return {
    messages: ['go_to', 'refresh_information'],
    behaviors: ['navigation'],

    init: function() {
     createOwlNavigation();
    },
    onclick: function (event, element, elementType) {
      var target_elm = $(event.target);
      if(target_elm.hasClass('ellipsis-controller')) {
        readMoreReadLessClickHandler(target_elm);  
      } else if (target_elm.parents('#interactions-list').length) {
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
