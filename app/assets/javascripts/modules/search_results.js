Box.Application.addModule('search_results_component', function(context) {
  'use strict';

  var $component    = $(context.getElement()),
      $med_item     = $component.find('.medicine-item'),
      $results_list = $component.find('.results-list'),
      results       = null,
      last_result   = 0;

  function paginate() {
    $(window).scroll(function(){
      if ($(window).scrollTop() == $(document).height() - $(window).height()){
        if (results !== null) {
          display_results();
        }
      }
    });
  }

  function display_results() {
    if (results.length > last_result) {
      var slice_end = last_result + 10;
      var current_window = results.slice(last_result, slice_end);
      current_window.forEach(function(element, index) {
        var $result_item = $med_item.clone();
        $result_item.find('.medicine-brand-name').text(element.brand_name);
        $results_list.append($result_item.show());
      });
      last_result += 10;
    }
  } 

  return {

    init: function() {
      paginate();
    },

    messages: [ 'search_results' ],

    onmessage: function(event, data) {
      if (event === 'search_results') {
        results = data.results;
        display_results();
      }
    }
  }
});
