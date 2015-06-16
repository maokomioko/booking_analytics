require 'abstract_connector'

require 'previo_connector/error'
require 'previo_connector/client'
require 'previo_connector/ar'
require 'previo_connector/bc'
require 'previo_connector/br'
require 'previo_connector/previo'
require 'previo_connector/room_collection'

class PrevioConnector < AbstractConnector
  attr_accessor :ar, :bc, :br, :previo
  attr_accessor :hotel_id

  def initialize(params = {})
    @login    = params.delete(:login) || ''
    @password = params.delete(:password) || ''
    @hotel_id = params.delete(:hotel_id) || ''
    @params   = params

    load_services
  end

  def get_rooms
    resp = @previo.post('Hotel.getRoomKinds', 'hotId' => @hotel_id)
    rooms = resp['roomKinds']['objectKind']

    # we should always return array
    if rooms.is_a?(Hash)
      resp['roomKinds']['objectKind'] = [rooms]
    end

    RoomCollection.new(resp['roomKinds']['objectKind'])
  end

  def get_plans
    plans = @previo.get_rates({ 'hotId' => @hotel_id })
    plans = filter_actual_plans(plans)

    raise PrevioError, 'No pricing plans for today' if plans.blank?

    plans
  end

  def get_plan_prices(plan_id = nil, room_ids = nil)
    params = {}.tap do |hash|
      hash['hotId'] = @hotel_id
      hash['prlIds'] = plan_id if plan_id.present?
      hash['obkIds'] = room_ids if room_ids.present?
    end

    plans = @previo.get_rates(params)
    plans = filter_actual_plans(plans)

    raise PrevioError, 'No pricing plans for today' if plans.blank?

    plans
  end

  def set_plan_prices(plan_id = nil, room_id, from_date, prices)
    plan_id ||= 1

    raise PrevioError, 'Undefined room' if room_id.nil?

    @ar.update_rates(@hotel_id, room_id, from_date, prices.first)
  end

  def get_reservations(from = Date.today, to = 3.month.from_now.to_date)
    params = {}.tap do |p|
      p['hotId'] = @hotel_id
      p['term'] = {
        from: from.strftime('%Y-%m-%d'),
        to: to.strftime('%Y-%m-%d')
      }
    end
    reservations = @previo.search_reservations(params)

    reservations.map do |r|
      {
        arrival: r['term']['from'].to_datetime,
        departure: r['term']['to'].to_datetime,
        created_at: r['created'].to_datetime,
        room_ids: [r['objectKind']['obkId'].to_i],
        room_amount: 1,
        price: r['price'].to_i.to_money(r['currency']['code']),
        status: Previo::RESERVATION_STATUSES[r['status']['statusId'].to_i][:name],
        adults: r['guest'].select{|g| g['guestCategory']['name'] == "dospělý"}.count,
        children: r['guest'].select{|g| g['guestCategory']['name'] != "dospělý"}.count,
        contact_phone: '',
        contact_email: ''
      }
    end
  end

  private

  def load_services
    @ar = AR.new(@login, @password)
    @bc = BC.new(@login, @password)
    @br = BR.new(@login, @password)
    @previo = Previo.new(@login, @password)
  end

  def filter_actual_plans(plans)
    date_range = (Date.today..3.months.from_now.to_date).to_a
    plans.select do |plan|
      range = (plan['from'].to_date..plan['to'].to_date).to_a
      (date_range & range).length > 0
    end
  end
end
