class MemoReplyChannel < ApplicationCable::Channel
  def subscribed
    room_name = params[:room]   
    stream_from "memo_channel_reply_#{room_name}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def self.speak(data)
    ActionCable.server.broadcast("memo_channel_reply_#{data['user_id']}", {message: data['message']})
  end
end
