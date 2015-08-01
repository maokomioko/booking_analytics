class HotelsController < ApplicationController
  skip_before_filter :wizard_completed
  skip_after_action :flash_to_headers

  def show
    @hotel = Hotel.find_by_booking_id(params[:id])
  end

  def search
    @hotels = Hotel.full_text_search(params[:q]).limit(300)
  end

  def markers
    @hash = MarkerBuilder.build(params[:booking_ids])
    render json: @hash.to_json
  end
end
