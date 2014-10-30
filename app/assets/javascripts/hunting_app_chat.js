(function() {

  function ChatPageScript() {

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

  }

  Scripts.Page.Chat = new ChatPageScript();
  // register the page initializer
  //Scripts.Common.pageInitialize('chat', Scripts.Page.Chat.initPage);
})();
