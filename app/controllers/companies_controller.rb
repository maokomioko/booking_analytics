class CompaniesController < ApplicationController
  before_filter :load_company, only: [:show, :edit, :update]
  skip_before_filter [:company_present, :wizard_completed], only: [:new, :create]

  load_and_authorize_resource :company, singleton: true

  def show
  end

  def new
    redirect_to root_path if current_user.company.present?
  end

  def create
    redirect_to root_path if current_user.company.present?

    if @company.save
      current_user.update_column(:company_id, @company.id)
      redirect_to root_path, success: I18n.t('messages.company_created')
    else
      flash[:alert] = @company.errors.full_messages.to_sentence
      render :new
    end
  end

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
    params.require(:company).permit(
      :name, :reg_number, :reg_address, :bank_name, :bank_code, :bank_account,
      :logo, :logo_cache, :remove_logo
    )
  end

  def load_company
    @company = current_user.company
  end
end
