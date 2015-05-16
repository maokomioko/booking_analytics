class ErrorsController < ApplicationController
  include Gaffe::Errors
  skip_before_filter :auth_user, :company_present, :ch_manager_present
  layout :layout_by_resource
end
