class InvitationsController < Devise::InvitationsController
  before_filter :check_ability, only: [:new, :create]

  def create
    emails = invite_params[:email].split(',')
    errors  = []
    success = []
    resource_invited = !emails.length.zero?

    emails.each do |email|
      self.resource = invite_resource(email)

      if resource.errors.empty?
        success << email
      else
        resource_invited = false
        errors << email
      end
    end

    yield resource if block_given?

    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, email: success.to_sentence
      end
      respond_with resource, :location => after_invite_path_for(current_inviter)
    else
      set_flash_message :error, :error_send_instructions, email: errors.to_sentence
      set_flash_message :norice, :send_instructions, email: success.to_sentence if success.length > 0

      resource.email = errors.join(',')

      respond_with_navigational(resource) { render :new }
    end
  end

  protected

  def check_ability
    authorize! :invite, resource_class
  end

  def invite_resource(email = nil, &block)
    # @user = User.find_by(email: email)
    # # @user is an instance or nil
    # if @user && @user.email != current_user.email
    #   # invite! instance method returns a Mail::Message instance
    #   @user.invite!(current_user)
    #   # return the user instance to match expected return type
    #   @user
    # else
    #   # invite! class method returns invitable var, which is a User instance
    #   resource_class.invite!({ email: email, role: 'client' }, current_inviter, &block)
    # end
    resource_class.invite!({ email: email, role: 'client' }, current_inviter, &block)
  end
end
