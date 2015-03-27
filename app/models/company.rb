# == Schema Information
#
# Table name: companies
#
#  id           :integer          not null, primary key
#  name         :string
#  wb_auth      :boolean          default(FALSE)
#  owner_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  logo         :string
#  reg_number   :string
#  reg_address  :string
#  bank_name    :string
#  bank_code    :string
#  bank_account :string
#

class Company < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :channel_managers, dependent: :destroy

  has_one :setting

  belongs_to :owner, class_name: 'User'

  mount_uploader :logo, AvatarUploader

  before_create :build_default_setting

  validates_presence_of :name
  validates_numericality_of :bank_code, :bank_account, only_integer: true, allow_blank: true

  private

  def build_default_setting
    build_setting(Setting.default_attributes)
  end
end
