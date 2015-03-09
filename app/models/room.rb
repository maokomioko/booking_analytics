class Room < ActiveRecord::Base
  include PriceMaker::Wubook

  scope :with_facilities, -> (ids){
    includes(:facilities).where(room_facilities: { id: ids })
        .select{|h| (ids - h.facilities.map(&:id)).size.zero? }
  }

  belongs_to :hotel

  has_many :room_prices, dependent: :destroy

  has_and_belongs_to_many :facilities, class_name: 'RoomFacility' # counter as PG trigger
  has_and_belongs_to_many :wubook_auths

  has_one :bedding

  monetize :min_price_cents
  monetize :max_price_cents
end
