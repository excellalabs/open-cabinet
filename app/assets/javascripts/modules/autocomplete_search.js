Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var $component = $(context.getElement()),
      cabinet_db;

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

  $("#add_medicine").click(function() {
    var medicine = $component.find('#search_input').val();
    $("#add_medicine").hide();
    $("#add_medicine_wait").show();
    cabinet_db.add(medicine);
    $component.find('#search_input').val("");
  });

  return {
    messages: ['medicine_added'],

    init: function() {
      this.setup_autocomplete_public();
      this.setup_storage();
    },

    setup_autocomplete_public: function() {
      setup_autocomplete();
    },

    setup_storage: function() {
      cabinet_db = context.getService('cabinet-db');
      cabinet_db.load(gon.meds);
    },

    onmessage: function(name ,data){
      switch(name) {
        case 'medicine_added':
          $("#add_medicine").show();
          $("#add_medicine_wait").hide();
          break;
      }
    }
  }
});
