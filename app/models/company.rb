class Company < ActiveRecord::Base
  has_many :users
  has_many :wubook_auth, dependent: :destroy

  belongs_to :owner, class_name: 'User'
end