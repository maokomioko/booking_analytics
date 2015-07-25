class SubscriptionsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false

  recurrence { daily }

  def perform
    Company.find_each do |company|
      subscription = company.subscriptions.try(:first)

      if subscription.present?
        if subscription.extended_at
          termination_date = subscription.extended_at + subscription.days
        else
          termination_date = subscription.created_at + subscription.days
        end

        if termination_date <= DateTime.now && %w('trial payed').include?(subscription.state)
          subscription.update_attribute(:state, 'pending_payment')
        end
      end
    end
  end

end
