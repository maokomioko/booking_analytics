class ErrorsController < ApplicationController
  include Gaffe::Errors
  skip_before_filter :wizard_completed, :check_company_and_subscription
  layout :layout_by_resource
end
