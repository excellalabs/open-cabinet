Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var $component = $(context.getElement());
  var medicines,
      cabinet_service;

  function load_medicines() {
    medicines = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      identify: function(obj) { return obj.toUpperCase(); },
      prefetch: {
        ttl: 3600000, // cache requests for one hour
        url: '/autocomplete'
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

  function value_in_autocomplete(medicine) {
    return medicines.get(medicine.toUpperCase()).length > 0;
  }

  function submit_typeahead(){
    var array = $.grep($(".tt-suggestion"), function(suggestion) {
      return $(suggestion).text() == $(".tt-input").val();
    });

    if (array.length) {
      var medicine = $(array[0]).text();
    } else {
      var medicine = $(".tt-suggestion:first-child").text();
    }

    if(medicine.length == 0) {
      medicine = $('#search_input').val();
    }

    if(!medicine) return;
    if(!value_in_autocomplete(medicine)) {
      $('#error-message-container').show().html("<div class='error-message'>Could not find results for '" + medicine + "', please try again.</div>");
      return;
    }

    $('#error-message-container').hide();
    reset_typeahead_animation();

    if($('div[pill-name-text="' + medicine + '"]').length == 0) {
      cabinet_service.add(medicine);
    } else {
      cabinet_service.update(medicine);
    }
  }

  $("#add_medicine").click(function() {
    submit_typeahead();
  });

  return {

    messages: ['refresh_information'],

    init: function() {
      setup_autocomplete();
      cabinet_service = context.getService('cabinet-service');
    },

    onmessage: function(name){
      $("#add_medicine").show();
      $("#add_medicine_wait").hide();
    },

    onkeydown: function(event, element, elementType){

      if (event.keyCode == 13) {
        submit_typeahead();
      }
    }
  }
});
