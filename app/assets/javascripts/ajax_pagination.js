var AjaxPagination = {};
(function() {
  AjaxPagination.initializePager(container) {
    $(".pagination a").click("click", function() {
      $.getScript(this.href);
      return false;
    });
  }
})();
