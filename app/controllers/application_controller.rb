class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!, :ch_manager_present

  private

  def ch_manager_present
    if current_user && !current_user.wb_auth?
      redirect_to new_channel_manager_path unless request.fullpath == new_channel_manager_path
    end
  end
end
