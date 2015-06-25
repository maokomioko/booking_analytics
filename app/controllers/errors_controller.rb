class ErrorsController < ApplicationController
  include Gaffe::Errors
  skip_before_filter :wizard_completed, :company_present
  layout :layout_by_resource
end
