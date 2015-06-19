Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var drugs = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/search'
    }
  });
  
  function create_autocomplete() {
    $(context.getElement()).find('#search_input').typeahead({
      hint: true,
      highlight: true,
      minLength: 3
    },
    {
      name: 'drugs',
      source: drugs
    });
  }

  return {
    messages: [ ],

    init: function() {
      create_autocomplete();
    }
  }
});
