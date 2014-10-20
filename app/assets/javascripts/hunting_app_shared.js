/* this code might be used to have the browser doing automatic check-in refreshes
var g_checkinRequestPending = false;
function doCheckIn(currentPosition) {
  if (g_checkinRequestPending) return; // still have a pending request, don't send another
  g_checkinRequestPending = true;
  $.ajax(
    {
      type: 'POST',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify( { authenticity_token: "<%= j form_authenticity_token %>", position: { lat: currentPosition.coords.latitude, lng: currentPosition.coords.longitude } } ),
      url: '<%= j hunting_app_checkin_path(@hunting_plot) %>',
      success: checkInSuccess,
      error: checkInFail
    }
  );
}
function checkInSuccess(data, textStatus, jqXHR) {
  g_checkinRequestPending = false;
}
function checkInFail(jqXHR, textStatus, errorThrown) {
  g_checkinRequestPending = false;
}
*/

// define a namespace for scripts
var Scripts = {};
Scripts.Page = {};   // page-specific scripts are declared under the Page namespace

// scripts shared by more than one page are declared under the Common namespace
Scripts.Common = function () {

  var _pageInitializers = [];

  this.pageInit = function(pageId, initFunction) {
    _pageInitializers.push( { pageId: pageId, handler: initFunction } );
  };

  this.callPageInitializers = function(pageId) {
    $.each(
      _pageInitializers,
      function(index, item) {
        if (item.pageId == pageId) {
          item.handler();
        }
      }
    );
  };

  this.setContentFullHeight = function() {
    var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");
    var screen = $.mobile.getScreenHeight();
    var header = $(".ui-header", activePage).hasClass("ui-header-fixed") ? $(".ui-header", activePage).outerHeight() - 1 : $(".ui-header", activePage).outerHeight();
    var footer = $(".ui-footer", activePage).hasClass("ui-footer-fixed") ? $(".ui-footer", activePage).outerHeight() - 1 : $(".ui-footer", activePage).outerHeight();
    var contentCurrent = $(".ui-content", activePage).outerHeight() - $(".ui-content", activePage).height();
    var content = screen - header - footer - contentCurrent;
    // apply result
    $(".ui-content", activePage).height(content);
  };

  var _geoLocationListeners = null;
  this.initGeoLocation = function(handler) {
    if (!navigator.geolocation) throw 'The browser has blocked or is not capable of reporting geolocation';
    if (_geoLocationListeners == null) {
      // get a reference to the listeners array that is in scope for the callback function below
      var listeners = _geoLocationListeners = [];
      navigator.geolocation.watchPosition(
        function (position) {
          for (var i = 0; i < listeners.length; i++) {
            var listener = listeners[i];
            listener(position); // position.coords.latitude, position.coords.longitude
          }
        }
      );
      _geoLocationListeners.push(handler);
    }
  };

  return this;
}();
