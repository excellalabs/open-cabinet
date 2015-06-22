Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var $component = $(context.getElement()),
      $search_input = null;

  var medicines = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: '/autocomplete'
  });
  
  function setup_autocomplete() {
   $search_input.typeahead({
      hint: true,
      highlight: true,
      minLength: 1
    },
    {
      name: 'medicines',
      source: medicines
    });
  }

  return {
    messages: [ ],

    init: function() {
      $search_input = $component.find('#search_input');
      setup_autocomplete();
    },

    onclick: function(event, element, elementType) {
      if (elementType === 'search-medicine') {
        event.preventDefault();
        var params = { 'search_input': $search_input.val() };
        $.getJSON('/lookup', params).done(function(data) {
          context.broadcast('search_results', { results: data });
        });
      }
    }
  }
});
