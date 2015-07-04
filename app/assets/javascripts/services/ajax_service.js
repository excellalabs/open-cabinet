Box.Application.addService('ajax-service', function(application) {

  function ajax_call(path, method, data) {
    return $.ajax({
      url: path,
      method: method,
      dataType: 'html',
      data: data
    });
  }

  return {
    post: function (path, data) {
      return ajax_call(path, 'POST', data);  
    },     
    get: function (path, data) {
      return ajax_call(path, 'get', data);  
    },     
    delete: function (path, data) {
      return ajax_call(path, 'DELETE', data);  
    }    
  };
});