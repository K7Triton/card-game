module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = User.find(1)
    end

    protected
    def find_verified_user
      if current_user = current_user
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
