class RoomsController < ApplicationController
  before_action :auth_user

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
    if @room.save!
      redirect_to @room
    end
  end

  def start_game
    @room = Room.find_by_id(params[:id])
    unless @room.start?
      @bank = (1..36).to_a.sample(36)
      @room.player_1_cards = @bank.pop(5).to_s.chomp(']').delete '['
      @room.player_2_cards = @bank.pop(5).to_s.chomp(']').delete '['
      @room.player_3_cards = @bank.pop(5).to_s.chomp(']').delete '['
      @room.player_4_cards = @bank.pop(5).to_s.chomp(']').delete '['
      @room.bank = @bank.to_s.chomp(']').delete '['
      @room.start = true
      @room.save
    end
  end

  def move
    @room = Room.find_by_id(params[:id])
    @room.otboi = params[:card]
    if    @room.player_1 == current_user
          @room.player_1_cards.split(',').delete params[:card]
    elsif @room.player_2 == current_user
          @room.player_2_cards.split(',').delete params[:card]
    elsif @room.player_3 == current_user
          @room.player_3_cards.split(',').delete params[:card]
    elsif @room.player_4 == current_user
          @room.player_4_cards = @room.player_4_cards.split(',').delete_if {|x| x ==  params[:card] }
          @room.player_4_cards = @room.player_4_cards.to_s.chomp(']').delete '['
    end
    @room.save

    redirect_to :back
  end

  def auth_user
    unless current_user
      redirect_to new_user_session_path
    end
  end


  private

  def room_params
    params.require(:room).permit(:name)
  end

end
