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
