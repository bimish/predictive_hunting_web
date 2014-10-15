Scripts.Page.Chat = function() {

  this.initPage = function() {

  };

  this.refreshChat = function() {
    $.getScript("/hunting_app/" + g_huntingPlotId + "/chat_refresh/" + this.getLastPostId() + ".js") ;
  };

  this.addFeedItems = function(itemsHtml) {
    $('#chat-feed').prepend(itemsHtml);
    $('#chat-feed').listview('refresh');
  }

  this.getLastPostId = function() {
    return $('#chat-feed li').first().data("id");
  }

  return this;
}();

// register the page initializer
Scripts.Common.pageInit('chat', Scripts.Page.Chat.initPage);
