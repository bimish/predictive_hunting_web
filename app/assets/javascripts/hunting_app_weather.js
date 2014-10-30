(function() {

  function WeatherPageScript() {

    this.initPage = function(page) {
      $('div[data-role="navbar"] > ul > li > a', page).click(
        function (eventObject) {
          var targetPanelId = $(this).attr('href').replace('#', '');
          var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");
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

  }

  Scripts.Page.Weather = new WeatherPageScript();

  // register the page initailizer
  Scripts.Common.pageInitialize('weather', Scripts.Page.Weather.initPage);

})();
