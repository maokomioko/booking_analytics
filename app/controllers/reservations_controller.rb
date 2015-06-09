class ReservationsController < ApplicationController
  before_action :load_channel_manager

  def index
    @reservations = @channel_manager.connector.get_reservations
  end

  def show
  end

  protected

  def load_channel_manager
    @channel_manager = current_user.channel_manager
  end
end