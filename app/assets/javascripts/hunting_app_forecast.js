(function() {

  function HuntForecastPageScript() {

    this.initPage = function(page) {

      Scripts.Common.initializeTabbedNavBar($('div[data-role="navbar"]', page));

      $('table.month-hunt-forecast', page).find('td').click(
        function(event) {
          var dayOfMonth = $(this).text();
          if ((dayOfMonth == null) || (dayOfMonth == '')) return;
        }
      );
    }

  }

  Scripts.Page.HuntForecast = new HuntForecastPageScript();

  // register the page initailizer
  Scripts.Common.pageInitialize('hunt_forecast', Scripts.Page.HuntForecast.initPage);

})();
