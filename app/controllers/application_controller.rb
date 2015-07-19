class ApplicationController < ActionController::Base
  include SubscriptionMethods

  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :globalize_session,
                :auth_user,
                :wizard_completed,
                :update_last_activity,
                :validate_subscription,
                unless: :devise_controller?

  after_action :flash_to_headers

  layout :layout_by_resource

  add_flash_types :warning, :success, :error

  private

  def layout_by_resource
    if devise_controller? &&
       !(controller_name == 'registrations' && action_name == 'edit') &&
       !(controller_name == 'invitations' && %w(new create).include?(action_name))
      'login'
    else
      'application'
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation,
               company_attributes: [:name, :reg_number, :reg_address])
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation,
               :avatar, :avatar_cache, :remove_avatar)
    end
  end

  def globalize_session
    Thread.current[:session] = session
  end

  def auth_user
    if !devise_controller? && !user_signed_in?
      respond_to do |f|
        f.json { render json: { error: t('errors.unauthorized') }, status: 401 }
        f.all { redirect_to [main_app, :new, :user, :session] and return }
      end
    end
  end

  def wizard_completed
    if !current_user.setup_completed? && controller_name != 'wizard'
      redirect_to [main_app, :wizard, :"step#{ current_user.setup_step }"] and return
    elsif current_user.setup_completed? && controller_name == 'wizard' && params[:step].present?
      redirect_to main_app.root_path and return
    end
  end

  def update_last_activity
    if current_user && current_user.company.present?
      current_user.company.update_column(:last_activity, Time.now.utc)
    end
  end

  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers['X-Message-Type'] = flash_type.to_s
    response.headers['X-Message-Html'] = view_context.render_flash.squish

    flash.discard
  end

  def flash_message
    [:error, :alert, :warning, :success, :notice].each do |type|
      return flash[type] unless flash[type].blank?
    end
    ''
  end

  def flash_type
    [:error, :alert, :warning, :success, :notice].each do |type|
      return type unless flash[type].blank?
    end
  end
end
