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
      itemsCustom : [
          [0, 1],
          [850, 2]
        ]
    });
  }

  function navigate(go_to) {
    $owl.trigger('owl.goTo', go_to);
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
