class Api::V1Controller < ApplicationController
  #before_filter :disable_render
  before_filter :set_destination
  before_filter :set_namespace

  private

  def disable_render
    render nothing: true
  end

  def set_namespace
    target_date = params[:target_date]
    view_window = params[:view_window]
    region = params[:region]

    @api_prefix = "/v1/" + action_name.match(/[^\/v1][a-z_]+/)[0] + base_scope(target_date, view_window, region)
  end

  def set_destination
  end

  def api_params
    params.permit(
      :target_date, :view_window, :region
    )
  end
end
