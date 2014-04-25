function MapsHelper(mapCanvas, options)
{
	if (!isDefinedAndNonNull(mapCanvas)) throw "mapCanvas is required";

	initOptions(options);
	createMap(mapCanvas);

	this.setLocationByAddress = function(address) { findAddressImpl(address, true) };
	this.setMarkerLocation = function(latitude, longitude) { setMarkerLocationImpl(new google.maps.LatLng(latitude, longitude)); };
	this.getMarkerLocation = function() { return getMarkerLocationImpl(); };
	this.setCenter = function(latitude, longitude) { setCenterImpl(new google.maps.LatLng(latitude, longitude)); };
	this.getDrawingManager = function(options) { return createDrawingManagerImpl(options); };
	this.createBoundary = function(options, resultsHandler) { return drawBoundaryImpl(true); };
	this.editBoundary = function(options, resultsHandler) { return drawBoundaryImpl(false); };
	this.hideMarker = function() { hideMarkerImpl(); };
	this.showMarker = function() { showMarkerImpl(); };
	this.setMode = function(mode) { setModeImpl(mode); };
	this.getMode = function() { return getModeImpl(); };
	this.getBoundaryVertices = function() { return getBoundaryVerticesImpl(); };

	function initOptions(options) {
		// default to center of US
		this.g_mapOptions = {
			center: {
				lat: 37.09024,
				lng: -95.712891
			},
			zoom: MapsHelper.DEFAULT_ZOOM,
			markerTitle: 'US'
		};
		this.Mode = MapsHelper.Mode.View;

		if (isDefinedAndNonNull(options)) {
			if (isDefinedAndNonNull(options.mode))
				this.Mode = options.mode;
			if (isDefinedAndNonNull(options.center))
				this.g_mapOptions.center = options.center;
			if (isDefinedAndNonNull(options.zoom))
				this.g_mapOptions.zoom = options.zoom;
			if (isDefinedAndNonNull(options.markerTitle))
				this.g_mapOptions.markerTitle = options.markerTitle;
			if (isDefinedAndNonNull(options.boundary))
				this.g_mapOptions.boundary = options.boundary;
			if (isDefinedAndNonNull(options.view_window))
			{
				this.g_mapOptions.view_window = new google.maps.LatLngBounds(
					new google.maps.LatLng(options.view_window.sw.lat, options.view_window.sw.lng),
					new google.maps.LatLng(options.view_window.ne.lat, options.view_window.ne.lng)
				);
			}
			if (isDefinedAndNonNull(options.additional_markers))
				this.g_mapOptions.additional_markers = options.additional_markers;
		}
	}

	function createMap(mapCanvas) {

		this.g_map = new google.maps.Map(resolveElement(mapCanvas), this.g_mapOptions);

		if (isDefinedAndNonNull(this.g_mapOptions.view_window)) {
			this.g_map.fitBounds(this.g_mapOptions.view_window);
		}

		if ((this.Mode == MapsHelper.Mode.View) || (this.Mode == MapsHelper.Mode.SetLocation)) {
			setMarkerLocationImpl(this.g_mapOptions.center);
		}
		if ((this.Mode == MapsHelper.Mode.View) || (this.Mode == MapsHelper.Mode.SetBoundary)) {
			if (isDefinedAndNonNull(this.g_mapOptions.boundary)) {
				this.g_boundary = addBoundary(this.g_mapOptions.boundary, (this.Mode == MapsHelper.Mode.SetBoundary));
			}
		}
		if ((this.Mode == MapsHelper.Mode.View) && (isDefinedAndNonNull(this.g_mapOptions.additional_markers))) {
			for (var i = 0; i < this.g_mapOptions.additional_markers.length; i++) {
				var marker = this.g_mapOptions.additional_markers[i];
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
					this.g_map.panTo(results[0].geometry.location);
					setMarkerLocationImpl(results[0].geometry.location);
				}
				else {
					throw 'Geocode was not successful for the following reason: ' + status;
				}
			}
		);
	}

	function setMarkerLocationImpl(location) {
		if (isDefinedAndNonNull(this.g_marker)) {
			this.g_marker.setMap(null);
		}
		this.g_marker = new google.maps.Marker(
			{
				position: location,
				map: this.g_map,
				draggable: (this.Mode == MapsHelper.Mode.SetLocation),
				title: isDefinedAndNonNull(this.g_mapOptions.markerTitle) ? this.g_mapOptions.markerTitle : 'location'
			}
		);
	}

	function getMarkerLocationImpl() {
		if (!isDefinedAndNonNull(this.g_marker)) throw "The marker has not been created";
		return this.g_marker.getPosition();
	}

	function setCenterImpl(location) {
		this.g_map.panTo(location);
		setMarkerLocationImpl(location);
	}

	function addMarker(location, title) {
		if (this.additionalMarkers == null) {
			this.additionalMarkers = new Array();
		}
		var marker =
			new google.maps.Marker(
				{
					position: location,
					map: this.g_map,
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
		this.additionalMarkers.push(marker);
	}
	function createDrawingManagerImpl(options) {
		var drawingManager = new google.maps.drawing.DrawingManager(options);
		drawingManager.setMap(this.g_map);
		return drawingManager;
	}
	function drawBoundaryImpl(replaceExisting) {

		var drawingManager = getDrawingManager();

		if (replaceExisting) {
			if (isDefinedAndNonNull(this.g_boundary)) {
				this.g_boundary.setMap(null);
				this.g_boundary = null;
			}
		}

		if (isDefinedAndNonNull(this.g_boundary)) {
			this.g_boundary.setEditable(true);
			drawingManager.setDrawingMode(null);
		}
		else if (isDefinedAndNonNull(this.g_mapOptions.boundary)) {
			this.g_boundary = addBoundary(this.g_mapOptions.boundary, true);
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
		boundary.setMap(this.g_map);
		boundary.setEditable(editable);
		return boundary;
	}
	function polygonCompleteHandler(polygon) {
		this.g_boundary = polygon;
		this.g_boundary.setEditable(true);
		getDrawingManager().setDrawingMode(null);
	}
	function getDrawingManager() {
		if (!isDefinedAndNonNull(this.g_drawingManager)) {
			this.g_drawingManager = new google.maps.drawing.DrawingManager(
				{
					drawingMode: google.maps.drawing.OverlayType.MARKER,
					drawingControl: false
				}
			);
			this.g_drawingManager.setMap(this.g_map);
		}
		return this.g_drawingManager;
	}
	function hideMarkerImpl() {
		if (isDefinedAndNonNull(this.g_marker)) {
			this.g_marker.setVisible(false);
		}
	}
	function showMarkerImpl() {
		if (isDefinedAndNonNull(this.g_marker)) {
			this.g_marker.setVisible(true);
		}
	}
	function setModeImpl(mode) {
		this.Mode = mode;
		switch (this.Mode) {
			case MapsHelper.Mode.View: {
				if (isDefinedAndNonNull(this.g_marker)) {
					this.g_marker.setDraggable(false);
					this.g_marker.setVisible(true);
				}
				if (isDefinedAndNonNull(this.g_boundary)) {
					this.g_boundary.setEditable(false);
					this.g_boundary.setVisible(true);
				}
				break;
			}
			case MapsHelper.Mode.SetLocation: {
				if (isDefinedAndNonNull(this.g_marker)) {
					this.g_marker.setDraggable(true);
					this.g_marker.setVisible(true);
				}
				if (isDefinedAndNonNull(this.g_boundary)) {
					this.g_boundary.setEditable(false);
					this.g_boundary.setVisible(false);
				}
				break;
			}
			case MapsHelper.Mode.SetBoundary: {
				if (isDefinedAndNonNull(this.g_marker)) {
					this.g_marker.setDraggable(false);
					this.g_marker.setVisible(false);
				}
				if (isDefinedAndNonNull(this.g_boundary)) {
					this.g_boundary.setEditable(true);
					this.g_boundary.setVisible(true);
				}
				break;
			}
		}
	}
	function getModeImpl() {
		return this.Mode;
	}
	function getBoundaryVerticesImpl() {
		if (!isDefinedAndNonNull(this.g_boundary)) return null;
		var boundaryVertices = new Array();
		var pathVertices = this.g_boundary.getPath();
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

