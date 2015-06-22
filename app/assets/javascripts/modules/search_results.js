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
        $result_item.find('.add-to-cabinet').attr('data-set-id', element.set_id);
        $result_item.find('.add-to-cabinet').attr('data-active-ingredient', element.active_ingredient);
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
    },

    onclick: function(event, element, elementType) {
      if (elementType === 'add-medicine') {
        event.preventDefault();
        var params = { name: $(element).closest('.medicine-item').find('.medicine-brand-name').text(),
                       set_id: $(element).attr('data-set-id'),
                       active_ingredient: $(element).attr('data-active-ingredient') };
        $.post('/add_to_cabinet', { medicine: params }).done(function(data) {
          window.location.href = '/cabinet';
        });
      }
    }
  }
});
