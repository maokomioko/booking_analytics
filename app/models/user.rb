# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
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
#  avatar                 :string
#  role                   :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#
# Indexes
#
#  index_users_on_company_id            (company_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  has_many :hotels, through: :channel_manager
  has_one :channel_manager, through: :company
  has_one :setting, through: :company
  has_many :actions

  belongs_to :company

  mount_uploader :avatar, AvatarUploader

  is_impressionable

  devise :invitable, :async, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  accepts_nested_attributes_for :company

  before_create :set_default_role
  after_invitation_accepted :set_company!

  after_update :trigger_notifications

  scope :related_to, Proc.new{ |owner|
    where("\"invited_by_id\" = :owner_id OR \"company_id\" = :owner_company_id",
          owner_id: owner.id,
          owner_company_id: owner.company_id)
  }

  delegate :setting_fallback, to: :company
  delegate :setup_step, :setup_completed?, to: :company, allow_nil: true

  def self.serialize_into_session(record)
    [record.id.to_s, record.authenticatable_salt]
  end

  def nickname
    email.split('@').try(:first) || ''
  end

  private

  def set_default_role
    self.role ||= 'manager'
  end

  def set_company!
    self.company_id = User.find(invited_by_id).company_id
    self.save
  end

  def trigger_notifications
    if previous_changes[:company_id].present? && previous_changes[:company_id].last.present?
      ActiveSupport::Notifications.instrument('user.new_in_company', user_id: id)
    end
  end
end
