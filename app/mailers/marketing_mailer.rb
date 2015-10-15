class MarketingMailer < DefaultMailer
  def hc_curiosity(hotel, emails)
    subject = "Test email"
    @hotel = hotel
    mail(to: emails, subject: subject) do |format|
      format.html
    end
  end
end
