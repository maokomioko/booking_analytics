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

class ChannelManager::Wubook < ChannelManager
  def connector
    WubookConnector.new({login: login, password: password, lcode: lcode})
  end
end
