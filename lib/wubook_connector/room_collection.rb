class WubookConnector
  class RoomCollection
    attr_accessor :rooms

    def initialize(hash = {})
      @rooms = hash
    end

    def name_id_mapping
      @rooms.collect do |x|
        [x['name'], x['id']]
      end
    end
  end
end