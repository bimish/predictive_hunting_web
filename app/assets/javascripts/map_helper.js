MapIcons = {
  HuntingPlotLocation: {
    url: '/assets/map_marker_blue.png',
    size: new google.maps.Size(16,16),
    origin: new google.maps.Point(0, 0),
    anchor: new google.maps.Point(8, 8),
    scaledSize: new google.maps.Size(16,16)
  }
};

MapsHelper.getLocationAddress = function(latitude, longitude, resultHandler) {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode(
    {
      'latLng': new google.maps.LatLng(latitude, longitude)
    },
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
};
