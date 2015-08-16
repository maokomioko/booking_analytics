class CompaniesController < ApplicationController
  before_filter :load_company, only: [:edit, :update]
  skip_before_filter [:check_company_and_subscription, :wizard_completed], only: :create

  load_and_authorize_resource :company, singleton: true

  def edit
  end

  def update
    if @company.update_attributes(company_params)
      redirect_to [:edit, :company], success: I18n.t('messages.company_updated')
    else
      flash[:alert] = @company.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :reg_number, :reg_address)
  end

  def load_company
    @company = current_user.company
  end
end
