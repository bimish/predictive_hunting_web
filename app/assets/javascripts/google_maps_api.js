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
	this.addMarker = function(marker, tag) { addMarkerImpl(marker, tag); }
	this.setDragEventHandler = function(handler) { setDragEventHandlerImpl(handler); }

	function initOptions(options) {
		// default to center of US
		_mapOptions = {
			center: {
				lat: 37.09024,
				lng: -95.712891
			},
			zoom: MapsHelper.DEFAULT_ZOOM,
			markerTitle: 'US',
			showCenterMarker: false
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
		}
	}

	function createMap(mapCanvas) {

		_map = new google.maps.Map(resolveElement(mapCanvas), _mapOptions);

		if (isDefinedAndNonNull(_mapOptions.view_window)) {
			_map.fitBounds(_mapOptions.view_window);
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
				if (_additionalMarkers[index].tag == tag) {
					_additionalMarkers[index].marker.setMap(null);
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

		if (isDefinedAndNonNull(markerDef.infoWindowContent)) {
			var infoWindow = new google.maps.InfoWindow( { content: markerDef.infoWindowContent } );
			google.maps.event.addListener(
				mapMarker,
				'click',
				function() {
					infoWindow.open(_map, mapMarker);
				}
			);
		}
		_additionalMarkers.push( { marker: mapMarker, tag: tag } );
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
				strokeColor: (editable ? '#000000' : '#8FBC8F'),
				strokeOpacity: 0.8,
				strokeWeight: 2,
				fillColor: '#8FBC8F',
				fillOpacity: 0.35
			}
		);
		boundary.setMap(_map);
		boundary.setEditable(editable);
		return boundary;
	}
	function setBoundary(vertices) {
		if (_boundary != null) {
			_boundary.setMap(null);
			_boundary = null;
		}
		_boundary = addBoundary(vertices, (_mode == MapsHelper.Mode.SetBoundary));
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
	}
	function setDragEventHandlerImpl(handler) {
		_dragEventHandler = handler;
		initMarkerDragEvent();
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
}

MapsHelper.DEFAULT_ZOOM = 10;
MapsHelper.Mode = { View: 1, SetLocation: 2, SetBoundary: 3 };
MapsHelper.MapTypes = { Roadmap: google.maps.MapTypeId.ROADMAP, Satellite: google.maps.MapTypeId.SATELLITE };
