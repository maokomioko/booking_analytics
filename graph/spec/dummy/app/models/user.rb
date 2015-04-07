class User < ActiveRecord::Base
  def hotels
    Hotel.all
  end
end