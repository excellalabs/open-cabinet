Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var $component = $(context.getElement());

  var medicines = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: {
      ttl: 3600000, // cache requests for one hour
      url: '/autocomplete',
    }
  });

  function setup_autocomplete() {
    var $search_input = $component.find('#search_input');
    $search_input.typeahead({
      hint: true,
      highlight: true,
      minLength: 1
    }, {
      name: 'medicines',
      source: medicines
    });
  }

  function reset_typeahead() {
    $('#search_input').blur();
    $component.find('#search_input').val("");
    $("#add_medicine").show();
    $("#add_medicine_wait").hide();
  }

  $("#add_medicine").click(function() {
    var medicine = $component.find('#search_input').val();
    if(!medicine) return;
    reset_typeahead();
    context.broadcast('medicine_added', medicine);
  });

  return {

    init: function() {
      setup_autocomplete();
    },

    onkeydown: function(event, element, elementType){
      if (event.keyCode == 13) {
        var medicine = $(".tt-suggestion:first-child").text();
        if(!medicine) return;
        reset_typeahead();
        context.broadcast('medicine_added', medicine);
      }
    }
  }
});
