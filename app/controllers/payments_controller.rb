class PaymentsController < ApplicationController
  require 'rest-client'

  before_filter :set_subscription

  def pay
    send_request
  end

  private

  def set_subscription
    @subscription = Payment::Subscription.find(params[:id])
  end

  def send_request
    RestClient.get payment_url, {params: {
      merchantId: merchant_id,
      productPrice: @subscription.amount,
      currency: @subscription.currency,
      orderId: @subscription.id,
      recurring: @subscription.recurring,
      sign: cooked_signature}
    }
  end

  def merchant_id
    123
  end

  def sharedsec
    "lorem-ipsum"
  end

  def payment_url
    "http://xmpay.dev.keks-n.net/Pay"
  end

  def cooked_signature
    Digest::SHA256.digest("#{merchant_id}-#{@subscription.id}-#{@subscription.amount}-#{sharedsec}")
  end
end
