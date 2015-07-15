class PaymentsController < ApplicationController
  before_filter :set_subscription

  def details
    if @subscription.nil?
      redirect_to root_path
    else
      @signature = cooked_signature
      @merchant_id = merchant_id
    end
  end

  def status

  end

  private

  def set_subscription
    begin
      @subscription = current_user.company.subscriptions.last
    rescue
      nil
    end
  end

  def send_request
    RestClient.post 'http://xmpay.dev.keks-n.net/Pay',
      merchantId: merchant_id,
      price: @subscription.amount,
      currency: @subscription.currency,
      orderId: @subscription.id,
      recurring: @subscription.recurring,
      days: @subscription.days,
      sign: cooked_signature
  end

  def merchant_id
    6
  end

  def sharedsec
    "123321"
  end

  def payment_url
    "http://xmpay.dev.keks-n.net/Pay"
  end

  def cooked_signature
    Digest::SHA256.hexdigest("#{merchant_id}-#{@subscription.id}-#{@subscription.amount}-#{sharedsec}")
  end
end
