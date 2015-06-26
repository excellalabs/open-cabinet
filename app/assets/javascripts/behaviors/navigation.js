Box.Application.addBehavior('navigation', function(context) {
  'use strict';
  
  return {
    onclick: function(event, element, elementType) {

      if(is_tablet_and_down()) {
        if($(event.target).hasClass('back-to-medicine-cabinet')) {
          context.broadcast('go_to', 0);
        }
        if($(event.target).hasClass('back-to-medicine-information')) {
          context.broadcast('go_to', 1);
        }
        if($(event.target).hasClass('back-to-interaction-pairs')) {
          context.broadcast('go_to', 2);
        }
        if($(event.target).parent().attr('id') == 'interactions') {
          context.broadcast('go_to', 3);
        }

      } else {
        if ($(event.target).hasClass('owl-navigation-cabinet')) {
          context.broadcast('go_to', 0);
        }
        if ($(event.target).hasClass('owl-navigation-information')) {
          context.broadcast('go_to', 1);
        }
        if ($(event.target).hasClass('owl-navigation-interaction')) {
          context.broadcast('go_to', 2);
        }        
      }
    }
  }
});
