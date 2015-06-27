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

class ChannelManager::Empty < ChannelManager
  def connector
    EmptyConnector.new
  end

  def create_rooms
    true
  end

  def setup_room_prices(room_id, room_obj_id)
    true
  end

  def list_plans
    ['', '']
  end

  def apply_room_prices(room_id, dates, custom_price = nil)
    true
  end

  def sync_rooms
    true
  end
end
