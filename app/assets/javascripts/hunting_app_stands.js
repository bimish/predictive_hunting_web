Scripts.Page.StandsMap = function() {

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

  // public functions
  this.initPage = function() {

    // always set the content to full height ? need to test this
    Scripts.Common.setContentFullHeight();

    // initialize geolocation if not already setup
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

    if (_map == null) {

      _map = PlotMapHelper.createMap('stands-map-canvas', g_huntingPlotLocation);
      _mapHelper = new PlotMapHelper(_map);

      updateHuntingLocationStatus();

      _mapHelper.createLocationMarkers(g_standLocations, { icon: getLocationIcon, clickHandler: showLocationPopup } );
      _mapHelper.createMemberMarkers(g_memberLocations, _memberLocationMarkerOptions);
      showWindConditions();

      $('#map-options-panel ul li input').change(
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
  }

  this.updateCheckinStatus = function(new_status, location_record) {
    $('#huntingLocationPopupDialog').popup('close');
    var existing_location_record_index = -1;
    for (var i = 0; i < g_memberLocations.length; i++) {
      if (g_memberLocations[i].user_id = new_status.user_id) {
        existing_location_record_index = i;
        break;
      }
    }
    if (new_status.checked_in) {
      if (existing_location_record_index < 0) {
        g_memberLocations.push(location_record);
      }
      else {
        g_memberLocations[existing_location_record_index] = location_record;
      }
    }
    else {
      if (existing_location_record_index >= 0) {
        g_memberLocations.splice(existing_location_record_index, 1);
      }
    }
    updateHuntingLocationStatus();
  }

  function showLocationPopup(hunting_location) {
    var dialog = $('#huntingLocationPopupDialog');
    dialog.find('#location_name').text(hunting_location.name);
    dialog.find('#location_status').text(HuntingLocationStatus.getName(hunting_location.status));
    var checkInForm = $('#checkin-form');
    checkInForm.find('input[name="hunting_location_id"]').val(hunting_location.id);
    //checkInForm.find('input[name="position_longitude"]').val(hunting_location.location_id);
    //checkInForm.find('input[name="position_latitude"]').val(hunting_location.location_id);
    dialog.popup("open");
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
    var svgDoc = $("#windIndicatorSvg");
    var windSpeedNode = svgDoc.find("#windSpeed");
    var windDirectionNode = svgDoc.find("#windDirection");
    windSpeedNode.text(g_windForecast.wind_mph);
    windDirectionNode.attr("transform", "rotate(" + g_windForecast.wind_degrees + " 25 25)");
    $('#map-wind-indicator').show();
    $('#wind-indicator-popup').html('Wind from the ' + g_windForecast.wind_dir + ' at ' + g_windForecast.wind_mph + ' mph');
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
      g_standLocations,
      function(index, hunting_location) {
        var memberInLocation = getMemberInLocation(hunting_location.id);
        if (memberInLocation != null) {
          setHuntingLocationStatus(hunting_location, HuntingLocationStatus.Occupied);
          return;
        }
        else {
          var nextReservation = getNextReservationForLocation(hunting_location.id);
          if (nextReservation != null) {
            setHuntingLocationStatus(hunting_location, HuntingLocationStatus.Reserved);
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
    for (var i = 0; i < g_standReservations.length; i++) {
      if (g_standReservations[i].location_id == location_id) {
        if ((reservation == null) || (g_standReservations[i].start_date_time < reservation.start_date_time)) {
          reservation = g_standReservations[i];
        }
        return reservation;
      }
    }
  }
  function getMemberInLocation(location_id) {
    for (var i = 0; i < g_memberLocations.length; i++) {
      if (g_memberLocations[i].location_id == location_id) {
        return g_memberLocations[i];
      }
    }
    return null;
  }

  return this;
}();

// register the page initailizer
Scripts.Common.pageInit('stands_map', Scripts.Page.StandsMap.initPage);
