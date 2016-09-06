class RoomsController < ApplicationController
  before_action :auth_user

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find_by_id(params[:id])
      unless @room.start?
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
    @room_user = @room.room_users.where(user_id: current_user.id).first_or_create!
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


# Ф-ція стартує гру і роздає карти гравцям.
# route get 'rooms/:id/start', to: 'rooms#start_game', as: 'start_game'
  def start_game
    @room = Room.find_by_id(params[:id])
    unless @room.start?
      @bank = (1..36).to_a.sample(36)
      if @room.player_1.present?
        @room.player_1_cards = @bank.pop(5)
      end
      if @room.player_2.present?
        @room.player_2_cards = @bank.pop(5)
      end
      if @room.player_3.present?
        @room.player_3_cards = @bank.pop(5)
      end
      if @room.player_4.present?
        @room.player_4_cards = @bank.pop(5)
      end
      @room.bank = @bank
      @room.who_move = @room.user_id
      @room.start = true
      @room.save
    end
  end

# Ф-ція ходу гравця.
# route  get 'rooms/:id/move/:card', to: 'rooms#move'

  def move
    @room = Room.find_by_id(params[:id])
    if @room.who_move == current_user.id
      rules
      @room.otboi.push(params[:card].to_i)
      player_cards.delete_if{ |i| i == params[:card].to_i }
      @room.save
      ActionCable.server.broadcast 'room:'+@room.id.to_s,
                                            move: @room
      head :ok
    else
      #flash[:notice] = 'Wait when player move'
      #redirect_back({fallback_location: request.referer}, flash[:notice] = 'Wait when player move')
    end

  end

# Ф-ція кінець ходу.
# a - який гравець буде ходити наступним. Наприклад 1 означає що буде ходити наступний гравець ( тому а=1 по дефолту)
# Наприклад якщо наступний гравець має пропустити ход то ф-ція викликається з а=2 ( end_turn(2) ) i т.д
# route  get 'rooms/:id/start/end_turn', to: 'rooms#end_turn', as: 'end_turn'
  def end_turn (a=1)
    @room = Room.find_by_id(params[:id])
    players = [@room.player_1_id, @room.player_2_id, @room.player_3_id, @room.player_4_id].compact
     if @room.who_move == current_user.id
          z = players.find_index(current_user.id)
          @room.who_move = if players[z+a] != nil
                             players[z+a]
                           else
                             players[a-1]
                           end
          @room.save
          flash[:notice] = 'Now ' + User.find(@room.who_move).email + ' move'
          ActionCable.server.broadcast 'room:'+@room.id.to_s,
                                           move: @room
          head :ok

     else
       false
     end

  end
# Ф-ція яка повертає карти гравця.
  def player_cards
    if    @room.player_1 == current_user
            @room.player_1_cards
    elsif @room.player_2 == current_user
            @room.player_2_cards
    elsif @room.player_3 == current_user
            @room.player_3_cards
    elsif @room.player_4 == current_user
            @room.player_4_cards
    end
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
    # Якщо юзер поставив туз
    if [33,34,35,36].include? params[:card].to_i
        b = [33,34,35,36].delete_if{ |i| i == params[:card].to_i }
        @player_tuz = player_cards & b
        if @player_tuz.empty?
          end_turn(2)
        else
          puts "User have more tuz"
        end
    end
    if [21,22,23,24].include? params[:card].to_i
      flash[:notice] = 'Plase choose a suite'
    end
    if [5,6,7,8].include? params[:card].to_i
      flash[:notice] = 'Take card, if not 7 , take second card and make a turn'
    end
    if [1,2,3,4].include? params[:card].to_i
      flash[:notice] = 'Overlap your card'
    end
  end
# Ф-ція взяти карту з банка.
# route  get 'rooms/:id/get_card', to: 'rooms#get_card'
  def get_card
    @room = Room.find_by_id(params[:id])
    if  @room.who_move == current_user.id
      if @room.bank.present?
        player_cards.push(@room.bank.pop(1)[0])
      end

      peretysyvatu
      @room.save
      ActionCable.server.broadcast 'room:'+@room.id.to_s,
                                   move: @room

      head :ok
    else
      #redirect_to :back
      flash.now[:notice] = 'Wait when player move'
    end
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
