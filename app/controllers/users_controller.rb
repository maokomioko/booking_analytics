class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t('messages.user_deleted', email: @user.email)
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
    end

    redirect_to [:company, :users]
  end
end