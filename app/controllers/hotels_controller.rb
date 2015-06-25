class HotelsController < ApplicationController
  skip_before_filter :wizard_completed, only: :search
  skip_after_action :flash_to_headers, only: :search

  def search
    @hotels = Hotel.full_text_search(params[:q])
  end
end
