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

  def modify_items
    amount = params[:amount]
    payment_item = Payment::PaymentItem.find_by(name: params[:item_name])

    if amount.to_i > 0 && payment_item.present?
      @subscription.update_attribute(:amount, amount)
      if params[:action_name] == 'add'
        unless @subscription.payment_items.include?(payment_item)
          @subscription.payment_items << payment_item
        end
      else
        @subscription.payment_items.delete(payment_item)
      end

      render json: { signature: cooked_signature(amount) }
    else
      render nothing: true
    end
  end

  def transaction_result

  end

  def update_status
    if params[:status] = 'success' && @subscription.present?
      @subscription.update_attributes(state: 'success', xmpay_answer: params[:transaction], extended_at: DateTime.now)
    else
      render text: "Subscription not found", status: 404
    end
  end

  private

  def set_subscription
    @subscription = begin
      if params[:orderId].present?
        Payment::Subscription.find(params[:orderId])
      else
        current_user.company.subscriptions.first
      end
    rescue
      nil
    end
  end

  def merchant_id
    XMPAY_CONFIG['merchant_id']
  end

  def sharedsec
    XMPAY_CONFIG['sharedsec']
  end

  def payment_url
    XMPAY_CONFIG['payment_url']
  end

  def cooked_signature(amount = nil)
    amount ||= @subscription.amount
    Digest::SHA256.hexdigest("#{merchant_id}-#{@subscription.id}-#{amount}-#{sharedsec}")
  end
end
