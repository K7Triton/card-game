class RoomsController < ApplicationController

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find_by_id(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.create(room_params)
    @room.user_id = current_user.id
    if @room.save
      redirect_to root_path
  end
end

  def start_game
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

end
