class WizardController < ApplicationController
  before_filter :check_ability, except: [:setup_not_completed, :complete]

  # hotel search
  def step1
    hotel = current_user.channel_manager.try(:hotel)
    @channel_manager = if hotel.present?
                         current_user.channel_manager
                       else
                         ChannelManager.new
                       end
  end

  # POST /wizard/step/1
  def step1_post
    @channel_manager = current_user.channel_manager || ChannelManager::Empty.new
    @channel_manager.attributes = step1_params

    # let's hack rails validation ]:->
    @channel_manager.company = current_user.company

    if @channel_manager.save
      allow_next_step
      redirect_to [:wizard, :step2], turbolinks: true
    else
      flash[:alert] = @channel_manager.errors.full_messages.to_a.to_sentence
      redirect_to [:wizard, :step1], turbolinks: true
    end
  end

  # channel manager info
  def step2
    @channel_manager = current_user.channel_manager
  end

  # POST /wizard/step/2
  def step2_post
    @channel_manager = current_user.channel_manager

    # STI fix
    @channel_manager = @channel_manager.becomes!(step2_params[:type].constantize)

    # let's hack rails validation ]:->
    @channel_manager.non_refundable_pid ||= 1
    @channel_manager.default_pid ||= 1

    if @channel_manager.update_attributes(step2_params)
      attrs = {}.tap do |hash|
        hash[:non_refundable_pid] = nil if @channel_manager.non_refundable_pid == 1
        hash[:default_pid] = nil if @channel_manager.default_pid == 1
      end

      @channel_manager.update_columns(attrs) if attrs.present?

      # check channel manager for correct credentials
      @channel_manager.connector.get_plans

      if @channel_manager.connector_type == 'empty'
        current_user.company.update_column(:setup_step, 4)
        redirect_to [:wizard, :step4], turbolinks: true
      else
        allow_next_step
        redirect_to [:wizard, :step3], turbolinks: true
      end
    else
      flash[:alert] = @channel_manager.errors.full_messages.to_a.to_sentence
      redirect_to [:wizard, :step2], turbolinks: true
    end
  rescue ConnectorError => _e
    redirect_to [:wizard, :step2], turbolinks: true
  end

  # tariff plans
  def step3
    @channel_manager = current_user.channel_manager

    if @channel_manager.connector_type == 'empty'
      redirect_to [:wizard, :step4], turbolinks: true
    end
  end

  # POST /wizard/step/3
  def step3_post
    @channel_manager = current_user.channel_manager

    if @channel_manager.update_attributes(step3_params)
      allow_next_step
      redirect_to [:wizard, :step4], turbolinks: true
    else
      flash[:alert] = @channel_manager.errors.full_messages.to_a.to_sentence
      render :step3
    end
  end

  # channel manager rooms
  def step4
    @channel_manager = current_user.channel_manager
    @hotel = @channel_manager.hotel

    @cm_rooms = begin
      @channel_manager.connector.get_rooms.name_id_mapping
    rescue ConnectorError => e
      []
    end

    @channel_manager.create_rooms if @channel_manager.hotel.rooms.size.zero?
  end

  def step4_post
    ids = current_user.channel_manager.hotel.rooms.pluck(:wubook_id, :previo_id)

    # if none of the rooms have CM_ID
    if current_user.channel_manager.connector_type != 'empty' && ids.flatten.compact.size.zero?
      render nothing: true, status: :unprocessable_entity
    else
      allow_next_step
      redirect_to [:wizard, :step5], turbolinks: true
    end
  end

  # related hotel search
  def step5
    @hotel = current_user.channel_manager.hotel
    @hotel.amenities_calc(current_user.company.id)

    @related = @hotel
       .related_hotels
       .includes(:related)
       .order('id DESC')
       .page params[:page]
  end

  def step5_post
    hotel = current_user.channel_manager.hotel
    if hotel.related.count.zero?
      render nothing: true, status: :unprocessable_entity
    else
      # create Setting if necessary and start algorithm
      PriceMaker::PriceWorker.perform_async(current_user.setting_fallback.id)

      allow_next_step
      redirect_to [:wizard, :complete], turbolinks: true
    end
  end

  # yay! complete!
  def complete
  end

  def setup_not_completed
  end

  protected

  def step1_params
    params.require(:channel_manager).permit(:booking_id)
  end

  def step2_params
    params.require(:channel_manager).permit(
        :connector_type, :login, :password, :lcode
    ).tap do |whitelisted|
      whitelisted[:type] = ChannelManager.define_type(params[:channel_manager][:connector_type])
    end
  end

  def step3_params
    params.require(:channel_manager).permit(:default_pid, :non_refundable_pid)
  end

  def check_ability
    if can?(:wizard_setup, Object)
      if params[:step].to_i > current_user.setup_step
        redirect_to [:wizard, :"step#{ current_user.setup_step }"] and return
      end
    else
      redirect_to [:wizard, :setup_not_completed] and return
    end
  end

  def allow_next_step
    current_user.company.update_column(:setup_step, params[:step].to_i + 1)
  end
end
