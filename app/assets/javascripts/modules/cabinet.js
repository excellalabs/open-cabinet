Box.Application.addModule('cabinet', function(context) {
  'use strict';

  var cabinet_db,
    module_el,
    imgs = [];

  function redraw_shelf(html_data) {
    $(module_el).empty().append(html_data);
  }

  function highlight_keywords(meds, text) {
    var html = ''
    $.each(meds, function(key, med) {
      var reg = new RegExp(med.keywords.join('|'), 'gi');
      html = text.replace(reg, '<span class="' + key + ' highlight">$&</span>')
    });

    return html
  }

  function make_first_active() {
    var elm = module_el.querySelector('.pill-name');
    if (elm) {
      $(elm).closest('.pill-container').toggleClass('active');
      context.broadcast('medicine_active', elm.textContent);
    }
  }

  return {
    messages: ['medicine_added', 'data_loaded', 'medicine_deleted'],
    behaviors: [ 'navigation' ],

    init: function() {
      cabinet_db = context.getService('cabinet-db');
      cabinet_db.load(gon.meds);
      module_el = context.getElement();
      imgs = gon.images;
      make_first_active();
    },

    destroy: function() {
      cabinet_db = null;
      module_el = null;
      imgs = null;
    },

    onmessage: function (name, data) {
      switch(name) {
        case 'medicine_added':
        case 'medicine_deleted':
          cabinet_db.refresh_shelves().done(function(html){
            redraw_shelf(html);
            make_first_active();
          });
          break;
      }
    },

    onclick: function(event, element, elementType) {
      event.preventDefault();
      if ($(event.target).hasClass('pill-delete')) {
        var $element = $(event.target);
        var name = $element.closest('.pill-container').find('.pill-name').text();
        cabinet_db.remove(name);
      }
      else if (elementType === 'pill-bottle') {
        var $element = $(element);
        $element.toggleClass('active');
        $(module_el).find('.pill-container').not($element).removeClass('active')
        var name = $element.find('.pill-name').text();
        if ($element.hasClass('active')) {
          context.broadcast('medicine_active', name);
          context.broadcast('go_to', 1);
        }
      }
    }
  }
});
