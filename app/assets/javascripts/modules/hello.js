Box.Application.addModule('hello', function(context) {
  'use strict';
    return {
    messages: [ ],

    init: function() {
      $(context.getElement()).html('Hello from T3');
    }
  }
});
