function MapsHelper(mapCanvas, options)
{
	if (!isDefinedAndNonNull(mapCanvas)) throw "mapCanvas is required";

	initOptions(options);
	createMap(mapCanvas);

	this.setLocationByAddress = function(address) { findAddressImpl(address, true) };
	this.setMarkerLocation = function(latitude, longitude) { setMarkerLocationImpl(new google.maps.LatLng(latitude, longitude)); };
	this.setCenter = function(latitude, longitude) { setCenterImpl(new google.maps.LatLng(latitude, longitude)); }

	function initOptions(options) {
		// default to center of US
		this.g_mapOptions = {
			center: {
				lat: 37.09024,
				lng: -95.712891
			},
			zoom: MapsHelper.DEFAULT_ZOOM,
			markerTitle: 'US',
			addMarker: true
		};
		if (isDefinedAndNonNull(options)) {
			if (isDefinedAndNonNull(options.center))
				this.g_mapOptions.center = options.center;
			if (isDefinedAndNonNull(options.zoom))
				this.g_mapOptions.zoom = options.zoom;
			if (isDefinedAndNonNull(options.addMarker))
				this.g_mapOptions.addMarker = options.addMarker;
			if (isDefinedAndNonNull(options.markerTitle))
				this.g_mapOptions.markerTitle = options.markerTitle;
		}
	}

	function createMap(mapCanvas) {

		this.g_map = new google.maps.Map(resolveElement(mapCanvas), this.g_mapOptions);

		if (this.g_mapOptions.addMarker) {
			setMarkerLocationImpl(this.g_mapOptions.center);
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
				draggable: true,
				title: isDefinedAndNonNull(this.g_mapOptions.markerTitle) ? this.g_mapOptions.markerTitle : 'location'
			}
		);
	}

	function setCenterImpl(location) {
		this.g_map.panTo(location);
		setMarkerLocationImpl(location);
	}

	function addMarker(location, title) {
		if (this.additionalMarkers == null) {
			this.additionalMarkers = new Array();
		}
		this.additionalMarkers.push(
			new google.maps.Marker(
				{
					position: location,
					map: this.g_map,
					draggable: true,
					title: title,
					icon: {
						path: google.maps.SymbolPath.CIRCLE,
						scale: 5,
						strokeColor: 'green'
					}
				}
			)
		);
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

