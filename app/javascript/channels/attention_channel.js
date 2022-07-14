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
      location.reload()
    }
    // Called when there's incoming data on the websocket for this channel
  }
})
