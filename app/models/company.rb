# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string
#  wb_auth    :boolean          default(FALSE)
#  owner_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Company < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :channel_managers, dependent: :destroy

  has_one :setting

  belongs_to :owner, class_name: 'User'

  before_create :build_default_setting

  private

  def build_default_setting
    build_setting(Setting.default_attributes)
  end
end
