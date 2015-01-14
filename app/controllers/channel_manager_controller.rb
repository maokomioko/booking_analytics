class ChannelManagerController < ApplicationController
  def new
    unless current_user.wb_auth?
      @wb = WubookAuth.new
    else redirect_to calendar_index_path, notice: t('messages.cm_already_added')
    end
  end

  def create
    wb = WubookAuth.new(wb_params)
    wb.user_id = current_user.id
    if wb.save && wubook_auth == true
      current_user.update_attribute(:wb_auth, true) unless current_user.wb_auth?
      redirect_to calendar_index_path
      flash[:success] = t('messages.cm_verified')
    else
      redirect_to new_channel_manager_path
      flash[:error] = t('messages.cm_verification_error')
    end
  end

  private

  def wubook_auth
    connector = WubookConnector.new(wb_params)
    connector.get_token.nil? ? false : true
  end

  def wb_params
    params.require(:wubook_auth).permit(:login, :password, :lcode)
  end
end
