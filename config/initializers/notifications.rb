#
# Event that triggers when user's company_id has changed
#
ActiveSupport::Notifications.subscribe 'user.new_in_company' do |name, start, finish, id, payload|
  UserMailer.delay.new_in_company payload[:user_id]
end