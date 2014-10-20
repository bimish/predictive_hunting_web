Scripts.Page.Weather = function() {

  this.initPage = function() {
    var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");
    $('div[data-role="navbar"] > ul > li > a', activePage).click(
      function (eventObject) {
        var targetPanelId = $(this).attr('href').replace('#', '');
        $('div[data-role="content"] > div', activePage).each(
          function (index, item) {
            if ($(item).attr('id') == targetPanelId)
              $(item).addClass('content-panel-active');
            else
              $(item).removeClass('content-panel-active');
          }
        );
      }
    );
  }
  return this;
}();

// register the page initailizer
Scripts.Common.pageInit('weather', Scripts.Page.Weather.initPage);
