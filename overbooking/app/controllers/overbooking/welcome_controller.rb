require_dependency "overbooking/application_controller"

module Overbooking
  class WelcomeController < ApplicationController
    def index
      @welcome = ''
    end
  end
end
