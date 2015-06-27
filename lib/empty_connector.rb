require 'abstract_connector'

class EmptyConnector < AbstractConnector
  def initialize
  end

  def get_rooms
    RoomCollection.new
  end

  def get_plans
    true
  end

  def get_plan_prices(a = nil, b = nil)
    true
  end

  def set_plan_prices(a, b, c, d)
    true
  end

  def get_reservations
    []
  end

  class RoomCollection
    def name_id_mapping
      [['', '']]
    end
  end
end
