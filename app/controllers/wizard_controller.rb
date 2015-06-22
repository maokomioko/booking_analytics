class WizardController < ApplicationController
  before_filter :check_steps, except: :step1_post

  # hotel search
  def step1
    unless current_user.channel_manager.try(:hotel)
      @channel_manager = ChannelManager.new
    else
      redirect_to [:wizard, :step2]
    end
  end

  # POST /wizard/step1
  def step1_post
    @channel_manager = current_user.channel_manager || ChannelManager::Wubook.new
    @channel_manager.attributes = step1_params

    # let's hack rails validation ]:->
    @channel_manager.login ||= '1'
    @channel_manager.password ||= '1'
    @channel_manager.lcode ||= '1'
    @channel_manager.hotel_name ||= '1'
    @channel_manager.company = current_user.company

    if @channel_manager.save
      @channel_manager.update_columns(
        {}.tap do |hash|
          hash[:login] = nil if @channel_manager.login == '1'
          hash[:password] = nil if @channel_manager.password == '1'
          hash[:lcode] = nil if @channel_manager.lcode == '1'
          hash[:hotel_name] = @channel_manager.hotel.name if @channel_manager.hotel_name == '1'
        end
      )

      redirect_to [:wizard, :step2]
    else
      flash[:alert] = @channel_manager.errors.full_messages.to_a.to_sentence
      render :step1
    end
  end

  # channel manager info
  def step2
    @channel_manager = current_user.channel_manager
  end

  # POST /wizard/step2
  def step2_post
    @channel_manager = current_user.channel_manager

    # STI fix
    @channel_manager = @channel_manager.becomes!(step2_params[:type].constantize)

    # let's hack rails validation ]:->
    @channel_manager.non_refundable_pid ||= 1
    @channel_manager.default_pid ||= 1

    if @channel_manager.update_attributes(step2_params)
      @channel_manager.update_columns(
        {}.tap do |hash|
          hash[:non_refundable_pid] = nil if @channel_manager.non_refundable_pid == 1
          hash[:default_pid] = nil if @channel_manager.default_pid == 1
        end
      )

      redirect_to [:wizard, :step3]
    else
      flash[:alert] = @channel_manager.errors.full_messages.to_a.to_sentence
      render :step2
    end
  end

  # tariff plans
  def step3
    @channel_manager = current_user.channel_manager
  end

  # POST /wizard/step3
  def step3_post
    @channel_manager = current_user.channel_manager

    if @channel_manager.update_attributes(step3_params)
      redirect_to [:wizard, :step4]
    else
      flash[:alert] = @channel_manager.errors.full_messages.to_a.to_sentence
      render :step3
    end
  end

  # channel manager rooms
  def step4
    @channel_manager = current_user.channel_manager
    @cm_rooms = @channel_manager.connector.get_rooms.name_id_mapping

    @channel_manager.create_rooms if @channel_manager.hotel.rooms.size.zero?
  end

  # related hotel search
  def step5
    @hotel = current_user.channel_manager.hotel
    @hotel.amenities_calc

    @related = @hotel
       .related_hotels
       .includes(:related)
       .order('id DESC')
       .page params[:page]
  end

  # yay! complete!
  def complete
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

  def check_steps
    if controller_name == 'wizard'
      1.upto(5) do |n|
        if action_name.to_s == "step#{n}"
          steps_checking_methods
        end
      end
    end
  end

  def steps_checking_methods
    unless current_user.channel_manager.present?
      redirect_to [:wizard, :step1] and return
    end

    unless current_user.channel_manager.login.present?
      redirect_to [:wizard, :step2] and return
    end

    unless current_user.channel_manager.default_pid.present?
      redirect_to [:wizard, :step3] and return
    end

    ids = current_user.channel_manager.hotel.rooms.pluck(:wubook_id, :previo_id)

    # if none of the rooms have CM_ID
    if ids.flatten.compact.size.zero?
      redirect_to [:wizard, :step4] and return
    end

    if current_user.channel_manager.hotel.related.count.zero?
      redirect_to [:wizard, :step5] and return
    else
      redirect_to calendar_index_path
    end
  end
end
