class CalendarController < ApplicationController
  def index
     @months = [Date.today, Date.today + 1.month, Date.today + 2.month, Date.today + 3.month]
  end
end
