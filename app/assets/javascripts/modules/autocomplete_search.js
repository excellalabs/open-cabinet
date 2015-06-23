Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var $component = $(context.getElement()),
      $search_input = null,
      cabinet_db,
      module_el;

  var medicines = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: {
      url: '/autocomplete',
      ttl: 3600000, // cache requests for one hour
    }
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
    }).bind('typeahead:selected', function(obj, medicine){
      cabinet_db.add(medicine);
      $search_input.val('');
    });
  }

  return {
    messages: [ ],

    init: function() {
      $search_input = $component.find('#search_input');
      setup_autocomplete();
      cabinet_db = context.getService('cabinet-db');
      cabinet_db.load(gon.meds);
      module_el = context.getElement();
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
