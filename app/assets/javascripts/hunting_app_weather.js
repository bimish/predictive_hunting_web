(function() {

  function WeatherPageScript() {

    this.initPage = function(page) {
      Scripts.Common.initializeTabbedNavBar($('div[data-role="navbar"]', page));
    }

  }

  Scripts.Page.Weather = new WeatherPageScript();

  // register the page initailizer
  Scripts.Common.pageInitialize('weather', Scripts.Page.Weather.initPage);

})();
