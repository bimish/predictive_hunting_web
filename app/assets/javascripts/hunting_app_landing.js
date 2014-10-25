Scripts.Page.Landing = function() {

  this.initPage = function() {
    var activePage = $.mobile.pageContainer.pagecontainer("getActivePage");
    $('#selected-plot', activePage).change(
      function (event) {
        var plotId = $(event.target).val();
        window.location.replace('/hunting_app/' + plotId);
        //$.mobile.changePage('/hunting_app/' + plotId, { reloadPage : true } );
      }
    );
  };
  return this;
}();

// register the page initializer
Scripts.Common.pageShow('landing', Scripts.Page.Landing.initPage);
