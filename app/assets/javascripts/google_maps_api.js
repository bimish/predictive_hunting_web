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

	function initOptions(options) {
		// default to center of US
		_mapOptions = {
			center: {
				lat: 37.09024,
				lng: -95.712891
			},
			zoom: MapsHelper.DEFAULT_ZOOM,
			markerTitle: 'US'
		};
		_mode = MapsHelper.Mode.View;

		if (isDefinedAndNonNull(options)) {
			if (isDefinedAndNonNull(options.mode))
				_mode = options.mode;
			if (isDefinedAndNonNull(options.center))
				_mapOptions.center = options.center;
			if (isDefinedAndNonNull(options.zoom))
				_mapOptions.zoom = options.zoom;
			if (isDefinedAndNonNull(options.markerTitle))
				_mapOptions.markerTitle = options.markerTitle;
			if (isDefinedAndNonNull(options.boundary))
				_mapOptions.boundary = options.boundary;
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

		if ((_mode == MapsHelper.Mode.View) || (_mode == MapsHelper.Mode.SetLocation)) {
			setMarkerLocationImpl(_mapOptions.center);
		}
		if ((_mode == MapsHelper.Mode.View) || (_mode == MapsHelper.Mode.SetBoundary)) {
			if (isDefinedAndNonNull(_mapOptions.boundary)) {
				_boundary = addBoundary(_mapOptions.boundary, (_mode == MapsHelper.Mode.SetBoundary));
			}
		}
		if ((_mode == MapsHelper.Mode.View) && (isDefinedAndNonNull(_mapOptions.additional_markers))) {
			for (var i = 0; i < _mapOptions.additional_markers.length; i++) {
				var marker = _mapOptions.additional_markers[i];
				addMarker(new google.maps.LatLng(marker.coordinates.lat, marker.coordinates.lng), marker.name);
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

	function addMarker(location, title) {
		if (_additionalMarkers == null) {
			_additionalMarkers = new Array();
		}
		var marker =
			new google.maps.Marker(
				{
					position: location,
					map: _map,
					draggable: false,
					title: title,
					zIndex: 1000,
					icon: {
						path: google.maps.SymbolPath.CIRCLE,
						scale: 5,
						strokeWeight: 1,
						strokeColor: 'black',
						fillColor: 'green',
						fillOpacity: 0.8
					}
				}
			);
		_additionalMarkers.push(marker);
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
		var boundary = new google.maps.Polygon ( { paths: polygonPaths } );
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
}

MapsHelper.DEFAULT_ZOOM = 10;
MapsHelper.getLocationAddress = function(latitude, longitude, resultHandler) {
	var geocoder = new google.maps.Geocoder();
	geocoder.geocode(
		{ 'latLng': new google.maps.LatLng(latitude, longitude) },
		function(results, status) {
			var resultAddress = null;
			if (status != google.maps.GeocoderStatus.OK)
				resultAddress = "Could not get address for location, status code = " + status;
			else
				resultAddress = results[1].formatted_address;
			if (typeof resultHandler == 'function')
				resultHandler(resultAddress);
			else if (typeof resultHandler == 'object')
				resultHandler.innerHTML = resultAddress;
			else
				$('#' + resultHandler).text(resultAddress);
		}
	);
}
MapsHelper.Mode = { View: 1, SetLocation: 2, SetBoundary: 3 };

