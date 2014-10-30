(function() {

  function PlotMapScript() {

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

    var _map = null;
    var _mapHelper = null;
    var _standLocationMarkerOptions = {
      icon: getLocationIcon
    };
    var _memberLocationMarkerOptions = {
      icon: MapIcons.Hunter
    };

    // public functions
    this.initPage = function() {
      $.getScript("/hunting_app/" + g_huntingPlotId + "/map.js");
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
          item.date = new Date(item.date);
        }
      );
    }

    this.initalizeMap = function() {

      var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");

      _map = PlotMapHelper.createMap(activePage.find('#plot-map-canvas').get(0), g_huntingPlotLocation);
      _mapHelper = new PlotMapHelper(_map);

      //updateHuntingLocationStatus();

      _mapHelper.createLocationMarkers(_standLocations, { icon: getLocationIcon, clickHandler: showLocationPopup} );
      _mapHelper.createMemberMarkers(_memberLocations, _memberLocationMarkerOptions);
      showWindConditions();

      $('#plot-map-options-panel ul li input').change(
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

      activePage.find('#stand-reservation-date').change(
        function (event) {
          updateStandLocations();
          updateWindIndicator();
        }
      );

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
        for (var i = 0 ; i < _standReservations.length; i++) {
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
      var selectedDate = getSelectedDate();
      var dateParam = selectedDate.getFullYear() + "-" + (selectedDate.getMonth() + 1) + "-" + (selectedDate.getDate() + 1);
      $.getScript("/hunting_app/" + g_huntingPlotId + "/stand_reservation_dialog/" + hunting_location.id + ".js?reservation_date=" + encodeURI(dateParam));
    }

    function showWindConditions() {
      updateWindIndicator();
      $('#map-wind-indicator').show();
    }
    function hideWindConditions() {
      $('#map-wind-indicator').hide();
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
      var reserved = isReserved(hunting_location.id, date);
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

    function isReserved(location_id, date) {

      var dateRangeAM = { start: new Date(date.getFullYear(), date.getMonth(), date.getDate() + 1) };
      dateRangeAM.end = new Date(dateRangeAM.start);
      dateRangeAM.end.setHours(dateRangeAM.start.getHours() + 12);

      var dateRangePM = { start: dateRangeAM.end };
      dateRangePM.end = new Date(dateRangePM.start);
      dateRangePM.end.setHours(dateRangePM.start.getHours() + 12);

      var returnValue = { am: false, pm: false };
      for (var i = 0; i < _standReservations.length; i++) {
        if (_standReservations[i].location_id == location_id) {
          if (isInDateRange(_standReservations[i].start_date_time, dateRangeAM)) {
            returnValue.am = true;
          }
          else if (isInDateRange(_standReservations[i].end_date_time, dateRangeAM)) {
            returnValue.am = true;
          }
          if (isInDateRange(_standReservations[i].start_date_time, dateRangePM)) {
            returnValue.pm = true;
          }
          else if (isInDateRange(_standReservations[i].end_date_time, dateRangePM)) {
            returnValue.pm = true;
          }
        }
      }
      return returnValue;

      function isInDateRange(dateTime, range) {
        return (dateTime >= range.start  && dateTime < range.end);
      }
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
      return new Date($('#stand-reservation-date', $.mobile.pageContainer.pagecontainer("getActivePage")).val());
    }

  }

  Scripts.Page.PlotMap = new PlotMapScript();

  // register the page initializer
  Scripts.Common.pageInitialize('plot_map', Scripts.Page.PlotMap.initPage);

})();
