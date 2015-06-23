Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var $component = $(context.getElement()),
      $search_input = null;

  var medicine_engine = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: {
      url: '/autocomplete',
      filter: function(response) {
        return $.map(response, function(medicine) {
          return { name: medicine.name, set_id: medicine.set_id };
        });
      }
    }
  });

  medicine_engine.initialize();
  
  function setup_autocomplete() {
   $search_input.typeahead({
      hint: true,
      highlight: true,
      minLength: 1
    },
    {
      name: 'medicines',
      source: medicine_engine.ttAdapter(),
      displayKey: 'name'
    }).bind('typeahead:selected', function(obj, medicine){
      var params = { name: medicine.name,
                     set_id: medicine.set_id };
      $.post('/add_to_cabinet', { medicine: params }).done(function() {
        location.reload(true);
      });
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
