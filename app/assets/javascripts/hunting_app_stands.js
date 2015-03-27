(function() {

  function StandsMapScript() {

    // internal constants
    var MapIcons = {
      HuntingLocationAvailable : {
        url: AssetPath.Image.HuntingLocationAvailable,
        size: new google.maps.Size(32,32),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(16, 16),
        scaledSize: new google.maps.Size(32,32)
        },
      HuntingLocationReserved : {
        url: AssetPath.Image.HuntingLocationReserved,
        size: new google.maps.Size(32,32),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(16, 16),
        scaledSize: new google.maps.Size(32,32)
        },
      HuntingLocationOccupied : {
        url: AssetPath.Image.HuntingLocationOccupied,
        size: new google.maps.Size(32,32),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(16, 16),
        scaledSize: new google.maps.Size(32,32)
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
    var _memberLocationMarkerOptions = {
      icon: MapIcons.Hunter
    };

    var _haveInitializedGeoLocation = false;

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
    }

    // public functions
    this.initPage = function(page) {
      $.getScript("/hunting_app/" + g_huntingPlotId + "/stands.js");
    }

    this.createMap = function() {

      // initialize geolocation if not already setup
      /*
      if (!_haveInitializedGeoLocation) {
        var longitudeField = $('#checkin-form').find('input[name="position_longitude"]');
        var latitudeField = $('#checkin-form').find('input[name="position_latitude"]');
        Scripts.Common.initGeoLocation(
          function(position) {
            longitudeField.val(position.coords.longitude);
            latitudeField.val(position.coords.latitude);
          }
        );
        _haveInitializedGeoLocation = true;
      }
      */

      var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");

      _map = PlotMapHelper.createMap(activePage.find('#stands-map-canvas').get(0), g_huntingPlotLocation);
      _mapHelper = new PlotMapHelper(_map);

      updateHuntingLocationStatus();

      _mapHelper.createLocationMarkers(_standLocations, { icon: getLocationIcon, clickHandler: showLocationPopup } );
      _mapHelper.createMemberMarkers(_memberLocations, _memberLocationMarkerOptions);
      showWindConditions();

      var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");
      $('#stands-map-options-panel ul li input', activePage).change(
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
      $('#huntingLocationPopupDialog', activePage).find('#checkin-submit-warn').click(
        function() {
          var dialog = $('#huntingLocationPopupDialog', activePage);
          $('#checkin-warning', activePage).show();
          Scripts.Common.hideJQMButton(dialog.find('#checkin-submit-warn'));
          Scripts.Common.showJQMButton(dialog.find('#checkin-submit'));
          dialog.popup("reposition", { positionTo: 'window' });
        }
      );
    }

    this.updateCheckinStatus = function(new_status, location_record) {
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
        }
        else {
          _memberLocations[existing_location_record_index] = location_record;
        }
      }
      else {
        if (existing_location_record_index >= 0) {
          _memberLocations.splice(existing_location_record_index, 1);
        }
      }
      updateHuntingLocationStatus();
    }

    function showLocationPopup(hunting_location) {
      $.getScript("/hunting_app/" + g_huntingPlotId + "/stand_checkin_dialog/" + hunting_location.id + ".js") ;
    }

    function getLocationIcon(hunting_location) {
      if (!isDefined(hunting_location.status)) {
        return MapIcons.HuntingLocationAvailable;
      }
      else {
        switch (hunting_location.status) {
          default:
          case HuntingLocationStatus.Available:
            return MapIcons.HuntingLocationAvailable;
          case HuntingLocationStatus.Occupied:
            return MapIcons.HuntingLocationOccupied;
          case HuntingLocationStatus.Reserved:
            return MapIcons.HuntingLocationReserved;
        }
      }
    }

    function showWindConditions() {
      var svgDoc = $('#stands-map-wind-indicator', $.mobile.pageContainer.pagecontainer("getActivePage")).find("#windIndicatorSvg");
      var windSpeedNode = svgDoc.find("#windSpeed");
      var windDirectionNode = svgDoc.find("#windDirection");
      windSpeedNode.text(_windForecast.wind_mph);
      windDirectionNode.attr("transform", "rotate(" + _windForecast.wind_degrees + " 25 25)");
      $('#map-wind-indicator').show();
      $('#wind-indicator-popup').html('Wind from the ' + _windForecast.wind_dir + ' at ' + _windForecast.wind_mph + ' mph');
    }
    function hideWindConditions() {
      $('#map-wind-indicator').hide();
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

    function updateHuntingLocationStatus() {
      $.each(
        _standLocations,
        function(index, hunting_location) {
          delete hunting_location.occupied_by_user;
          delete hunting_location.next_reservation;
          var memberInLocation = getMemberInLocation(hunting_location.id);
          if (memberInLocation != null) {
            setHuntingLocationStatus(hunting_location, HuntingLocationStatus.Occupied);
            hunting_location.occupied_by_user = memberInLocation;
            return;
          }
          else {
            var nextReservation = getNextReservationForLocation(hunting_location.id);
            if (nextReservation != null) {
              setHuntingLocationStatus(hunting_location, HuntingLocationStatus.Reserved);
              hunting_location.next_reservation = nextReservation;
              return;
            }
          }
          setHuntingLocationStatus(hunting_location, HuntingLocationStatus.Available);
        }
      );
      function setHuntingLocationStatus(hunting_location, newStatus) {
        var statusChanged = (!isDefined(hunting_location.status) || (hunting_location.status != newStatus));
        hunting_location.status = newStatus;
        if (statusChanged) {
          _mapHelper.updateLocation(hunting_location, { icon: getLocationIcon });
        }
      }
    }
    function getNextReservationForLocation(location_id) {
      var reservation = null;
      for (var i = 0; i < _standReservations.length; i++) {
        if (_standReservations[i].location_id == location_id) {
          if ((reservation == null) || (_standReservations[i].start_date_time < reservation.start_date_time)) {
            reservation = _standReservations[i];
          }
          return reservation;
        }
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
    function prepStandReservationJson(standReservation) {
      standReservation.start_date_time = new Date(standReservation.start_date_time);
      standReservation.end_date_time = new Date(standReservation.end_date_time);
    }
  }

  Scripts.Page.StandsMap = new StandsMapScript();

  // register the page initailizer
  //Scripts.Common.pageShow('stands_map', Scripts.Page.StandsMap.initPage);
  Scripts.Common.pageInitialize('stands_map', Scripts.Page.StandsMap.initPage);

})();
