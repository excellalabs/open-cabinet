Box.Application.addModule('scroll-to-top', function(context) {
  'use strict';

  var module_el;

  return {

    init: function() {
      module_el = context.getElement();
    },

    onclick: function(event, element, elementType) {

      event.preventDefault();

      var $ev_target = $(event.target);

      if (is_mobile()) {
        $('html, body').animate({ scrollTop: 0 }, 'slow');
      }
    }
  }
});
