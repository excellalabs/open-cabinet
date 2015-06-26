Box.Application.addModule('footer', function(context) {
  'use strict';

  var module_el;

  return {

    init: function() {
      module_el = context.getElement();
    },

    onclick: function(event, element, elementType) {

      event.preventDefault();

      var $ev_target = $(event.target);

      if (is_tablet_and_down()) {
        if ($ev_target.hasClass('mobile-pill-delete')){
          context.broadcast('mobile_delete');
        }
      }
    }
  }
});
