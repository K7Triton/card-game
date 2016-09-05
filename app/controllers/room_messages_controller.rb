class RoomMessagesController < ApplicationController
  before_action :auth_user

  def index
    @messages = RoomMessage.all
  end

  def new
    @message = RoomMessage.new
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.room_messages.create(message_params)
    @message.room_id = params[:room_id]
    @message.user_id = current_user.id
    if @message.save!
      ActionCable.server.broadcast 'room:'+@room.id.to_s,
                                   message: @message.content,
                                   user: @message.user
      head :ok
    end
  end

  def auth_user
    unless current_user
      redirect_to new_user_session_path
    end
  end

  private

  def message_params
    params.require(:room_message).permit(:content)
  end
end
