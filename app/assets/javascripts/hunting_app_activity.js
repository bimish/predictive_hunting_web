(function() {

  function AnimalActivityPageScript() {

    this.initPage = function(page) {

      Scripts.Common.initializeTabbedNavBar($('div[data-role="navbar"]', page));

      $('select[name="observation_date_time_offset"]', page).change(
        function (event) {
          var enableDateTimeFields = ($(this).val() == 'another');
          var dateTimeFieldsContainer = $('#observation-date-time-fields', page);
          if (enableDateTimeFields) {
            dateTimeFieldsContainer.show();
          }
          else {
            dateTimeFieldsContainer.hide();
          }
        }
      );

      $('select[name="animal_category_id"]', page).change(
        function (event) {
          var showNamedAnimals = ($(this).val() == 'named');
          var namedDeerFieldsContainer = $('#named-deer-fields', page);
          if (showNamedAnimals) {
            namedDeerFieldsContainer.show();
          }
          else {
            namedDeerFieldsContainer.hide();
          }
        }
      );

      $("#animal-activity-observation-record", page).submit(
        function(event) {
          var validationErrors = [];
          var formFields = $(this).find(':input').each(
            function(index, field) {
              var jqField = $(field);
              if (jqField.is(":visible") && (jqField.data('val-required') == true) && (jqField.val() == '')) {
                validationErrors.push('A value is required for ' + jqField.data('val-label'));
              }
            }
          );
          if (validationErrors.length > 0) {
            this.showValidationErrors(validationErrors);
            event.preventDefault();
            return false;
          }
        }
      );

      {
        var locationLatField = $('#animal-activity-observation-record', page).find('input[name="location_coordinates_lat"]');
        var locationLngField = $('#animal-activity-observation-record', page).find('input[name="location_coordinates_lng"]');
        Scripts.Common.initGeoLocation(
          function(position) {
            locationLatField.val(position.coords.latitude);
            locationLngField.val(position.coords.longitude);
          }
        );
      }
    }

    this.showValidationErrors = function(validationErrors) {
      var activePage = $("body").pagecontainer("getActivePage");
      var dialog = $('#validation-popup', activePage);
      var errorsList = dialog.find('ul');
      errorsList.empty();
      for (var i = 0; i < validationErrors.length; i++) {
        errorsList.append("<li>" + validationErrors[i] + "</li>");
      }
      dialog.popup("open");
    }

    this.resetForm = function() {
      var activePage = Scripts.Common.getActivePage();
      var form = $('#animal-activity-observation-record', activePage);
      form[0].reset();
      $('#observation-date-time-fields', activePage).hide();
      $('#named-deer-fields', activePage).hide();
    }

  }

  Scripts.Page.AnimalActivity = new AnimalActivityPageScript();

  // register the page initailizer
  Scripts.Common.pageInitialize('animal_activity', Scripts.Page.AnimalActivity.initPage);

})();
