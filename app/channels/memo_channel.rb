class MemoChannel < ApplicationCable::Channel
  def subscribed
    room_name = params[:room]   
    stream_from "memo_channel_#{room_name}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def self.speak(data)
    ActionCable.server.broadcast("memo_channel_#{data['user_id']}", {message: data['message']})
  end
end
