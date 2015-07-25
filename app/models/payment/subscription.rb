# == Schema Information
#
# Table name: subscriptions
#
#  id           :integer          not null, primary key
#  amount       :float
#  currency     :string
#  days         :integer
#  state        :string
#  recurring    :boolean
#  company_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  xmpay_answer :string
#  extended_at  :datetime
#
# Indexes
#
#  index_subscriptions_on_company_id  (company_id)
#  index_subscriptions_on_recurring   (recurring)
#  index_subscriptions_on_state       (state)
#

class Payment::Subscription < ActiveRecord::Base
  belongs_to :company

  has_and_belongs_to_many :payment_items, join_table: "subscriptions_payment_items", class_name: "Payment::PaymentItem"
  accepts_nested_attributes_for :payment_items

  default_scope { order('updated_at DESC') }
  scope :actual, -> { where(state: 'payed', recurring: true) }
  scope :trial, -> {where(state: 'trial', recurring: false) }

  before_create :set_default_attributes

  STATES = %w(trial pending_payment payed cancelled)

  def active?
    case state
    when STATES[0], STATES[2]
      true
    else
      false
    end
  end

  private

  def set_default_attributes
    self.assign_attributes({currency: "EUR", state: STATES[0], days: 30})
  end
end
