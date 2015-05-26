class ChannelManagerController < ApplicationController
  load_and_authorize_resource
  before_filter :set_channel_manager, only: [:edit, :update]

  def new
    unless current_user.channel_manager
      @channel_manager = ChannelManager.new
    end
  end

  def create
    @channel_manager = ChannelManager.new(channel_manager_params)
    @channel_manager.company = current_user.company

    if @channel_manager.save && wubook_auth_state
      redirect_to match_plans_channel_manager_path(id: @channel_manager.id)
    else
      flash[:error] = t('messages.cm_verification_error')
      flash[:warning] = @channel_manager.errors.full_messages.to_sentence
      render :new
    end
  end

  def match_plans
  end

  def edit
  end

  def update
    # STI fix
    @channel_manager = @channel_manager.becomes!(channel_manager_params[:type].constantize)

    begin
      if @channel_manager.update_attributes(channel_manager_params)
        impressionist(@channel_manager)
        redirect_to settings_index_path, flash: { success: t('messages.cm_verified') }
      else
        redirect_to edit_channel_manager_path(@channel_manager.id), flash: { error: t('messages.cm_update_error') }
      end
    rescue
      redirect_to edit_channel_manager_path(@channel_manager.id), flash: { error: t('messages.cm_empty_tarif') }
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

  def set_channel_manager
    begin
      @channel_manager = ChannelManager.find(params[:id])
    rescue
      redirect_to new_channel_manager_path
    end
  end

  def wubook_auth_state
    if channel_manager_params[:type] == 'ChannelManager::Wubook'
      connector = WubookConnector.new(channel_manager_params)
      connector.get_token.nil? ? false : true
    else
      true
    end
  end

  def wubook_for_company(room_id)
    Room.find(room_id).hotel.channel_manager
  rescue
    nil
  end

  def channel_manager_params
    params.require(:channel_manager).permit(:login, :password, :lcode, :booking_id, :hotel_name, :connector_type, :non_refundable_pid, :default_pid).tap do |whitelisted|
      whitelisted[:type] = ChannelManager.define_type(params[:channel_manager][:connector_type])
    end
  end
end
