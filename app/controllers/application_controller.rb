class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :auth_user, :company_present, :ch_manager_present
  after_filter :flash_to_headers

  def no_company
  end

  private

  def auth_user
    if !devise_controller? && !user_signed_in?
      respond_to do |f|
        f.json { render json: { error: t('errors.unauthorized') }, status: 401 }
        f.all { redirect_to [main_app, :new, :user, :session] }
      end
    end
  end

  def company_present
    if current_user && !current_user.company.present?
      respond_to do |f|
        f.json { render json: { error: t('errors.no_company') }, status: 403 }
        f.all { redirect_to [main_app, :no_company] unless action_name == 'no_company' }
      end
    end
  end

  def ch_manager_present
    if current_user && current_user.company.present? && !current_user.company.wb_auth?
      respond_to do |f|
        f.json { render json: { error: t('errors.no_ch_manager') }, status: 403 }
        f.all { redirect_to main_app.new_channel_manager_path unless controller_name == 'channel_manager' }
      end
    end
  end

  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers["X-Message-Type"] = flash_type.to_s

    flash.discard
  end

  def flash_message
    [:error, :warning, :success, :notice].each do |type|
      return flash[type] unless flash[type].blank?
    end
    return ''
  end

  def flash_type
    [:error, :warning, :success, :notice].each do |type|
      return type unless flash[type].blank?
    end
  end
end
