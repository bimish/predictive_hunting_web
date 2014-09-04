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
