class UserMailer < DefaultMailer
  def new_in_company(user_id)
    @user    = User.find(user_id)
    @company = @user.company

    emails = @company.users
                 .where(role: %w(admin manager))
                 .where.not(id: @user.id)
                 .pluck(:email)

    mail to: emails
  end
end