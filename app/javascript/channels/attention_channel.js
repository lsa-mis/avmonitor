import consumer from "channels/consumer"

consumer.subscriptions.create("AttentionChannel", {
  connected() {
    console.log("Connected to AttentionChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(message) {

    if (window.location.href.includes("dashboard")) {

      // if (message.message.length > 1) {
      location.reload()
    }

    var divid = document.getElementById('attention_message');

    divid.innerHTML =
      "<p>" + message.message + "</p>";
    // Called when there's incoming data on the websocket for this channel
  }
})
