# == Schema Information
#
# Table name: companies
#
#  id            :integer          not null, primary key
#  name          :string
#  owner_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#  logo          :string
#  reg_number    :string
#  reg_address   :string
#  bank_name     :string
#  bank_code     :string
#  bank_account  :string
#  last_activity :datetime
#

class Company < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_one :channel_manager, dependent: :destroy
  has_many :hotels, through: :channel_manager

  has_many :settings

  belongs_to :owner, class_name: 'User'

  mount_uploader :logo, AvatarUploader

  validates_presence_of :name
  validates :bank_code, :bank_account, numericality: true, allow_blank: true
end
