class InvitationsController < Devise::InvitationsController
  before_filter :check_ability, only: [:new, :create]

  def new
    redirect_to company_users_path
  end

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
      if self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, email: success.to_sentence
      end

      unless request.xhr?
        respond_with resource, :location => after_invite_path_for(current_inviter)
      end
    else
      set_flash_message :error, :error_send_instructions, email: errors.to_sentence
      set_flash_message :norice, :send_instructions, email: success.to_sentence if success.length > 0

      resource.email = errors.join(',')

      unless request.xhr?
        respond_with_navigational(resource) { render :new }
      end
    end
  end

  protected

  def check_ability
    authorize! :invite, resource_class
  end

  def invite_resource(email = nil, &block)
    resource_class.invite!({ email: email, role: 'client' }, current_inviter, &block)
  end
end
