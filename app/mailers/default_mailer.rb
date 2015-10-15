class DefaultMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: 'mike@hotelcommander.net'
  layout 'email'
end
