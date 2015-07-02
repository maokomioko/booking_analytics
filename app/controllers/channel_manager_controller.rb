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

    @channel_manager.default_pid = 1
    @channel_manager.non_refundable_pid = 1

    if @channel_manager.save && cm_credentials_correct?
      @channel_manager.update_columns(default_pid: nil, non_refundable_pid: nil)
      redirect_to match_plans_channel_manager_path(id: @channel_manager.id)
    else
      if @channel_manager.errors.any?
        flash[:error] = @channel_manager.errors.full_messages.to_sentence
      end

      render :new
    end
  end

  def match_plans
    if @channel_manager.connector_type == 'empty'
      redirect_to edit_channel_manager_path(@channel_manager.id)
    end
  end

  def edit
  end

  # params key +only_tafif+ is only for update from +match_plans+ action
  def update
    # STI fix
    @channel_manager = @channel_manager.becomes!(channel_manager_params[:type].constantize)

    # reset tarif plans for simple update
    unless params[:only_tarif].present?
      @channel_manager.default_pid = 1
      @channel_manager.non_refundable_pid = 1
    end

    if @channel_manager.update_attributes(channel_manager_params) && cm_credentials_correct?
      unless params[:only_tarif].present?
        @channel_manager.update_columns(default_pid: nil, non_refundable_pid: nil)
      end

      impressionist(@channel_manager)

      path = if @channel_manager.connector_type == 'empty' || params[:only_tarif].present?
               settings_path
             else
               match_plans_channel_manager_path(id: @channel_manager.id)
             end

      redirect_to path, flash: { success: t('messages.cm_verified') }
    else
      if @channel_manager.errors.any?
        flash[:error] = @channel_manager.errors.full_messages.to_sentence
      end

      redirect_to edit_channel_manager_path(@channel_manager.id)
    end
  end

  def update_prices
    raise if params[:dates].blank?

    dates = params[:dates]
    dates.delete('')

    wba = current_user.channel_manager
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

  def cm_credentials_correct?
    @channel_manager.connector.get_plans
    true
  rescue ConnectorError => e
    false
  end

  def channel_manager_params
    allow_attributes = %i(login password lcode booking_id hotel_name
      connector_type non_refundable_pid default_pid)

    if @channel_manager.present? && @channel_manager.persisted? # define update action
      unless can?(:update_booking_id, @channel_manager)
        allow_attributes.delete(:booking_id)
      end
    end

    params.require(:channel_manager).permit(*allow_attributes).tap do |whitelisted|
      whitelisted[:type] = ChannelManager.define_type(params[:channel_manager][:connector_type])
    end
  end
end
