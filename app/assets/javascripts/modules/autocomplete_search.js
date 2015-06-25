Box.Application.addModule('autocomplete_search', function(context) {
  'use strict';
  var $component = $(context.getElement()),
      cabinet_db;

  var medicines = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: {
      url: '/autocomplete',
      ttl: 3600000, // cache requests for one hour
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
    }).bind('typeahead:selected', function(obj, medicine){
      cabinet_db.add(medicine);
      $search_input.val('');
    });
  }

  return {
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
    }
  }
});
