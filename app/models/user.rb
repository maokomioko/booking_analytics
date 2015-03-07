class User < ActiveRecord::Base
  has_many :wubook_auth, dependent: :destroy
  has_many :hotels, through: :wubook_auth

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.serialize_into_session(record)
    [record.id.to_s, record.authenticatable_salt]
  end
end
