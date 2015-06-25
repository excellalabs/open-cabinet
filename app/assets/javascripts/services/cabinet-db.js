/**
 * @fileoverview A todo object manager with built-in functionality
 * @author Box
 */

/**
 * Medication Object
 * @typedef {Object} Medication
 * @property {string} name A unique identifier
 * @property {string} title A label for the todo
 * @property {boolean} completed Is the task complete?
 */

/*
 * A todo object manager with built-in functionality
 */
Box.Application.addService('cabinet-db', function(application) {

  'use strict';

  //--------------------------------------------------------------------------
  // Private
  //--------------------------------------------------------------------------
  /** @type {Object} */
  var meds = {};
  var loaded = false;

  function ajax_information(name) {
    return $.ajax({
      url: '/information',
      method: 'POST',
      dataType: "json",
      data: {medicine_id: meds[name].set_id},
      beforeSend: function() {
        meds[name].information_ajax = true;
        meds[name].retrieved_info = false;
      }
    });
  }

  function add_to_cabinet(name) {
    return $.ajax({
      url: '/add_to_cabinet',
      method: 'POST',
      dataType: 'json',
      data: { medicine: name },
      beforeSend: function(){
        application.broadcast('add_ajax_initiated');
      },
      error: function() {
        application.broadcast('invalid_medicine');
      }
    });
  }

  function ajax_refresh_shelves() {

  }

  function delete_medicine(name) {
    return $.ajax({
      url: '/destroy/',
      method: 'DELETE',
      data: {medicine: name}
    });
  }

  function text_or_default(text) {
    if (!text) {
      text = 'No information was found for this section on this medicine.';
    }
    return text;
  }


  //--------------------------------------------------------------------------
  // Public
  //--------------------------------------------------------------------------

  return {

    get: function(name) {
      if (!meds[name]) { return null; }

      if (!('interactions' in meds[name])) {
        $.ajax({
          url: '/information',
          method: 'POST',
          dataType: "json",
          async: false,
          data: {medicine_id: meds[name].set_id},
          beforeSend: function() {
            meds[name].information_ajax = true;
            meds[name].retrieved_info = false;
          },
          success: function(data) {
            meds[data.primary].indications_and_usage = text_or_default(data.indications_and_usage);
            meds[data.primary].dosage_and_administration = text_or_default(data.dosage_and_administration);
            meds[data.primary].warnings = text_or_default(data.warnings);
            meds[data.primary].interactions = data.interactions;
            meds[data.primary].interactions_text = data.interactions_text;
            meds[data.primary].retrieved_info = true;
            meds[data.primary].information_ajax = false;
          }
        });
      }

      return meds[name] || null;
    },

    getList: function() {
      var medsList = [];

      Object.keys(meds).forEach(function(name) {
        medsList.push(meds[name]);
      });

      return medsList;
    },

    interactions_length: function(med_name) {
      if('interactions' in meds[med_name] && meds[med_name].interactions) {
        return Object.keys(meds[med_name].interactions).length
      } else {
        return 0;
      }
    },

    add: function(name) {
      if (!(name in meds)) {
        add_to_cabinet(name).then(function(med) {
          meds[med.name] = {
            name: med.name,
            set_id: med.set_id
          };

          ajax_information(name).done(function(data) {
            meds[data.primary].indications_and_usage = text_or_default(data.indications_and_usage);
            meds[data.primary].dosage_and_administration = text_or_default(data.dosage_and_administration);
            meds[data.primary].warnings = text_or_default(data.warnings);
            meds[data.primary].interactions_text = text_or_default(meds.interactions_text);
            meds[data.primary].interactions = meds.interactions;
            meds[data.primary].retrieved_info = true
            meds[data.primary].information_ajax = false;
            application.broadcast('medicine_added', data.primary)
          });
        });
      }
    },

    load: function(meds_array, force) {
      force = typeof force !== 'undefined' ?  force : false;

      if (loaded && !force) { return }
      for (var i = 0; i < meds_array.length; i++) {
        if (meds_array[i].name in meds) { continue; }
        meds[meds_array[i].name] = {
          name: meds_array[i].name,
          set_id: meds_array[i].set_id,
        };
      }
    },

    get_information: function(name) {
      ajax_information(name).done(function(data) {
        meds[data.primary].indications_and_usage = text_or_default(data.indications_and_usage);
        meds[data.primary].dosage_and_administration = text_or_default(data.dosage_and_administration);
        meds[data.primary].warnings = text_or_default(data.warnings);
        meds[data.primary].interactions = data.interactions;
        meds[data.primary].interactions_text = data.interactions_text;
        meds[data.primary].retrieved_info = true;
        meds[data.primary].information_ajax = false;
        application.broadcast('data_loaded', data.primary);
      });
    },

    refresh_shelves: function() {
      return $.ajax({
        url: '/refresh_shelves',
        method: 'POST',
        dataType: 'html'
      });
    },

    remove: function(name) {
      if (meds[name]) {
        delete_medicine(name).done(function() {
          delete meds[name];
          application.broadcast('medicine_deleted')
        });
      }
    }
  };

});
