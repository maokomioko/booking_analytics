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
