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

  def destroy
    @room = Room.find_by_id(params[:id])
    @room.destroy
    redirect_to :back
  end

  def start_game
    @room = Room.find_by_id(params[:id])
    unless @room.start?
      @bank = (1..36).to_a.sample(36)
      @room.player_1_cards = @bank.pop(5)
      @room.player_2_cards = @bank.pop(5)
      @room.player_3_cards = @bank.pop(5)
      @room.player_4_cards = @bank.pop(5)
      @room.bank = @bank
      @room.start = true
      @room.save
    end
  end

  def move
    @room = Room.find_by_id(params[:id])
    rules
    @room.otboi.push(params[:card].to_i)
    if    @room.player_1 == current_user
          @room.player_1_cards =  @room.player_1_cards.delete_if{ |i| i == params[:card].to_i }
    elsif @room.player_2 == current_user
          @room.player_2_cards =  @room.player_2_cards.delete_if{ |i| i == params[:card].to_i }
    elsif @room.player_3 == current_user
          @room.player_3_cards =  @room.player_3_cards.delete_if{ |i| i == params[:card].to_i }
    elsif @room.player_4 == current_user
          @room.player_4_cards =  @room.player_4_cards.delete_if{ |i| i == params[:card].to_i }
    end
    @room.save

    redirect_to :back
  end


  def auth_user
    unless current_user
      redirect_to new_user_session_path
    end
  end

  def rules
    if [9,10,11,12].include? params[:card].to_i
    flash[:notice] = 'Card taken'
  end
    if [33,34,35,36].include? params[:card].to_i
    flash[:notice] = 'You miss a turn'
  end
    if [21,22,23,24].include? params[:card].to_i
    flash[:notice] = 'Plase choose a suite'
  end
    if [5,6,7,8].include? params[:card].to_i
    flash[:notice] = 'Take card, if not 7 , take second card and make a turn'
  end
    if [1,2,3,4].include? params[:card].to_i
    flash[:notice] = 'Ovelap your card'
  end
end

  def get_card
    @room = Room.find_by_id(params[:id])
    if    @room.player_1 == current_user
          @room.player_1_cards =  @room.player_1_cards + @room.bank.pop(1)
    elsif @room.player_2 == current_user
          @room.player_2_cards =  @room.player_2_cards.delete_if{ |i| i == params[:card].to_i }
    elsif @room.player_3 == current_user
          @room.player_3_cards =  @room.player_3_cards.delete_if{ |i| i == params[:card].to_i }
    elsif @room.player_4 == current_user
          @room.player_4_cards =  @room.player_4_cards.delete_if{ |i| i == params[:card].to_i }
    end
    peretysyvatu
    @room.save
    redirect_to :back
  end

  def peretysyvatu
    if @room.bank.empty?
       @room.bank = @room.otboi.shuffle!
       @room.otboi = nil
  end
end


  private

  def room_params
    params.require(:room).permit(:name)
  end

end
