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

  def update_signature
    amount = params[:amount]

    respond_to do |f|
      if amount.to_i > 0
        f.json { render json: { signature: cooked_signature(amount) } }
      else
        render nothing: true
      end
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

  def merchant_id
    6
  end

  def sharedsec
    "123321"
  end

  def payment_url
    "http://xmpay.dev.keks-n.net/Pay"
  end

  def cooked_signature(amount = nil)
    amount ||= @subscription.amount
    Digest::SHA256.hexdigest("#{merchant_id}-#{@subscription.id}-#{amount}-#{sharedsec}")
  end
end
