class RoomsController < ApplicationController

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find_by_id(params[:id])
    unless [@room.player_1_id, @room.player_2_id, @room.player_3_id, @room.player_4_id].include? current_user.id
      if @room.player_1_id == nil
        @room.update_attribute(:player_1_id, current_user.id)
      elsif @room.player_2_id == nil
        @room.update_attribute(:player_2_id, current_user.id)
      elsif @room.player_3_id == nil
        @room.update_attribute(:player_3_id, current_user.id)
      else
        @room.update_attribute(:player_4_id, current_user.id)
      end
    end

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
    @room = Room.find_by_id(params[:id])
    @bank = (1..36).to_a
    @room.player_1_cards = @bank.pop(5)
    @room.player_2_cards = @bank.pop(5)
    @room.player_3_cards = @bank.pop(5)
    @room.player_4_cards = @bank.pop(5)
    @room.bank = @bank.to_s
    @room.save
  end



  private

  def room_params
    params.require(:room).permit(:name)
  end

end
