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

  validates :login, :password, :lcode, :booking_id, :hotel_name,
            :non_refundable_pid, :default_pid, presence: true
  validate :hotel_existence
  validates_inclusion_of :connector_type, in: TYPES, allow_blank: true

  before_create :define_type, if: -> { type.nil? }
  before_create :setup_tarif_plans

  # stub
  def non_refundable_candidate
  end

  # stub
  def standart_rate_candidate
  end

  # stub
  def create_rooms
  end

  # stub
  def setup_room_prices(room_id, room_obj_id)
  end

  def setup_tarif_plans
    update_attributes(non_refundable_pid: non_refundable_candidate, default_pid: standart_rate_candidate)
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
        block.update_attribute(:default_price, block.price)
      end
    else
      new_prices = [custom_price]
      price_blocks.update_all(default_price: custom_price, locked: true)
    end

    price_blocks.map(&:date).each do |date|
      connector.set_plan_prices(non_refundable_pid, room_id, date, new_prices)
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

  private

  def define_type
    self.type = if connector_type.present?
                  'ChannelManager::' + connector_type.classify
                else
                  self.class.name
                end
  end
end
