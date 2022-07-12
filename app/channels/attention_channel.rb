class AttentionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "attention_channel"
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
