# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel

  def subscribed
     #current_user.rooms.each do |room|
     #stream_from "room:#{room.id}"
       #end
    stream_from "room"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast "room_channel", message: data['message']
  end

  def move(data)
    alert("kryto")
  end

end
