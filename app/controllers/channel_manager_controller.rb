class ChannelManagerController < ApplicationController
  def new
    @wb = WubookAuth.new
  end

  def create
    wb = WubookAuth.new(wb_params)

    if wb.save
      redirect_to calendar_index_path
    else
    end
  end

  private

  def wb_params
    params.require(:wubook_auth).permit(:login, :password, :lcode)
  end
end
