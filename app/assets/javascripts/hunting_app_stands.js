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
  var _standLocationMarkerOptions = {
    clickHandler: function(stand_location) { $("#huntingLocationPopupDialog").popup("open"); },
    icon: getLocationIcon
  };
  var _memberLocationMarkerOptions = {
    icon: MapIcons.Hunter
  };

  // public functions
  this.initPage = function() {

    // always set the content to full height ? need to test this
    Scripts.Common.setContentFullHeight();

    if (_map == null) {

      _map = PlotMapHelper.createMap('stands-map-canvas', g_huntingPlotLocation);
      _mapHelper = new PlotMapHelper(_map);

      updateHuntingLocationStatus();

      _mapHelper.createLocationMarkers(g_standLocations, _standLocationMarkerOptions);
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
      if (isDefined(hunting_location.mapMarker) && (statusChanged)) {
        _mapHelper.updateLocation(hunting_location, _standLocationMarkerOptions);
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
