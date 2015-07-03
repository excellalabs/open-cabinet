Box.Application.addBehavior('navigation', function(context) {
  'use strict';
  
  return {
    onclick: function(event, element, elementType) {
    
      if(is_tablet()) {
        if($(event.target).hasClass('back-to-medicine-information') || $(event.target).is('img')) {
          context.broadcast('go_to', 1);
        }
        if($(event.target).hasClass('pill-bottle')) {
          context.broadcast('go_to', 1);
        }
      } 

      if(is_tablet_and_down()) {
        if($(event.target).hasClass('back-to-medicine-cabinet')) {
          $('.scroll-to-top').hide();
          context.broadcast('go_to', 0);
        }
        if($(event.target).hasClass('back-to-medicine-information') ) {
          $('.scroll-to-top').hide();
          context.broadcast('go_to', 1);
        }
        if($(event.target).hasClass('back-to-interaction-pairs')) {
          context.broadcast('go_to', 2);
        }
     
      } else {
        if ($(event.target).hasClass('owl-navigation-cabinet')) {
          context.broadcast('go_to', 0);
        }
        if ($(event.target).hasClass('owl-navigation-information')) {
          context.broadcast('go_to', 1);
        }
        if ($(event.target).hasClass('owl-navigation-interaction') || 
            $(event.target).parent('.owl-navigation-interaction').length > 0) {
          context.broadcast('go_to', 2);
        }        
      }
    }
  }
});
