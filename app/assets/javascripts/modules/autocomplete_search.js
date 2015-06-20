Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  
  var medicines = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: '/autocomplete'
  });
  
  function setup_autocomplete() {
   $(context.getElement()).find('#search_input').typeahead({
      hint: true,
      highlight: true,
      minLength: 3
    },
    {
      name: 'medicines',
      source: medicines
    });
  }

  return {
    messages: [ ],

    init: function() {
      setup_autocomplete();
    }
  }
});
