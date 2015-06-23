Box.Application.addModule('cabinet', function(context) {
  'use strict';
  var $context = $(context.getElement());

  function interaction_listener(bottle_div) {
    $(bottle_div).parents('.pill-container').toggleClass('active disabled');
    var $set_id = bottle_div.next('input').attr('id');
    $('.o-wrapper').addClass('is-active');
    $('.c-menu--push-right').addClass('is-active');

    $.ajax({
      url: '/interactions',
      method: 'POST',
      dataType: "json",
      data: {medicine_id: $set_id},
      success: function(data) {
        var text = '';
        if (data['interactions_text']) {
          text = highlight_keywords(data.interactions, data.interactions_text)
        } else {
          text = 'There is no interaction information for this medicine.'
        }
        $('#interactions > p').html(text);
      }
    });
  }

  function delete_medicine(delete_elm) {
    $.ajax({
      url: '/destroy/' + $(delete_elm).attr('data-set-id'),
      method: 'DELETE',
      success: function(data) {
        $context.html(data);
      }
    });
  }

  function highlight_keywords(keywords, text) {
    var html = ''
    $.each(keywords, function(key, values) {
      var reg = new RegExp(values.join('|'), 'gi');
      html = text.replace(reg, '<span class="' + key + '-highlight">$&</span>')
    });

    return html
  }

  return {
    messages: [ ],

    init: function() {
      
    },

    onclick: function(event, element, elementType) {
      event.preventDefault();
      if ($(event.target).hasClass('pill-delete')) {
        delete_medicine(event.target);
      }
      else if ($(event.target).parents('.pill-bottle').length > 0) {
        interaction_listener($(event.target).parents('.pill-bottle'));
      }
    }
  }
});
