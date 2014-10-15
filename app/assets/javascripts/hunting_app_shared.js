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
Scripts.Common = {}; // scripts shared by more than one page are declared under the Common namespace

// sets the content area to fill the available screen height
/*
Scripts.Common.setContentFullHeight = function() {
  var screen = $.mobile.getScreenHeight();
  var header = $(".ui-header").hasClass("ui-header-fixed") ? $(".ui-header").outerHeight()  - 1 : $(".ui-header").outerHeight();
  var footer = $(".ui-footer").hasClass("ui-footer-fixed") ? $(".ui-footer").outerHeight() - 1 : $(".ui-footer").outerHeight();
  // content div has padding of 1em = 16px (32px top+bottom). This step can be skipped by subtracting 32px from content var directly.
  var contentCurrent = $(".ui-content").outerHeight() - $(".ui-content").height();
  var content = screen - header - footer - contentCurrent;
  $(".ui-content").height(content);
};
*/

Scripts.Common.setContentFullHeight = function() {
  var activePage = $.mobile.pageContainer.pagecontainer("getActivePage"),
  screen = $.mobile.getScreenHeight(),
  header = $(".ui-header", activePage).hasClass("ui-header-fixed") ? $(".ui-header", activePage).outerHeight() - 1 : $(".ui-header", activePage).outerHeight(),
  footer = $(".ui-footer", activePage).hasClass("ui-footer-fixed") ? $(".ui-footer", activePage).outerHeight() - 1 : $(".ui-footer", activePage).outerHeight(),
  contentCurrent = $(".ui-content", activePage).outerHeight() - $(".ui-content", activePage).height(),
  content = screen - header - footer - contentCurrent;
  // apply result
  $(".ui-content", activePage).height(content);
}

var g_pageInitializers = [];
Scripts.Common.pageInit = function(pageId, initFunction) {
  g_pageInitializers.push( { pageId: pageId, handler: initFunction } );
};
Scripts.Common.callPageInitializers = function(pageId) {
  $.each(
    g_pageInitializers,
    function(index, item) {
      if (item.pageId == pageId) {
        item.handler();
      }
    }
  );
};
