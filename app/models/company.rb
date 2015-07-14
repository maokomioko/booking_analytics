# == Schema Information
#
# Table name: companies
#
#  id            :integer          not null, primary key
#  name          :string
#  owner_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#  last_activity :datetime
#  setup_step    :integer          default(1)
#  reg_number    :string
#  reg_address   :string
#

class Company < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :subscriptions, class_name: 'Payment::Subscription'

  has_one :channel_manager, dependent: :destroy
  has_one :hotel, through: :channel_manager
  has_one :setting

  belongs_to :owner, class_name: 'User'

  validates_presence_of :name

  def setup_completed?
    setup_step == 6 # last step + 1
  end

  def setting_fallback
    if setting.present?
      setting
    else
      create_setting!(DefaultSetting.for_company(self))
      setting
    end
  end
end
