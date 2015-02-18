class Room < ActiveRecord::Base
  scope :with_facilities, -> (ids){
    includes(:facilities).where(room_facilities: { id: ids })
        .select{|h| (ids - h.facilities.map(&:id)).size.zero? }
  }

  belongs_to :hotel
  has_and_belongs_to_many :facilities, class_name: 'RoomFacility' # counter as PG trigger
  has_one :bedding

  class << self
    def remap_with_ids
      arr = []

      Room.each do |room|
        arr << room.room_id
      end

      arr.each do |arr_el|
        room = Room.find_by(room_id: arr_el)
        up_room = Room.new({
          room_id: arr_el,
          facilities: room.facilities,
          max_persons: room.max_persons,
          roomtype: room.roomtype,
          max_price: room.max_price,
          min_price: room.min_price})
        up_room.save!
        unless room.bedding.nil?
          bedding = Bedding.new

          room.bedding.beds.each do |bed|
            bedding.beds << bed
          end
          up_room.bedding = bedding
          up_room.bedding.save!
        end

        room.destroy!
      end
    end
  end
end
