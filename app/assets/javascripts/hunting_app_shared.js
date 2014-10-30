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

  // page initializers are called once per page instance
  var _pageInitializeHandlers = [];
  this.pageInitialize = function(pageId, initFunction) {
    _pageInitializeHandlers.push( { pageId: pageId, handler: initFunction } );
  };
  /*
  this.registerPageInitializers = function() {
    $.each(
      _pageInitializeHandlers,
      function (index, item) {
        $(document).on(
          'pagecreate',
          '#' + item.pageId,
          item.handler
        );
      }
    );
  }
  */
  this.initializePage = function(pageContainer) {

    initializePageCommon(pageContainer);

    // call any other initializers that have been registered
    var pageId = $(pageContainer).attr('id');
    $.each(
      _pageInitializeHandlers,
      function(index, item) {
        if (item.pageId == pageId) {
          item.handler(pageContainer);
        }
      }
    );
  }

  function initializePageCommon(pageContainer) {
    // if page has a refresh button, initialize it if necessary
    pageContainer.find('#reload-button').click(
      function(event) {
        event.preventDefault();
        Scripts.Common.refreshPage();
      }
    );
  }


  // page show is called each time a page is shown
  var _pageShowHandlers = [];
  this.pageShow = function(pageId, initFunction) {
    _pageShowHandlers.push( { pageId: pageId, handler: initFunction } );
  };
  this.callPageShowHandlers = function(pageId) {
    $.each(
      _pageShowHandlers,
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

  this.refreshPage = function() {
    $(":mobile-pagecontainer").pagecontainer(
      "change",
      window.location.href,
      {
        allowSamePageTransition : true,
        changeHash: false,
        transition : 'none',
        showLoadMsg : false,
        reloadPage : true, // this is supposed to be deprecated in v 1.4 and replaced by reload, but apparently there is a bug
        reload : true
      }
    );
  }


  return this;
}();

/*
$(document).on("pagebeforecreate", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecreate", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerbeforechange", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerbeforehide", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerbeforeload", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerbeforeshow", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerbeforetransition", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerchange", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerchangefailed", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainercreate", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerhide", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerload", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerloadfailed", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainerremove", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainershow", function( event, ui ) { logEvent(event, ui); } );
$(document).on("pagecontainertransition", function( event, ui ) { logEvent(event, ui); } );

function logEvent(event, ui) {
  var toPageId = null;
  if (isDefinedAndNonNull(ui.toPage)) {
    if (typeof ui.toPage == "string")
      toPageId = ui.toPage;
    else if (ui.toPage.length > 0)
      toPageId = ui.toPage.get(0).id
  }
  console.log(
    event.type + " triggered:" +
    " ui.prevPage.id = " + ( (isDefinedAndNonNull(ui.prevPage) && ui.prevPage.length > 0) ? ui.prevPage.get(0).id : '') +
    " ui.toPage.id = " + toPageId
  );
}
*/

// set global hooks for jqm page management
$(document).on(
  "pagecontainershow",
  function(event, ui) {

    // common initialization time a page is shown
    Scripts.Common.setContentFullHeight();

    // if page has not yet been initialized, do it now
    var isInitialized = ($(ui.toPage).data('isInitialized') == 'true');
    if (!isInitialized) {
      Scripts.Common.initializePage(ui.toPage);
      $(ui.toPage).data('isInitialized', 'true');
    }

    // custom page show handlers
    Scripts.Common.callPageShowHandlers($(ui.toPage).get(0).id);
  }
);

// work around for issue https://github.com/jquery/jquery-mobile/issues/7580
// once corrected, the pagecontainerload event can be changed to reference the page id like the pagecontainershow event above
var g_urlBeingLoaded = null;
$(document).on(
  "pagecontainerbeforeload",
  function(event, ui) {
    g_urlBeingLoaded = ui.toPage;
  }
);

/*
$(document).on(
  "pagecontainerload",
  function(event, ui) {
    Scripts.Common.callPageInitializeHandlers(g_urlBeingLoaded);
  }
);
*/

// setup the hooks for the individual pages
/*
$(document).on(
  "pagecontainercreate",
  function(event, ui) {
    Scripts.Common.registerPageInitializers()
  }
);
*/
