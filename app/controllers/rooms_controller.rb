class RoomsController < ApplicationController

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find_by_id(params[:id])
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
<<<<<<< HEAD
    @cards = Card.all.to_a
=======
    @cards = Card.all
>>>>>>> b319a67fc81f3c57e17cc593e5868b0c7b0eb189
    @room = Room.find_by_id(params[:id])
    @room.player_1_cards = @cards.last(5)
    @cards.pop(5)
    @room.player_2_cards = @cards.last(5)
    @cards.pop(5)
    @room.player_3_cards = @cards.last(5)
    @cards.pop(5)
    @room.player_4_cards = @cards.last(5)
    @cards.pop(5)
    @cards.save
    @room.save
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

end
