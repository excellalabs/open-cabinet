Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var $component = $(context.getElement());

  function load_medicines() {
    var medicines = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      prefetch: {
        ttl: 3600000, // cache requests for one hour
        url: '/autocomplete',
      }
    });

    return medicines;
  }

  function setup_autocomplete() {
    var $search_input = $component.find('#search_input');
    $search_input.typeahead({
      hint: true,
      highlight: true,
      minLength: 1
    }, {
      name: 'medicines',
      source: load_medicines()
    });
  }

  function reset_typeahead() {
    $('#search_input').blur();
    $component.find('#search_input').val("");
    $("#add_medicine").show();
    $("#add_medicine_wait").hide();
  }

  function reset_typeahead_animation(){
    $('#search_input').blur();
    $component.find('#search_input').val("");
    $("#add_medicine").hide();
    $("#add_medicine_wait").show();
  }

  function submit_typeahead(medicine){
    if(!medicine) return;
    reset_typeahead_animation();
    context.broadcast('medicine_added', medicine);
  }

  $("#add_medicine").click(function() {
    var medicine = $component.find('#search_input').val();
    submit_typeahead(medicine);
  });

  return {

    messages: ['reload_data'],

    init: function() {
      setup_autocomplete();
    },

    onmessage: function(name){
      $("#add_medicine").show();
      $("#add_medicine_wait").hide();
    },

    onkeydown: function(event, element, elementType){

      if (event.keyCode == 13) {
        var array = $.grep($(".tt-suggestion"), function(suggestion) {
            return $(suggestion).text() == $(".tt-input").val();
        });

        if (array.length) {
          var medicine = array[0].innerText;
        } else {
          var medicine = $(".tt-suggestion:first-child").text();
        }

        submit_typeahead(medicine);
      }
    }
  }
});
