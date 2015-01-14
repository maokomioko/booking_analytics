class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!, :ch_manager_present
  after_filter :flash_to_headers

  private

  def ch_manager_present
    if current_user && !current_user.wb_auth?
      redirect_to new_channel_manager_path unless controller_name == 'channel_manager'
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
