class Room < ActiveRecord::Base
  scope :with_facilities, -> (ids){
    includes(:facilities).where(room_facilities: { id: ids })
        .select{|h| (ids - h.facilities.map(&:id)).size.zero? }
  }

  belongs_to :hotel
  has_and_belongs_to_many :facilities, class_name: 'RoomFacility' # counter as PG trigger
  has_one :bedding
end
