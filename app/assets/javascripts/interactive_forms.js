var InteractiveForms = {};

(function() {

  var g_enablerFieldsMap = {};

  InteractiveForms.initializeFields = function(container) {
    var jqContainer = null;
    if (isDefinedAndNonNull(container)) {
      jqContainer = $(container);
    }
    else {
      jqContainer = $(document);
    }
    $(':input[data-enabled-by]', jqContainer).each(
      function(index, item) {
        var enablerId = $(item).data('enabled-by');
        var enablerValue = $(item).data('enabled-value');
        if (enablerId != '') {
          var fieldToEnable = item;
          var fieldsToEnable = g_enablerFieldsMap[enablerId];
          var mapEntry = { field: item, value: enablerValue };
          if (isDefinedAndNonNull(fieldsToEnable)) {
            fieldsToEnable.push(mapEntry);
          }
          else {
            g_enablerFieldsMap[enablerId] = [ mapEntry ];
          }
        }
      }
    );

    for(var enablerId in g_enablerFieldsMap) {
      var enablerField = $(':input[name="' + enablerId + '"]', jqContainer);
      switch (enablerField.prop('tagName').toLowerCase()) {
        case 'input': {
          switch (enablerField.prop('type').toLowerCase()) {
            case 'radio': {
              enablerField.change(
                function() {
                  enablerFieldChange(enablerId, $(this).val());
                  /*
                  var mapEntries = g_enablerFieldsMap[$(this).attr('name')];
                  for (var i = 0; i < mapEntries.length; i++) {
                    var mapEntry = mapEntries[i];
                    if ($(this).val() == mapEntry.value) {
                      enableField(mapEntry.field);
                    }
                    else {
                      disableField(mapEntry.field);
                    }
                  }
                  */
                }
              );
              var initialSelectedItem = $(':input[name="' + enablerId + '"]:checked');
              if (initialSelectedItem.length > 0) {
                enablerFieldChange(enablerId, initialSelectedItem.val());
              }
              else {
                enablerFieldChange(enablerId, null);
              }
            }
            case 'checkbox': {

            }
            default: {

            }
          }
        }
        case 'select': {
        }
        case 'textarea': {
        }
      }
    }
    initializeDatePickers(jqContainer);
  }

  function enablerFieldChange(fieldName, fieldValue) {
    var mapEntries = g_enablerFieldsMap[fieldName];
    for (var i = 0; i < mapEntries.length; i++) {
      var mapEntry = mapEntries[i];
      if (fieldValue == mapEntry.value) {
        enableField(mapEntry.field);
      }
      else {
        disableField(mapEntry.field);
      }
    }
  }

  function initializeDatePickers(container) {
    var mobileBrowser = isMobileBrowser();
    $('.date-picker-form-group', container).each(
      function(index, item) {
        var formGroup = $(item);
        if (mobileBrowser) {
          formGroup.find('input[type="text"]').hide();
        }
        else {
          var dateField = formGroup.find('input[type="date"]');
          dateField.hide();
          var datePickerField = formGroup.find('input[type="text"]');
          var datePickerOptions = { autoclose: true };
          var datePickerDateFormat = formGroup.data('date-format');
          if (isDefined(datePickerDateFormat)) {
            datePickerOptions.format = datePickerDateFormat;
          }
          datePickerField.datepicker(datePickerOptions);
          var initialDate = dateField.val();
          if ((initialDate != null) && (initialDate.length > 0)) {
            datePickerField.datepicker('setDate', parseDateLocal(initialDate));
          }
          datePickerField.on(
            'changeDate',
            function(event) {
              var dateVal = datePickerField.datepicker('getDate');
              dateField.val(dateVal.toISOString().substr(0,10));
            }
          );
          datePickerField.on(
            'clearDate',
            function(event) {
              dateField.val(null);
            }
          );
        }
      }
    );
  }

})();
