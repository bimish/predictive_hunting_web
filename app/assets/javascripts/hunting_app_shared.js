var g_pageInitializers = [];
function pageInit(initFunction) {
  g_pageInitializers.push(initFunction);
}
function callPageInitializers(event) {
  $.each(
    g_pageInitializers,
    function(index, item) {
      item(event);
    }
  );
}

MapIcons.HuntingLocationAvailable = {
  url: '/assets/map_marker_green.png',
  size: new google.maps.Size(16,16),
  origin: new google.maps.Point(0, 0),
  anchor: new google.maps.Point(8, 8),
  scaledSize: new google.maps.Size(16,16)
};

MapIcons.HuntingLocationReserved = {
  url: '/assets/map_marker_yellow.png',
  size: new google.maps.Size(16,16),
  origin: new google.maps.Point(0, 0),
  anchor: new google.maps.Point(8, 8),
  scaledSize: new google.maps.Size(16,16)
};

MapIcons.HuntingLocationOccupied = {
  url: '/assets/map_marker_red.png',
  size: new google.maps.Size(16,16),
  origin: new google.maps.Point(0, 0),
  anchor: new google.maps.Point(8, 8),
  scaledSize: new google.maps.Size(16,16)
};
