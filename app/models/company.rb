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
  has_many :users
  has_many :channel_managers, dependent: :destroy

  belongs_to :owner, class_name: 'User'
end
