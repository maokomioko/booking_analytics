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

  def edit
    @wb = WubookAuth.find(params[:id])
  end

  def update_prices
    unless params[:dates].blank?
      dates = params[:dates]
      dates.delete("")

      wba = wubook_for_user(params[:room_id])
      unless wba.nil?
        if wba.apply_room_prices(params[:room_id], dates, params[:price])
          flash[:success] = t('messages.prices_updated')
          render json: {status: :ok}
        else
          flash[:error] = t('messages.price_update_failed')
          render json: {status: :unprocessable_entity}
        end
      end
    end
  end

  private

  def wubook_auth
    connector = WubookConnector.new(wb_params)
    connector.get_token.nil? ? false : true
  end

  def wubook_for_user(room_id)
    begin
      room = Wubook::Room.find_by(room_id: params[:room_id])
      room.wubook_auth
    rescue
      nil
    end
  end

  def wb_params
    params.require(:wubook_auth).permit(:login, :password, :lcode, :booking_id, :hotel_name)
  end
end
