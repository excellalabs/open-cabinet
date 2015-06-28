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

  function navigate(go_to) {
    $owl.trigger('owl.goTo', go_to);
  }

  function scroll_to_top() {
    $('.owl-item').animate({ scrollTop: 0 }, 'slow');
  }

  return {
    messages: ['go_to'],

    init: function() {
     createOwlNavigation();
    },
    onmessage: function (name, data) {
      navigate(data);
    }
  }
});
