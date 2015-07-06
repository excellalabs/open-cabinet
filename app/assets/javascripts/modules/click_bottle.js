Box.Application.addModule('click-bottle', function(context) {
  'use strict';

  var $context,
      cabinet_service;;

  return {
    init: function() {
      $context = $(context.getElement());
      cabinet_service = context.getService('cabinet-service');
    },
    destroy: function() {
      $context = null;
      cabinet_service = null;
    },
    onclick: function(event, element, elementType) {
      event.preventDefault();

      $('.tooltip').tipso('hide');

      var $target = $(event.target);
      var name = $(element).attr('pill-name-text');

      if($target.hasClass('pill-delete')) {
        $target.removeClass('fa-trash').addClass('fa-refresh fa-spin');
        $(element).addClass('deleting');
        cabinet_service.delete(name);
      } else if($(element).hasClass('clickable-pill-container')) {

        cabinet_service.update(name);

        if (is_tablet_and_down()) {
          context.broadcast('go_to', 1);        
        }  
      }
    }
  }
});
