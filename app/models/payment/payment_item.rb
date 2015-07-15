# == Schema Information
#
# Table name: payment_items
#
#  id    :integer          not null, primary key
#  name  :string
#  price :float
#

class Payment::PaymentItem < ActiveRecord::Base
  has_and_belongs_to_many :subscriptions, join_table: "subscriptions_payment_items",
  class_name: "Payment::Subscription", dependent: :destroy

  accepts_nested_attributes_for :subscriptions

  TYPES = {
    overbooking: 10,
    rate_checker: 20,
    prediction: 30
  }

end
