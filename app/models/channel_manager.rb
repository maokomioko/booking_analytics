# == Schema Information
#
# Table name: channel_managers
#
#  id                 :integer          not null, primary key
#  login              :string
#  password           :string
#  lcode              :string
#  booking_id         :integer
#  hotel_name         :string
#  non_refundable_pid :integer
#  default_pid        :integer
#  company_id         :integer
#  type               :string           not null
#
# Indexes
#
#  index_channel_managers_on_company_id  (company_id)
#

class ChannelManager < ActiveRecord::Base
  TYPES = %w(wubook previo).freeze

  belongs_to :company
  belongs_to :hotel, foreign_key: :booking_id, primary_key: :booking_id

  is_impressionable

  attr_accessor :connector_type

  validates :login, :password, :lcode, :booking_id, :hotel_name, presence: true
  validates :non_refundable_pid, :default_pid, presence: true, on: :update

  validate :hotel_existence
  validates_inclusion_of :connector_type, in: TYPES, allow_blank: true

  # stub
  def create_rooms
  end

  # stub
  def setup_room_prices(room_id, room_obj_id)
  end

  def list_plans
    plans = connector.get_plans.each
    if connector_type.include?('wubook')
      plans.collect{|x| [x['name'], x['id']]}
    else
      name = Proc.new do |plan|
        "#{ plan['priId'] }, #{ plan['from'] } - #{ plan['to'] }"
      end

      plans.collect{|x| [name.call(x), x['priId']]}
    end
  end

  def connector_room_id_key
    'booking_id'
  end

  def apply_room_prices(room_id, dates, custom_price = nil)
    room = Room.find(room_id)

    if dates.size > 1
      price_blocks = room.room_prices.within_dates(dates)
    else
      price_blocks = room.room_prices.where(date: dates[0])
    end

    if ['', nil].include? custom_price
      new_prices = price_blocks.map(&:price)
      price_blocks.each do |block|
        block.update_attribute(:default_price, block.price) if block.price.present?
      end
    else
      new_prices = [custom_price]
      price_blocks.update_all(default_price_cents: custom_price.to_money('EUR').cents, locked: true)
    end

    price_blocks.map(&:date).each do |date|
      connector.set_plan_prices(non_refundable_pid, room.send(connector_room_id_key), date, new_prices)
    end

    price_blocks.update_all(enabled: true)
  end

  def hotel_existence
    unless Hotel.find_by_booking_id(booking_id).present?
      errors.add(:booking_id, I18n.t('errors.booking_id'))
    end
  end

  def connector_type
    if type.nil?
      @connector_type
    else
      @connector_type || self.class.name.split('::').last.downcase
    end
  end

  # create rooms and fill initial prices
  def sync_rooms
    create_rooms if hotel.rooms.size.zero?
    hotel.rooms.real.each do |room|
      room_id = room.send(connector_room_id_key)
      setup_room_prices(room_id, room.id)
      room.fill_prices
    end
  end

  def self.define_type(connector_type)
    if connector_type.present?
      'ChannelManager::' + connector_type.classify
    else
      self.name
    end
  end
end
