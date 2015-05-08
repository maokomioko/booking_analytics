class ChannelManagerController < ApplicationController
  load_and_authorize_resource

  def new
    unless current_user.company.wb_auth?
      @wb = ChannelManager::Wubook.new
    else redirect_to calendar_index_path, notice: t('messages.cm_already_added')
    end
  end

  def create
    wb = ChannelManager::Wubook.new(wb_params)
    wb.company = current_user.company
    if wb.save && wubook_auth_state
      current_user.company.update_attribute(:wb_auth, true) unless current_user.company.wb_auth?
      redirect_to calendar_index_path
      flash[:success] = t('messages.cm_verified')
    else
      redirect_to new_channel_manager_path
      flash[:error] = t('messages.cm_verification_error')
    end
  end

  def edit
    @wb = ChannelManager::Wubook.find(params[:id])
  end

  def update
    wb = ChannelManager::Wubook.find(params[:id])

    if wb.update_attributes(wb_params)
      impressionist(wb)
      redirect_to calendar_index_path
      flash[:success] = t('messages.cm_update_failure')
    else
      redirect_to edit_channel_manager_path(wb.id)
      flash[:error] = t('messages.cm_update_error')
    end
  end

  def update_prices
    raise if params[:dates].blank?

    dates = params[:dates]
    dates.delete('')

    wba = wubook_for_company(params[:room_id])
    raise if wba.nil?

    if wba.apply_room_prices(params[:room_id], dates, params[:price])
      flash[:success] = t('messages.prices_updated')
      render json: { status: :ok }
    else
      raise
    end
  rescue Exception => e
    flash[:error] = t('messages.price_update_failed')
    render json: { status: :unprocessable_entity }
  end

  private

  def wubook_auth_state
    connector = WubookConnector.new(wb_params)
    connector.get_token.nil? ? false : true
  end

  def wubook_for_company(room_id)
    room = Room.find(room_id)
    room.wubook_auths.where(company: current_user.company).first
  rescue
    nil
  end

  def wb_params
    params.require(:channel_manager_wubook).permit(:login, :password, :lcode, :booking_id, :hotel_name)
  end
end
