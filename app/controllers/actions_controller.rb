class ActionsController < ApplicationController
  load_and_authorize_resource :user, id_param: :user_id, parent: false
  load_resource only: :show, collection: :show, through: :user

  def index
    authorize! :index, Action
    @users = @users.includes(:company)
  end

  def show
    @actions = @actions.order('created_at DESC').page(params[:page])
  end
end