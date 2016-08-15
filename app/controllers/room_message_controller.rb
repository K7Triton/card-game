class RoomMessageController < ApplicationController
  before_action :auth_user

  def index
    @messages = RoomMessage.all
  end

  def new

  end

  def create
    @user = User.find_by(:room_id current_user.id)
    @message = RoomMessage.new(message_params)
    if @message.save
      redirect_to :back
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id)
  end
end
