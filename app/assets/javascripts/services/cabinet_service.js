Box.Application.addService('cabinet-service', function(context) {

  function refresh_shelves(html) {
    $('#shelves').html(html);
    context.broadcast('refresh_information', null);   
    hide_loader(); 
  }

  function show_loader() {
    $('#medicine_information .content').hide();
    $('#medicine_information .fa-refresh').show();    
  }

  function hide_loader() {
    $('#medicine_information .content').show();
    $('#medicine_information .fa-refresh').hide();    
  }

  function load_data(name, action, url) {
    show_loader();
    ajax_service = context.getService('ajax-service');
    window['ajax_service'][action](url, { medicine: name }).done(refresh_shelves); 
  }

  return {
    refresh:  function (html) {
      refresh_shelves(html);
    },
    add: function(name) {
      load_data(name, 'post', '/add_to_cabinet');
    },
    delete: function(name) {
      load_data(name, 'delete', '/destroy');
    },
    update: function(name) {
      load_data(name, 'post', '/update_primary_medicine');
    } 
  };
});