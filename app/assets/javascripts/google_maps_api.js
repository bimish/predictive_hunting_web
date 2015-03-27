function MapsHelper(mapCanvas, options)
{
  if (!isDefinedAndNonNull(mapCanvas)) throw "mapCanvas is required";

  var _mapOptions;
  var _mode;
  var _map;
  var _marker;
  var _boundary;
  var _additionalMarkers;
  var _drawingManager;
  var _markerAddress;
  var _dragEventHandler;
  var _markerDragEventListener;

  initOptions(options);

  createMap(mapCanvas);

  this.setLocationByAddress = function(address) { findAddressImpl(address, true) };
  this.setMarkerLocation = function(latitude, longitude) { setMarkerLocationImpl(new google.maps.LatLng(latitude, longitude)); };
  this.getMarkerLocation = function() { return getMarkerLocationImpl(); };
  this.getMarkerAddress = function() { return getMarkerAddressImpl(); };
  this.setCenter = function(latitude, longitude) { setCenterImpl(new google.maps.LatLng(latitude, longitude)); };
  this.getDrawingManager = function(options) { return createDrawingManagerImpl(options); };
  this.createBoundary = function(options, resultsHandler) { return drawBoundaryImpl(true); };
  this.editBoundary = function(options, resultsHandler) { return drawBoundaryImpl(false); };
  this.setBoundary = function(options) { return setBoundary(options); };
  this.hideMarker = function() { hideMarkerImpl(); };
  this.showMarker = function() { showMarkerImpl(); };
  this.setMode = function(mode) { setModeImpl(mode); };
  this.getMode = function() { return getModeImpl(); };
  this.getBoundaryVertices = function() { return getBoundaryVerticesImpl(); };
  this.setMapType = function(mapType) { setMapTypeImpl(mapType); }
  this.clearMarkers = function(tag) { clearMarkersImpl(tag); }
  this.addMarker = function(marker, tag) { return addMarkerImpl(marker, tag); }
  this.setDragEventHandler = function(handler) { setDragEventHandlerImpl(handler); }
  this.resize = function() { google.maps.event.trigger(_map,'resize'); }
  this.click = function(handler) { clickImpl(handler); }
  this.rightClick = function(handler) { rightClickImpl(handler); }
  this.latLngToDocumentPosition = function(latLng) { return latLngToDocumentPositionImpl(latLng); }
  this.getMap = function() { return getMapImpl(); }

  function initOptions(options) {
    // default to center of US
    _mapOptions = {
      center: {
        lat: 37.09024,
        lng: -95.712891
      },
      zoom: MapsHelper.DEFAULT_ZOOM,
      markerTitle: 'US',
      showCenterMarker: false,
      borderFillColor: '#8FBC8F',
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    _mode = MapsHelper.Mode.View;

    if (isDefinedAndNonNull(options)) {
      if (isDefinedAndNonNull(options.mode))
        _mode = options.mode;
      if (isDefinedAndNonNull(options.center))
        _mapOptions.center = options.center;
      if (isDefinedAndNonNull(options.zoom))
        _mapOptions.zoom = options.zoom;
      if (isDefinedAndNonNull(options.showCenterMarker))
        _mapOptions.showCenterMarker = options.showCenterMarker;
      if (isDefinedAndNonNull(options.markerTitle))
        _mapOptions.markerTitle = options.markerTitle;
      if (isDefinedAndNonNull(options.boundary))
        _mapOptions.boundary = options.boundary;
      if (isDefinedAndNonNull(options.mapTypeControl))
        _mapOptions.mapTypeControl = options.mapTypeControl;
      if (isDefinedAndNonNull(options.streetViewControl))
        _mapOptions.streetViewControl = options.streetViewControl;
      if (isDefinedAndNonNull(options.view_window))
      {
        _mapOptions.view_window = new google.maps.LatLngBounds(
          new google.maps.LatLng(options.view_window.sw.lat, options.view_window.sw.lng),
          new google.maps.LatLng(options.view_window.ne.lat, options.view_window.ne.lng)
        );
      }
      if (isDefinedAndNonNull(options.additional_markers))
        _mapOptions.additional_markers = options.additional_markers;
      if (isDefinedAndNonNull(options.borderFillColor))
        _mapOptions.borderFillColor = options.borderFillColor;
      if (isDefinedAndNonNull(options.mapType))
        _mapOptions.mapTypeId = options.mapType;
    }
  }

  function createMap(mapCanvas) {

    _map = new google.maps.Map(resolveElement(mapCanvas), _mapOptions);

    if (isDefinedAndNonNull(_mapOptions.view_window)) {
      fitViewWindow(_mapOptions.view_window);
      //_map.fitBounds(_mapOptions.view_window);
    }

    if (
        ( (_mode == MapsHelper.Mode.View) && (_mapOptions.showCenterMarker) )
        ||
        (_mode == MapsHelper.Mode.SetLocation)
      ) {
      setMarkerLocationImpl(_mapOptions.center);
      if (isDefinedAndNonNull(_mapOptions.boundary)) {
        _boundary = addBoundary(_mapOptions.boundary, (_mode == MapsHelper.Mode.SetBoundary));
      }
    }
    if ((_mode == MapsHelper.Mode.View) || (_mode == MapsHelper.Mode.SetBoundary)) {
      if (isDefinedAndNonNull(_mapOptions.boundary)) {
        _boundary = addBoundary(_mapOptions.boundary, (_mode == MapsHelper.Mode.SetBoundary));
      }
    }
    if ((_mode == MapsHelper.Mode.View) && (isDefinedAndNonNull(_mapOptions.additional_markers))) {
      for (var i = 0; i < _mapOptions.additional_markers.length; i++) {
        var marker = _mapOptions.additional_markers[i];
        addMarkerImpl(marker);
      }
    }
  }

  function findAddressImpl(address, setMarker) {
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode(
      { 'address': address },
      function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          _map.panTo(results[0].geometry.location);
          setMarkerLocationImpl(results[0].geometry.location);
          _markerAddress = results[0].formatted_address;
        }
        else {
          throw 'Geocode was not successful for the following reason: ' + status;
        }
      }
    );
  }

  function setMarkerLocationImpl(location) {
    if (isDefinedAndNonNull(_marker)) {
      _marker.setMap(null);
    }
    _marker = new google.maps.Marker(
      {
        position: location,
        map: _map,
        draggable: (_mode == MapsHelper.Mode.SetLocation),
        title: isDefinedAndNonNull(_mapOptions.markerTitle) ? _mapOptions.markerTitle : 'location'
      }
    );
    initMarkerDragEvent();
  }

  function getMarkerLocationImpl() {
    if (_marker == null) throw "The marker has not been created";
    return _marker.getPosition();
  }

  function getMarkerAddressImpl() {
    if (_markerAddress == null) throw "A new marker has not been created";
    return _markerAddress;
  }

  function setCenterImpl(location) {
    _map.panTo(location);
    setMarkerLocationImpl(location);
  }

  function createMarker(location, title, icon, zIndex) {
    var markerOptions = {
      position: location,
      map: _map,
      draggable: false,
      title: title,
      zIndex: 2
    };
    if (isDefinedAndNonNull(icon)) markerOptions.icon = icon;
    if (isDefinedAndNonNull(zIndex)) markerOptions.zIndex = zIndex;
    return new google.maps.Marker(markerOptions);
  }

  function clearMarkersImpl(tag) {
    if (_additionalMarkers != null) {
      for (var index = _additionalMarkers.length - 1; index >= 0; index--) {
        if (_additionalMarkers[index].getTag() == tag) {
          _additionalMarkers[index].remove();
          _additionalMarkers.splice(index, 1);
        }
      }
    }
  }

  function addMarkerImpl(markerDef, tag) {
    if (_additionalMarkers == null) {
      _additionalMarkers = new Array();
    }
    var mapMarker = createMarker(new google.maps.LatLng(markerDef.coordinates.lat, markerDef.coordinates.lng), markerDef.title, markerDef.icon, markerDef.zIndex);
    var marker = new Marker(_map, mapMarker, tag);

    if (isDefinedAndNonNull(markerDef.infoWindowContent)) {
      marker.setInfoWindow(markerDef.infoWindowContent);
    }
    _additionalMarkers.push(marker);
    return marker;
  }

  function createDrawingManagerImpl(options) {
    var drawingManager = new google.maps.drawing.DrawingManager(options);
    drawingManager.setMap(_map);
    return drawingManager;
  }
  function drawBoundaryImpl(replaceExisting) {

    var drawingManager = getDrawingManager();

    if (replaceExisting) {
      if (_boundary != null) {
        _boundary.setMap(null);
        _boundary = null;
      }
    }

    if (isDefinedAndNonNull(_boundary)) {
      _boundary.setEditable(true);
      drawingManager.setDrawingMode(null);
    }
    else if (isDefinedAndNonNull(_mapOptions.boundary)) {
      _boundary = addBoundary(_mapOptions.boundary, true);
      drawingManager.setDrawingMode(null);
    }
    else {
      google.maps.event.addListener(drawingManager, 'polygoncomplete', function(polygon) { polygonCompleteHandler(polygon); });
      drawingManager.setDrawingMode(google.maps.drawing.OverlayType.POLYGON);
    }
  }
  function addBoundary(vertices, editable) {
    var polygonPaths = new Array();
    for (var i = 0; i < vertices.length; i++)
      polygonPaths.push(new google.maps.LatLng(vertices[i].lat, vertices[i].lng));
    var boundary = new google.maps.Polygon (
      {
        paths: polygonPaths,
        clickable: false
      }
    );
    boundary.setMap(_map);
    boundary.setEditable(editable);
    setBoundaryColor(boundary);
    return boundary;
  }
  function setBoundary(vertices) {
    if (_boundary != null) {
      _boundary.setMap(null);
      _boundary = null;
    }
    _boundary = addBoundary(vertices, (_mode == MapsHelper.Mode.SetBoundary));
  }
  function setBoundaryColor(boundary) {
    editable = (_mode == MapsHelper.Mode.SetBoundary);
    var options = null;
    if (_map.getMapTypeId() == MapsHelper.MapTypes.Roadmap) {
      options = {
        strokeColor: (editable ? '#000000' : '#8FBC8F'),
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: _mapOptions.borderFillColor,
        fillOpacity: 0.35
      };
    }
    else {
      options = {
        strokeColor: '#00bb00',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#000000',
        fillOpacity: 0
      };
    }
    boundary.setOptions(options);
  }
  function updateBoundaryColor() {
    if (_boundary != null) {
      setBoundaryColor(_boundary);
    }
  }

  function polygonCompleteHandler(polygon) {
    _boundary = polygon;
    _boundary.setEditable(true);
    getDrawingManager().setDrawingMode(null);
  }
  function getDrawingManager() {
    if (_drawingManager == null) {
      _drawingManager = new google.maps.drawing.DrawingManager(
        {
          drawingMode: google.maps.drawing.OverlayType.MARKER,
          drawingControl: false
        }
      );
      _drawingManager.setMap(_map);
    }
    return _drawingManager;
  }
  function hideMarkerImpl() {
    if (isDefinedAndNonNull(_marker)) {
      _marker.setVisible(false);
    }
  }
  function showMarkerImpl() {
    if (isDefinedAndNonNull(_marker)) {
      _marker.setVisible(true);
    }
  }
  function setModeImpl(mode) {
    _mode = mode;
    switch (_mode) {
      case MapsHelper.Mode.View: {
        if (isDefinedAndNonNull(_marker)) {
          _marker.setDraggable(false);
          _marker.setVisible(true);
        }
        if (isDefinedAndNonNull(_boundary)) {
          _boundary.setEditable(false);
          _boundary.setVisible(true);
        }
        break;
      }
      case MapsHelper.Mode.SetLocation: {
        if (isDefinedAndNonNull(_marker)) {
          _marker.setDraggable(true);
          _marker.setVisible(true);
        }
        if (isDefinedAndNonNull(_boundary)) {
          _boundary.setEditable(false);
          _boundary.setVisible(false);
        }
        break;
      }
      case MapsHelper.Mode.SetBoundary: {
        if (isDefinedAndNonNull(_marker)) {
          _marker.setDraggable(false);
          _marker.setVisible(false);
        }
        if (isDefinedAndNonNull(_boundary)) {
          _boundary.setEditable(true);
          _boundary.setOptions({ strokeColor: '#000000' });
          _boundary.setVisible(true);
        }
        break;
      }
    }
    updateBoundaryColor();
  }
  function getModeImpl() {
    return _mode;
  }
  function getBoundaryVerticesImpl() {
    if (_boundary == null) return null;
    var boundaryVertices = new Array();
    var pathVertices = _boundary.getPath();
    for (var i = 0; i < pathVertices.getLength(); i++) {
      var vertice = pathVertices.getAt(i);
      boundaryVertices.push( { lat: vertice.lat(), lng: vertice.lng() } );
    }
    return boundaryVertices;
  }
  function setMapTypeImpl(mapType) {
    _map.setMapTypeId(mapType);
    updateBoundaryColor();
  }
  function setDragEventHandlerImpl(handler) {
    _dragEventHandler = handler;
    initMarkerDragEvent();
  }
  function clickImpl(handler) {
    google.maps.event.addListener(_map, 'click', function(event) { handler(event); } );
  }
  function rightClickImpl(handler) {
    google.maps.event.addListener(_map, 'rightclick', function(event) { handler(event); } );
  }
  function initMarkerDragEvent() {
    if (_markerDragEventListener != null) google.maps.event.removeListener(_markerDragEventListener);
    _markerDragEventListener = null;
    if ((_marker != null) && (_dragEventHandler != null)) {
      var marker = _marker;
      _markerDragEventListener = google.maps.event.addListener(
        _marker,
        'dragend',
        function() { _dragEventHandler(marker); }
      );
    }
  }
  function fitViewWindow(viewWindow) {

    _map.fitBounds(viewWindow); // calling fitBounds() here to center the map for the bounds

    var overlayHelper = new google.maps.OverlayView();
    overlayHelper.draw = function () {
      if (!this.ready) {
        var extraZoom = getExtraZoom(this.getProjection(), viewWindow, _map.getBounds());
        if (extraZoom > 0) {
          _map.setZoom(_map.getZoom() + extraZoom);
        }
        this.ready = true;
        google.maps.event.trigger(this, 'ready');
      }
    };
    overlayHelper.setMap(_map);
  }

  function getExtraZoom(projection, expectedBounds, actualBounds) {

    // in: LatLngBounds bounds -> out: height and width as a Point
    function getSizeInPixels(bounds) {
      var sw = projection.fromLatLngToContainerPixel(bounds.getSouthWest());
      var ne = projection.fromLatLngToContainerPixel(bounds.getNorthEast());
      return new google.maps.Point(Math.abs(sw.y - ne.y), Math.abs(sw.x - ne.x));
    }

    var expectedSize = getSizeInPixels(expectedBounds),
      actualSize = getSizeInPixels(actualBounds);

    if (Math.floor(expectedSize.x) == 0 || Math.floor(expectedSize.y) == 0) {
      return 0;
    }

    var qx = actualSize.x / expectedSize.x;
    var qy = actualSize.y / expectedSize.y;
    var min = Math.min(qx, qy);

    if (min < 1) {
      return 0;
    }

    return Math.floor(Math.log(min) / Math.LN2 /* = log2(min) */);
  }

  function getMapImpl() {
    return _map;
  }
}
function Marker(map, googleMarker, tag) {
  var _map = map;
  var _googleMarker = googleMarker;
  var _infoWindow = null;
  var _infoWindowInitializer = null;
  var _clickListener = null;
  var _tag = tag;
  this.remove = function() { removeImpl(); }
  this.hide = function() { hideImpl(); }
  this.show = function() { showImpl(); }
  this.setIcon = function(icon) { setIconImpl(icon); }
  this.setInfoWindow = function(content, initializer) { setInfoWindowImpl(content, initializer); }
  this.setLocation = function(coordinates) { setLocationImpl(coordinates); }
  this.click = function(handler) { clickImpl(handler); }
  this.rightClick = function(handler) { rightClickImpl(handler); }
  this.getTag = function() { return getTagImpl(); }

  function getTagImpl() {
    return _tag;
  }
  function removeImpl() {
    _googleMarker.setMap(null);
  }
  function hideImpl() {
    _googleMarker.setVisible(false);
  }
  function showImpl() {
    _googleMarker.setVisible(true);
  }
  function setIconImpl(icon) {
    _googleMarker.setIcon(icon);
  }
  function setInfoWindowImpl(content, initializer) {
    if (isDefinedAndNonNull(initializer)) {
      _infoWindowInitializer = initializer;
    }
    if (content == null) {
      if (_infoWindow != null) {
        google.maps.event.clearListeners(_googleMarker, 'click');
      }
      _infoWindow = null;
    }
    else {
      var addListener = (_infoWindow == null);
      if (content instanceof google.maps.InfoWindow) {
        _infoWindow = content;
      }
      else {
        if (_infoWindow == null) {
          _infoWindow = new google.maps.InfoWindow( { content: content } );
        }
        else {
          _infoWindow.setContent(content);
        }
      }
      if (addListener) {
        google.maps.event.addListener(
          _googleMarker,
          'click',
          function() {
            if (_infoWindowInitializer != null) {
              _infoWindowInitializer(_tag);
            }
            _infoWindow.open(_map, _googleMarker);
          }
        );
      }
    }
  }
  function clickImpl(handler) {
    google.maps.event.clearListeners(_googleMarker, 'click');
    google.maps.event.addListener(_googleMarker, 'click', function(event) { handler(_tag, event); } );
  }
  function rightClickImpl(handler) {
    google.maps.event.clearListeners(_googleMarker, 'rightclick');
    google.maps.event.addListener(_googleMarker, 'rightclick', function(event) { handler(_tag, event); } );
  }
  function setLocationImpl(coordinates) {
    _googleMarker.setPosition(coordinates);
  }
}

MapsHelper.DEFAULT_ZOOM = 10;
MapsHelper.Mode = { View: 1, SetLocation: 2, SetBoundary: 3 };
MapsHelper.MapTypes = { Roadmap: google.maps.MapTypeId.ROADMAP, Satellite: google.maps.MapTypeId.SATELLITE };

MapsHelper.LatLngToDocumentPosition = function(map, latLng) {

  var mapWidth = $(map.getDiv()).width();
  var mapHeight = $(map.getDiv()).height();
  var clickedPosition = getCanvasXY(latLng);
  var x = clickedPosition.x ;
  var y = clickedPosition.y ;

  return { x: x, y: y };

  function getCanvasXY(latLng) {
    var scale = Math.pow(2, map.getZoom());
    var nw = new google.maps.LatLng(
      map.getBounds().getNorthEast().lat(),
      map.getBounds().getSouthWest().lng()
    );
    var worldCoordinateNW = map.getProjection().fromLatLngToPoint(nw);
    var worldCoordinate = map.getProjection().fromLatLngToPoint(latLng);
    var canvasOffset = new google.maps.Point(
      Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale),
      Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)
    );
    return canvasOffset;
  }
}
