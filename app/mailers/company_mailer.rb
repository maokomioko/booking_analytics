class CompanyMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: 'no-reply@hotelcommander.net'

  layout 'email'

  def weekly_report(company_id, reciever_ids)
    emails   = User.where(id: reciever_ids).pluck(:email)
    @company = Company.find(company_id)

    mail to: emails
  end
end