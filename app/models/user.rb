# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  company_id             :integer
#

class User < ActiveRecord::Base
  has_many :hotels, through: :wubook_auth
  has_many :wubook_auth, through: :company

  belongs_to :company

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  accepts_nested_attributes_for :company

  def self.serialize_into_session(record)
    [record.id.to_s, record.authenticatable_salt]
  end

  def nickname
    email.split('@').try(:first) || ''
  end
end
