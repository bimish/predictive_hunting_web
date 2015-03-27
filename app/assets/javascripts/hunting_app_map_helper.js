function PlotMapHelper(map) {

  var _map = map;
  var _memberLocationMarkers = [];
  var _plotLocationMarkers = [];
  var plotMembersMarkerTag = 'plot-members';
  var plotLocationsMarkerTag = 'hunting-locations';

  this.createMemberMarkers = function(memberLocations, options) {
    $.each(
      memberLocations,
      function(index, memberLocation) {
       addMemberImpl(memberLocation, options);
      }
    );
  }
  this.updateMember = function(memberLocation, options) {
    var memberMarkerIndex = getMemberMarkerIndex(memberLocation.user_id);
    if (memberMarkerIndex >= 0) {
      var memberMarker = _memberLocationMarkers[memberMarkerIndex].marker;
      memberMarker.setInfoWindow(getMemberLocationInfoWindowContent(memberLocation));
      memberMarker.setLocation(memberLocation.location_coordinates);
    }
  }
  this.removeMember = function(userId) {
    var memberMarkerIndex = getMemberMarkerIndex(userId);
    if (memberMarkerIndex >= 0) {
      _memberLocationMarkers[memberMarkerIndex].marker.remove();
      _memberLocationMarkers.splice(memberMarkerIndex, 1);
    }
  }
  this.addMember = addMemberImpl;
  function addMemberImpl(memberLocation, options) {
    var marker =
      _map.addMarker(
        {
          title: memberLocation.user_name,
          coordinates: memberLocation.location_coordinates,
          icon: options.icon,
          zIndex: 3,
          visible: (isDefined(options.showMarker) ? options.showMarker : true),
          infoWindowContent: getMemberLocationInfoWindowContent(memberLocation)
        },
        plotMembersMarkerTag
      );
    _memberLocationMarkers.push( { user_id: memberLocation.user_id, marker: marker} );
  }
  function getMemberMarkerIndex(userId) {
    for (var i = 0 ; i < _memberLocationMarkers.length; i++) {
      if (_memberLocationMarkers[i].user_id == userId) {
        return i;
      }
    }
    return -1;
  }
  this.showMembers = function() {
    $.each(_memberLocationMarkers, function(index, item) { item.marker.show(); });
  }
  this.hideMembers = function() {
    $.each(_memberLocationMarkers, function(index, item) { item.marker.hide(); });
  }
  this.createLocationMarkers = function(standLocations, options) {
    if (_plotLocationMarkers != null) {
      $.each(
        _plotLocationMarkers,
        function(index, item) {
          item.marker.remove();
        }
      );
    }
    _plotLocationMarkers = [];
    $.each(
      standLocations,
      function(index, hunting_location) {
        var mapMarker = _map.addMarker(
          {
            title: hunting_location.name,
            coordinates: hunting_location.coordinates,
            visible: (isDefined(options.showMarker) ? options.showMarker : true),
            zIndex: 2
          },
          plotLocationsMarkerTag
        );
        initializeStandMarker(mapMarker, hunting_location, options);
        _plotLocationMarkers.push( { location_id: hunting_location.id, marker: mapMarker } );
      }
    );
  }
  this.updateLocation = function(standLocation, options) {
    var mapMarker = null;
    for (var i = 0; i < _plotLocationMarkers.length; i++) {
      if (_plotLocationMarkers[i].location_id == standLocation.id) {
        mapMarker = _plotLocationMarkers[i].marker;
        break;
      }
    }
    if (mapMarker != null) {
      initializeStandMarker(mapMarker, standLocation, options);
    }
  }
  this.showLocations = function() {
    $.each(_plotLocationMarkers, function(index, item) { item.marker.show(); });
  }
  this.hideLocations = function() {
    $.each(_plotLocationMarkers, function(index, item) { item.marker.hide(); });
  }
  function initializeStandMarker(marker, standLocation, options) {
    if (isDefined(options.icon)) {
      if (typeof options.icon == 'function') {
        marker.setIcon(options.icon(standLocation));
      }
      else {
        marker.setIcon(options.icon);
      }
    }
    if (isDefinedAndNonNull(options.clickHandler)) {
      var clickHandler = options.clickHandler;
      marker.click(
        function() {
          clickHandler(standLocation);
        }
      );
    }
    else if (isDefinedAndNonNull(options.infoWindowHandler)) {
      marker.setInfoWindow(options.infoWindowHandler(standLocation));
    }
  }
  function getMemberLocationInfoWindowContent(memberLocation) {
    return '<div class="map-info-window"><p>' + escapeHtml(memberLocation.user_name) + '</p><p>' + escapeHtml(memberLocation.location_name) + '</p></div>';
  }
}

PlotMapHelper.createMap = function(mapCanvas, options) {
  var mapOptions = {
    showCenterMarker: false,
    mapTypeControl: false,
    streetViewControl: false,
    borderFillColor: '#cccccc',
    center: options.center,
    view_window: options.view_window,
    boundary: options.boundary,
    zoom: 12,
    mapType: MapsHelper.MapTypes.Satellite
  };
  try {
    return new MapsHelper(mapCanvas, mapOptions);
  }
  catch (e) {
    alert("The following error occurred in PlotMapHelper.createMap: " + e);
  }
}
