Box.Application.addBehavior('navigation', function(context) {
  'use strict';
  
  return {
    onclick: function(event, element, elementType) {
      if ($(event.target).parent().parent().hasClass('owl-navigation-cabinet') || 
          $(event.target).hasClass('owl-navigation-cabinet')) {
        context.broadcast('go_to', 0);
      }
      if ($(event.target).parent().parent().hasClass('owl-navigation-information')) {
        context.broadcast('go_to', 1);
      }
      if ($(event.target).parent().parent().hasClass('owl-navigation-interaction')) {
        context.broadcast('go_to', 2);
      }
    }
  }
});
