class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :auth_user,
                :company_present,
                :check_step_1,
                :check_step_2,
                :check_step_3,
                :check_step_4,
                :check_step_5,
                :update_last_activity,
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

  def auth_user
    if !devise_controller? && !user_signed_in?
      respond_to do |f|
        f.json { render json: { error: t('errors.unauthorized') }, status: 401 }
        f.all { redirect_to [main_app, :new, :user, :session] }
      end
    end
  end

  def check_step_1
    unless current_user.channel_manager.present?
      redirect_to [:wizard, :step1] and return
    end
  end

  def check_step_2
    unless current_user.channel_manager.login.present?
      redirect_to [:wizard, :step2] and return
    end
  end

  def check_step_3
    unless current_user.channel_manager.default_pid.present?
      redirect_to [:wizard, :step3] and return
    end
  end

  def check_step_4
    ids = current_user.channel_manager.hotel.rooms.pluck(:wubook_id, :previo_id)

    # if none of the rooms have CM_ID
    if ids.flatten.compact.size.zero?
      redirect_to [:wizard, :step4] and return
    end
  end

  def check_step_5
    if current_user.channel_manager.hotel.related.count.zero?
      redirect_to [:wizard, :step5] and return
    end
  end

  def company_present
    if current_user && !current_user.company.present?
      # respond_to do |f|
      #   f.json { render json: { error: t('errors.no_company') }, status: 403 }
      #   f.all { redirect_to [main_app, :new, :company] }
      # end
      respond_to do |f|
        f.all {redirect_to "http://google.com"}
      end
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
