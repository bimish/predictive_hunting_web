function TableHelper(table) {

  var tableSelector = table;
  var $table = null;
  var rowInitializers = null;

  function $getTable() {
    if ($table == null) $table = $(tableSelector);
    return $table;
  }
  function $getRow(id) {
    return $getTable().find('tbody tr[data-id="' + id + '"]');
  }
  function notifyInitializers(row) {
    if (rowInitializers != null) {
      for (var i = 0; i < rowInitializers.length; i++)
        rowInitializers[i](row);
    }
  }
  this.initRow = function(handler) {
    if (rowInitializers == null) rowInitializers = [];
    rowInitializers.push(handler);
  };
  this.add = function(id, html) {
    var newRow = $getTable().find('tbody').append(html);
    notifyInitializers($getRow(id));
  };
  this.update = function(id, html) {
    var updatedRow = $getRow(id).replaceWith(html);
    notifyInitializers($getRow(id));
  };
  this.delete = function(id) {
    $getRow(id).remove();
  };
}
