class RoomsController < ApplicationController
  load_and_authorize_resource

  def update
    unless @room.update(room_params)
      flash[:alert] = @room.errors.full_messages.to_sentence
      render none: true
    end
  end

  protected

  def room_params
    params.require(:room).permit(:max_price, :min_price)
  end
end