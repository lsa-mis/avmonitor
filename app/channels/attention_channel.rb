class AttentionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "attention_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
