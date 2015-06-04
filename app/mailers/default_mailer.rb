class DefaultMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: 'no-reply@hotelcommander.net'

  layout 'email'
end