class SettingsController < ApplicationController
  before_filter :load_company_settings

  def create
    @setting = current_user.company.build_setting(settings_params)

    if @setting.save
      redirect_to [:edit, :setting]
    else
      flash[:alert] = @settings.errors.full_messages.to_sentence
      render :edit
    end
  end

  def edit
  end

  def update
    @setting.attributes = settings_params

    if @setting.save
      redirect_to [:edit, :setting]
    else
      flash[:alert] = @settings.errors.full_messages.to_sentence
      render :edit
    end
  end

  protected

  def load_company_settings
    @setting = current_user.company.setting || current_user.company.build_setting(Setting.default_attributes)
  end

  def settings_params
    params.require(:setting).permit(:crawling_frequency, stars: [], user_ratings: [], property_types: [])
  end
end