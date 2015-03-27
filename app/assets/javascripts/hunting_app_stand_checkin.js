(function() {

  function StandCheckinScript() {

    // internal constants
    var MapIcons = {
      HuntingLocation : {
        url: AssetPath.Image.HuntingLocation,
        size: new google.maps.Size(16, 16),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(16, 16),
        scaledSize: new google.maps.Size(16 , 16)
        },
      Hunter : {
        url: AssetPath.Image.Hunter,
        size: new google.maps.Size(24,24),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(12, 12),
        scaledSize: new google.maps.Size(24,24)
      }
    };

    var _standDialog = null;
    var _standCheckinDialog = null;
    var _standReservationDialog = null;
    var _map = null;
    var _mapHelper = null;
    var _resizeMap = false;
    var _navBar = null;
    var _standLocationMarkerOptions = {
      icon: getLocationIcon
    };
    var _memberLocationMarkerOptions = {
      icon: MapIcons.Hunter
    };

    // public functions
    this.initPage = function(page) {
      _navBar = $('div[data-role="header"] div[data-role="navbar"]', page);
      Scripts.Common.initializeTabbedNavBar(_navBar, { includeFooter: true, onChange: onTabChange } );
      initStandDialog(page);
      _standCheckinDialog = initDialog(page, 'stand-checkin-dialog');
      _standReservationDialog = initDialog(page, 'stand-reservation-dialog');
      _flashMessageDialog = initDialog(page, 'stand-checkin-flash');
      page.find('#stand-reservation-date').change(
        function (event) {
          $('#reservation-date-display', Scripts.Common.getActivePage()).text($(this).find('option:selected').text());
          updateStandLocations();
          updateWindIndicator();
        }
      );
      initStatusUpdateForm(page);
      $(window).resize(function() { _resizeMap = true; } );
      $.getScript("/hunting_app/" + g_huntingPlotId + "/stand_checkin.js");

      {
        var locationLatField = $('#checkin-form', page).find('input[name="position_latitude"]');
        var locationLngField = $('#checkin-form', page).find('input[name="position_longitude"]');
        Scripts.Common.initGeoLocation(
          function(position) {
            locationLatField.val(position.coords.latitude);
            locationLngField.val(position.coords.longitude);
          }
        );
      }

      $('#detect-location', page).click(
        function (eventObject) {
          if (!navigator.geolocation) {
            Scripts.Common.Dialogs.alert('Location detection is not available');
          }
          else {
            //google.maps.geometry.poly.containsLocation(e.latLng, g_huntingPlotLocation.boundary)
            var successHandler = function(position) {
              var nearestLocation = findNearestStandLocation( { lat: position.coords.latitude, lng: position.coords.longitude} );
              // distance is in meters, if more than 5 away ask the user to confirm
              var locationConfirmed = (nearestLocation.distance < 5);
              if (locationConfirmed) {
                setLocation();
              }
              else {
                var distanceInFeet = Math.round(nearestLocation.distance * 3.3);
                Scripts.Common.Dialogs.confirm(
                  'The neareast location appears to be ' + nearestLocation.location.name + ', which is approximately ' + distanceInFeet + ' feet away. Is this correct?',
                  function(confirmed) {
                    if (confirmed) {
                      setLocation();
                    }
                  }
                );
              }
              function setLocation() {
                var locationIdField = $('#checkin-form', Scripts.Common.getActivePage()).find('#hunting_location_id');
                locationIdField.val(nearestLocation.location.id).selectmenu('refresh');
              }
            };
            var errorHandler = function(positionError) {
              var message = null;
              switch (positionError.code) {
                case positionError.PERMISSION_DENIED:
                  message = "This function will not work unless you allow the application to track your location";
                  break;
                case positionError.POSITION_UNAVAILABLE:
                  message = "Location information is unavailable";
                  break;
                case positionError.TIMEOUT:
                  message = "The request to get user location timed out";
                  break;
                case positionError.UNKNOWN_ERROR:
                  message = "An unexpected error occurred - " + positionError.message;
                  break;
              }
              Scripts.Common.Dialogs.alert(message);
            };
            var options = { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 };
            navigator.geolocation.getCurrentPosition(successHandler, errorHandler, options);
          }
        }
      );
      $('#check-in-with-detect', page).click(
        function(eventObject) {
          // initialize the check-in form and switch to that tab
          //var checkinForm = $('#checkin-form')
          //checkinForm.find('input[name="is_at_plot"]').prop('checked', true).checkboxradio('refresh').trigger('change');
          $('#header div.ui-navbar a[data-target="checkin_status"]').trigger('click');
        }
      );
      // any button with this id should do a check-out
      $('#check-out-submit', page).click(
        function() {
          doCheckOut()
        }
      );

    }

    function updateCheckinButton() {

    }

    this.showPage = function() {
      if ((_map != null) && (_resizeMap)) {
        _map.resize();
        _resizeMap = false;
      }
    }

    var _memberLocations = null;
    this.setMemberLocations = function(memberLocations) {
      _memberLocations = memberLocations;
    }

    var _standLocations = null;
    this.setStandLocations = function(standLocations) {
      _standLocations = standLocations;
    }

    var _standReservations = null;
    this.setStandReservations = function(standReservations) {
      _standReservations = standReservations;
      $.each(
        _standReservations,
        function(index, item) {
          prepStandReservationJson(item);
        }
      );
    }

    var _windForecast = null;
    this.setWindForecast = function(windForecast) {
      _windForecast = windForecast;
      $.each(
        _windForecast,
        function(index, item) {
          item.date = parseDateLocal(item.date);
        }
      );
    }

    function doCheckOut() {
      $('#checkout-form').submit();
    }

    function initStatusUpdateForm(page) {
      var checkinForm = $('#checkin-form', page);
      /*
      enableForm(checkinForm.find('#is-at-plot').is(':checked'));
      checkinForm.find('#is-at-plot').change(
        function() {
          enableForm($(this).is(':checked'));
          checkinForm.find('#checkin-submit').button('enable');
        }
      );
      checkinForm.find('#hunting_location_id').change(
        function() {
          checkinForm.find('#checkin-submit').button('enable');
        }
      );
      checkinForm.find('#expires_at').change(
        function() {
          checkinForm.find('#checkin-submit').button('enable');
        }
      );
      */
      checkinForm.submit(
        function() {
          $.mobile.loading(
            "show",
            {
              text: "Updating...",
              textVisible: true,
              theme: "z",
              html: ""
            }
          );
        }
      );
      function enableForm(enabled) {
        var command = (enabled) ? 'enable' : 'disable';
        checkinForm.find('#hunting_location_id').selectmenu(command);
        checkinForm.find('#expires_at').selectmenu(command);
        if (enabled)
          checkinForm.find('#detect-location').removeClass('ui-disabled');
        else
          checkinForm.find('#detect-location').addClass('ui-disabled');
      }

       // setup geolocation tracking
       /*
       if (navigator.geolocation) {
         g_geolocationWatchId = navigator.geolocation.watchPosition(
           function(position) {
             $('#checkin-form input[name="position_latitude"]').val(position.coords.latitude);
             $('#checkin-form input[name="position_longitude"]').val(position.coords.longitude);
           },
           function(error) {
             alert('Unable to retrieve current location.  Please allow this application to access current location for accurate information');
           }
         );
       }
       */
    }

    function initStandDialog(page) {
      _standDialog = $('#stand-dialog', page);
      _standDialog.popup(
        {
          tolerance: "0,0",
          positionTo: "window",
          beforeposition: function () {
            $(this).css( { maxWidth: $(window).innerWidth() - 40 } );
          }
        }
      );
      _standDialog.find('a[href="#checkin"]').click(
        function (event) {
          loadCheckinDialog(_standDialog.data('location_id'));
        }
      );
      _standDialog.find('a[href="#reserve"]').click(
        function (event) {
          $.getScript("/hunting_app/" + g_huntingPlotId + "/stand_reservation_dialog/" + _standDialog.data('location_id') + ".js") ;
        }
      );
    }

    function initDialog(page, dialogId) {
      var dialog = $('#' + dialogId, page);
      dialog.popup(
        {
          tolerance: "0,0",
          positionTo: "window",
          beforeposition: function () {
            $(this).css(
              {
                maxWidth: $(window).innerWidth() - 40,
                minWidth: 240
              }
            );
          }
        }
      );
      return dialog;
    }

    function onTabChange(tabId) {
      if (tabId == 'stand_checkin_map' && _resizeMap) {
        _map.resize();
        _resizeMap = false;
      }
    }

    function loadCheckinDialog(location_id, coordinates) {
      var url = "/hunting_app/" + g_huntingPlotId + "/stand_checkin_dialog";
      if (isDefinedAndNonNull(location_id)) {
        url += ('/' + location_id);
      }
      url += '.js'
      if (isDefinedAndNonNull(coordinates)) {
        url += '?' + encodeURIComponent('coordinates[lat]') + '=' + encodeURIComponent(coordinates.lat) + '&' + encodeURIComponent('coordinates[lng]') + '=' + encodeURIComponent(coordinates.lng);
      }
      $.getScript(url) ;
    }

    this.showCheckinDialog = function(html) {
      _standCheckinDialog.find('div.popup-content').html(html);
      _standCheckinDialog.trigger("create");
      var checkInForm = _standCheckinDialog.find('#checkin-form');
      //checkInForm.find('input[name="position_longitude"]').val(hunting_location.id);
      //checkInForm.find('input[name="position_latitude"]').val(hunting_location.id);
      var checkinWarning = _standCheckinDialog.find('#checkin-warning');
      if (checkinWarning.length > 0) {
        checkinWarning.find('#warning-dismiss').click(
          function() {
            $('#checkin-warning', _standCheckinDialog).hide();
            $('#checkin-form', _standCheckinDialog).show();
            _standCheckinDialog.popup("reposition", { positionTo: 'window' });
          }
        );
        checkinWarning.find('#warning-cancel').click(
          function() {
            _standCheckinDialog.popup("close");
          }
        );
        $('#checkin-form', _standCheckinDialog).hide();
      }
      _standCheckinDialog.popup("open");
    }
    this.closeCheckinDialog = function() {
      _standCheckinDialog.popup("close");
    }

    this.showReservationDialog = function(html, existingReservations) {
      // convert dat/time text to datetime objects
      $.each(
        existingReservations,
        function(index, item) {
          prepStandReservationJson(item);
        }
      );

      _standReservationDialog.find('div.popup-content').html(html);
      _standReservationDialog.trigger("create");
      var locationId = parseInt(_standReservationDialog.find('#hunting_location_id').val());
      _standReservationDialog.find('#reservation_date').change(
        function (eventObject) {
          var selectedDate = parseDateLocal($(this).val());
          var reserved = isReserved(existingReservations, locationId, selectedDate);
          var am_selected = false;
          var am_disabled = false;
          var pm_selected = false;
          var pm_disabled = false;
          if (reserved.am) {
            if (reserved.am_reservation.created_by_id == g_userId)
              am_selected = true;
            else
              am_disabled= true;
          }
          if (reserved.pm) {
            if (reserved.pm_reservation.created_by_id == g_userId)
              pm_selected = true;
            else
              pm_disabled= true;
          }
          var selectedValue = '';
          if (am_selected && pm_selected) {
            selectedValue = 'time_period_all_day';
          }
          else if (am_selected) {
            selectedValue = 'time_period_am';
          }
          else if (pm_selected) {
            selectedValue = 'time_period_pm';
          }

          // set the selected value for the date
          var timePeriodSelect = _standReservationDialog.find("#time_period");
          timePeriodSelect.val(selectedValue);

          // enabled/disable options as necessary
          timePeriodSelect.find("option[value='time_period_am']").attr("disabled", am_disabled);
          timePeriodSelect.find("option[value='time_period_pm']").attr("disabled", pm_disabled);
          timePeriodSelect.find("option[value='time_period_all_day']").attr("disabled", (am_disabled || pm_disabled));

          // refresh the select menu
          timePeriodSelect.selectmenu('refresh', true);
        }
      );
      /*
      var checkInForm = dialog.find('#checkin-form');
      var checkinWarning = dialog.find('#checkin-submit-warn');
      if (checkinWarning.length > 0) {
        dialog.find('#checkin-submit-warn').click(
          function() {
            var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");
            var dialog = $('#huntingLocationPopupDialog', activePage);
            $('#checkin-warning', activePage).hide();
            $('#checkin-form', activePage).show();
            dialog.popup("reposition", { positionTo: 'window' });
          }
        );
        $('#checkin-form', activePage).hide();
      }
      */
      _standReservationDialog.popup("open");
    }
    this.closeReservationDialog = function() {
      _standReservationDialog.popup('close');
    }
    this.flashSuccessMessage = function(message) {
      _flashMessageDialog.find('p.success-message').text(message);
      _flashMessageDialog.find('p.success-message').show();
      _flashMessageDialog.find('p.warning-message').hide();
      _flashMessageDialog.popup('open');
      //window.setTimeout(function() { _flashMessageDialog.fadeOut(1000); }, 2000);
    }
    this.flashWarningMessage = function(message) {
      _flashMessageDialog.find('p.warning-message').text(message);
      _flashMessageDialog.find('p.warning-message').show();
      _flashMessageDialog.find('p.success-message').hide();
      _flashMessageDialog.popup('open');
      //window.setTimeout(function() { _flashMessageDialog.fadeOut(1000); }, 2000);
    }

    this.initalizeMap = function() {

      var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");

      var mapCanvas = activePage.find('#plot-map-canvas');
      _map = PlotMapHelper.createMap(mapCanvas.get(0), g_huntingPlotLocation);
      _mapHelper = new PlotMapHelper(_map);

      _mapHelper.createLocationMarkers(_standLocations, { icon: getLocationIcon, clickHandler: showLocationPopup} );
      _mapHelper.createMemberMarkers(_memberLocations, _memberLocationMarkerOptions);

      // show and position the wind indicator
      showWindConditions();
      var mapRightEdge = $(document).width() - (mapCanvas.offset().left + mapCanvas.width());
      var mapTopEdge = mapCanvas.offset().top;
      var windIndicator = $('#plot-map-wind-indicator', activePage);
      windIndicator.css( { top: mapTopEdge + 5, right: mapRightEdge + 5 } );

      $('#stand-checkin-options-panel #map-options input').change(
        function(event) {
          var isChecked = $(this).is(':checked');
          switch ($(this).attr('name')) {
            case 'satellite-checkbox':
            {
              _map.setMapType( isChecked ? MapsHelper.MapTypes.Satellite : MapsHelper.MapTypes.Roadmap );
              break;
            }
            case 'members-checkbox':
            {
              if (isChecked) {
                _mapHelper.showMembers();
              }
              else {
                _mapHelper.hideMembers();
              }
              break;
            }
            case 'stands-checkbox':
            {
              if (isChecked) {
                _mapHelper.showLocations();
              }
              else {
                _mapHelper.hideLocations();
              }
              break;
            }
            case 'wind-forecast-checkbox':
            {
              if (isChecked) {
                showWindConditions();
              }
              else {
                hideWindConditions();
              }
              break;
            }
          }
        }
      );
    }

    this.updateCheckinStatus = function(new_status, location_record, from_dialog, updated_at) {

      var activePage = Scripts.Common.getActivePage();

      // if the checkin was done from the map dialog, update the checkin status tab
      var checkinForm = $('#checkin-form', activePage);
      if (from_dialog) {
        this.closeCheckinDialog();
        checkinForm.find('input[name="is_at_plot"]').attr('checked', ( (new_status.checked_in) ? 'true' : 'false') ).checkboxradio("refresh");
        var locationIdVal = '';
        if (new_status.checked_in) {
          locationIdVal = (location_record.location_id == '') ? '0' : location_record.location_id;
        }
        checkinForm.find('select[name="hunting_location_id"]').val(locationIdVal).selectmenu("refresh");
        var expires_at = location_record.expires_at.substring(location_record.expires_at.length - 8);
        checkinForm.find('select[name="expires_at"]').val(expires_at).selectmenu("refresh");
      }
      else {
        $.mobile.loading("hide");
      }

      //checkinForm.find("#checkin-submit").button("disable");
      $("p.check-in-msg", activePage).text("Successfully updated at " + updated_at);

      var existing_location_record_index = -1;
      for (var i = 0; i < _memberLocations.length; i++) {
        if (_memberLocations[i].user_id = new_status.user_id) {
          existing_location_record_index = i;
          break;
        }
      }
      if (new_status.checked_in) {
        if (existing_location_record_index < 0) {
          _memberLocations.push(location_record);
          _mapHelper.addMember(location_record, _memberLocationMarkerOptions);
        }
        else {
          _memberLocations[existing_location_record_index] = location_record;
          _mapHelper.updateMember(location_record, _memberLocationMarkerOptions);
        }
      }
      else {
        if (existing_location_record_index >= 0) {
          _memberLocations.splice(existing_location_record_index, 1);
          _mapHelper.removeMember(new_status.user_id);
        }
      }
    }

    this.updateStandReservation = function(actionTaken, standReservation) {
      var affectedLocationId = null;
      if (standReservation != null) {
        prepStandReservationJson(standReservation);
      }
      switch (actionTaken.action) {
        case 'update':
        {
          var itemIndex = getReservationIndex(actionTaken.reservation_id);
          if (itemIndex >= 0) {
            _standReservations[itemIndex] = standReservation;
            affectedLocationId = standReservation.location_id;
          }
          break;
        }
        case 'create':
        {
          _standReservations.push(standReservation);
          affectedLocationId = standReservation.location_id;
          break;
        }
        case 'delete':
        {
          var itemIndex = getReservationIndex(actionTaken.reservation_id);
          if (itemIndex >= 0) {
            affectedLocationId = _standReservations[itemIndex].location_id
            _standReservations.splice(itemIndex, 1);
          }
          break;
        }
      }
      if (affectedLocationId != null) {
        updateStandLocation(affectedLocationId);
      }
      function getReservationIndex(reservation_id) {
        for (var i = 0; i < _standReservations.length; i++) {
          if (_standReservations[i].id == reservation_id) {
            return i;
          }
        }
        return -1;
      }
    }

    function prepStandReservationJson(standReservation) {
      standReservation.start_date_time = new Date(standReservation.start_date_time);
      standReservation.end_date_time = new Date(standReservation.end_date_time);
    }

    function showLocationPopup(hunting_location) {
      _standDialog.find('#stand-name').text(hunting_location.name);

      var status = 'Available';

      var occupied = isOccupied(hunting_location.id);
      var reserved = isReserved(_standReservations, hunting_location.id, new Date());
      if (occupied.occupied) {
        status = 'Occupied by ' + escapeHtml(occupied.user_name);
      }
      else if (reserved.am && reserved.pm) {
        status = 'Reserved all day';
      }
      else if (reserved.am) {
        status = 'Reserved for AM';
      }
      else if (reserved.pm) {
        status = 'Reserved for PM';
      }

      _standDialog.find('#stand-status').text(status);
      _standDialog.data('location_id', hunting_location.id);
      _standDialog.popup("open");
    }

    function showWindConditions() {
      updateWindIndicator();
      $('#plot-map-wind-indicator', Scripts.Common.getActivePage()).show();
    }
    function hideWindConditions() {
      $('#plot-map-wind-indicator', Scripts.Common.getActivePage()).hide();
    }
    function updateWindIndicator() {
      var windForecast = { wind_mph: '?', wind_degrees: 0, wind_dir: 'N/A' };
      var selectedDate = getSelectedDate();
      for (var i = 0; i < _windForecast.length; i++) {
        if (_windForecast[i].date.getTime() == selectedDate.getTime()) {
          windForecast = _windForecast[i];
        }
      }
      var svgDoc = $('#plot-map-wind-indicator', $.mobile.pageContainer.pagecontainer("getActivePage")).find("#windIndicatorSvg");
      var windSpeedNode = svgDoc.find("#windSpeed");
      var windDirectionNode = svgDoc.find("#windDirection");
      windSpeedNode.text(windForecast.wind_mph);
      windDirectionNode.attr("transform", "rotate(" + windForecast.wind_degrees + " 25 25)");
      $('#wind-indicator-popup').html('Wind from the ' + windForecast.wind_dir + ' at ' + windForecast.wind_mph + ' mph');
    }

    function getLocationInfoWindowContent(hunting_location) {
      var statusDescription = null;
      var statusDetails = null;
      switch (hunting_location.status) {
        case HuntingLocationStatus.Available:
          statusDescription = 'Available';
          break;
        case HuntingLocationStatus.Occupied:
          statusDescription = 'Occupied';
          var memberInLocation = getMemberInLocation(hunting_location.id)
          statusDetails = [ 'By: ' + memberInLocation.user_name ];
          break;
        case HuntingLocationStatus.Reserved:
          statusDescription = 'Reserved';
          var nextReservation = getNextReservationForLocation(hunting_location.id);
          statusDetails = [ 'At: ' + nextReservation.start_date_time.toLocaleTimeString(), 'By: ' + nextReservation.created_by ];
          break;
      }
      var infoWindowHtml =
        '<div class="map-info-window">' +
        '<p>' + escapeHtml(hunting_location.name) + '</p>' +
        '<p>Status: ' + statusDescription + '</p>';
      if (statusDetails != null) {
        for (var i = 0; i < statusDetails.length; i++)
          infoWindowHtml += ('<p>' + escapeHtml(statusDetails[i]) + '</p>');
      }
      infoWindowHtml += '</div>';
      return infoWindowHtml;
    }

    function getLocationIcon(hunting_location) {
      var imagePath = AssetPath.Image.StandReservedNone;
      var date = getSelectedDate();
      var reserved = isReserved(_standReservations, hunting_location.id, date);
      if (reserved.am && reserved.pm) {
        imagePath = AssetPath.Image.StandReservedAllDay;
      }
      else if (reserved.am) {
        imagePath = AssetPath.Image.StandReservedAM;
      }
      else if (reserved.pm) {
        imagePath = AssetPath.Image.StandReservedPM;
      }
      return {
        url: imagePath,
        size: new google.maps.Size(24,24),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(12, 12),
        scaledSize: new google.maps.Size(24,24)
      };
    }

    function updateStandLocations() {
      $.each(
        _standLocations,
        function(index, stand_location) {
          _mapHelper.updateLocation(stand_location, _standLocationMarkerOptions);
        }
      );
    }

    function updateStandLocation(locationId) {
      var standLocation = null;
      for (var i = 0; i < _standLocations.length; i++) {
        if (_standLocations[i].id == locationId) {
          standLocation = _standLocations[i];
          break;
        }
      }
      if (standLocation != null) {
        _mapHelper.updateLocation(standLocation, _standLocationMarkerOptions);
      }
    }

    function isReserved(reservations, location_id, date) {

      var dateRangeAM = { start: new Date(date.getFullYear(), date.getMonth(), date.getDate()) };
      dateRangeAM.end = new Date(dateRangeAM.start);
      dateRangeAM.end.setHours(dateRangeAM.start.getHours() + 12);

      var dateRangePM = { start: dateRangeAM.end };
      dateRangePM.end = new Date(dateRangePM.start);
      dateRangePM.end.setHours(dateRangePM.start.getHours() + 12);

      var returnValue = { am: false, pm: false };
      for (var i = 0; i < reservations.length; i++) {
        if (reservations[i].location_id == location_id) {
          if (
            (isInDateRange(reservations[i].start_date_time, dateRangeAM))
            ||
            (isInDateRange(reservations[i].end_date_time, dateRangeAM))
          ) {
            returnValue.am = true;
            returnValue.am_reservation = reservations[i];
          }
          if (
            (isInDateRange(reservations[i].start_date_time, dateRangePM))
            ||
            (isInDateRange(reservations[i].end_date_time, dateRangePM))
          ) {
            returnValue.pm = true;
            returnValue.pm_reservation = reservations[i];
          }
        }
      }
      return returnValue;

      function isInDateRange(dateTime, range) {
        return (dateTime >= range.start  && dateTime < range.end);
      }
    }

    function isOccupied(location_id) {
      var isOccupied = { occupied: false };
      $.each(
        _memberLocations,
        function(index, memberLocation) {
          if (memberLocation.location_id == location_id) {
            isOccupied = { occupied: true, user_name: memberLocation.user_name };
          }
        }
      );
      return isOccupied;
    }

    function getMemberInLocation(location_id) {
      for (var i = 0; i < _memberLocations.length; i++) {
        if (_memberLocations[i].location_id == location_id) {
          return _memberLocations[i];
        }
      }
      return null;
    }
    function getSelectedDate() {
      return parseDateLocal($('#stand-reservation-date', $.mobile.pageContainer.pagecontainer("getActivePage")).val());
    }

    function findNearestStandLocation(position) {
      if ((_standLocations == null) || (_standLocations.length == 0)) {
        return null;
      }
      var result = { location: _standLocations[0], distance: MapsHelper.getDistanceBetween(position, _standLocations[0].coordinates) };
      for (var i = 1; i < _standLocations.length; i++) {
        var distance = MapsHelper.getDistanceBetween(position, _standLocations[i].coordinates);
        if (distance < result.distance) {
          result.distance = distance;
          result.location = _standLocations[i];
        }
      }
      return result;
    }

  }

  Scripts.Page.StandCheckin = new StandCheckinScript();

  // register the page initializer
  Scripts.Common.pageShow('stand_checkin', Scripts.Page.StandCheckin.showPage);
  Scripts.Common.pageInitialize('stand_checkin', Scripts.Page.StandCheckin.initPage);

})();
