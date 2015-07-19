module SubscriptionMethods
  extend ActiveSupport::Concern

  def validate_subscription
    subscription = current_user.company.subscriptions.try(:first)

    if !subscription.present?
      set_subscription
    elsif !subscription.valid?
      redirect_to [:payments, :details] unless controller_name == 'payments'
    end
  end

  private

  def set_subscription
    subscription = current_user.company.subscriptions.new

      types = Payment::PaymentItem::TYPES.keys
      prices = Payment::PaymentItem::TYPES.values
      types.each_with_index do |type, i|
        item = Payment::PaymentItem.find_or_initialize_by(name: type, price: prices[i])

        subscription.payment_items << item
      end

      subscription.amount = prices.inject(:+)
      subscription.save
  end
end
