import consumer from "channels/consumer"

consumer.subscriptions.create("AttentionChannel", {
  connected() {
    console.log("Connected to AttentionChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(message) {
    var divid = document.getElementById('attention');

    divid.innerHTML =
      "<p>" + message.message + "</p>";
    // Called when there's incoming data on the websocket for this channel
  }
});
