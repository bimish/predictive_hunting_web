function AjaxNotifications() {
  var _listeners = [];
  this.notify = function(action, json) {
    for (var i = 0; i < _listeners.length; i++) {
      var listener = _listeners[i];
      if ((listener.action == null) || (listener.action == action))
        listener.handler(action, json);
    }
  }
  this.addListener = function(action, handler) {
    _listeners.push( { action: action, handler: handler } );
  }
  return this;
}
