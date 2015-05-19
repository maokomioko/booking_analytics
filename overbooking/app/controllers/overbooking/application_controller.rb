module Overbooking
  class ApplicationController < Overbooking.parent_controller.constantize
    layout 'application'

    protected

    def current_engine_user
      current_user.becomes(Overbooking::User)
    end
    helper_method :current_engine_user

    def current_engine_ability
      @current_engine_ability ||= Overbooking::Ability.new(current_engine_user)
    end
    helper_method :current_engine_ability
  end
end
