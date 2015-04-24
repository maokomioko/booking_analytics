require 'previo_connector/error'
require 'previo_connector/client'
require 'previo_connector/ar'
require 'previo_connector/bc'
require 'previo_connector/br'
require 'previo_connector/previo'

class PrevioConnector
  attr_accessor :ar, :bc, :br, :previo

  def initialize(params = {})
    @login    = params.delete(:login) || ''
    @password = params.delete(:password) || ''
    @hotel_id = params.delete(:hotel_id) || ''
    @params   = params

    load_services
  end

  def get_rooms
    @previo.post('Hotel.getRoomKinds', 'hotId' => @hotel_id)
  end

  def get_plans
    plans = @previo.get_rates({ 'hotId' => @hotel_id })

    plans.select! do |plan|
      range = plan['from'].to_date..plan['to'].to_date
      range.include?(Date.today)
    end

    raise PrevioError, 'No pricing plans for today' if plans.blank?

    plans
  end

  def get_plan_prices(plan_id, room_ids)
    params = {
      'hotId' => @hotel_id,
      'prlIds' => plan_id,
      'obkIds' => room_ids
    }
    @previo.get_rates(params)
  end

  def set_plan_prices(plan_id, room_id, from_date, prices)
  end

  private

  def load_services
    @ar = AR.new(@login, @password)
    @bc = BC.new(@login, @password)
    @br = BR.new(@login, @password)
    @previo = Previo.new(@login, @password)
  end
end
