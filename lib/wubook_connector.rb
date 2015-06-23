require 'wubook_connector/room_collection'

class WubookConnector < AbstractConnector
  require 'uri'
  require 'net/http'
  require 'xmlrpc/client'

  CONNECTION_PARAMS = {
    host: 'wubook.net',
    port: '443',
    use_ssl: true,
    path: '/xrws'
  }

  attr_accessor :get_rooms, :get_plan_prices, :set_room_prices, :get_token

  def initialize(wb_params)
    flatten_params(wb_params)
    set_server

    @token = get_token
  end

  def get_rooms
    response = @server.call('fetch_rooms', @token, @lcode)
    RoomCollection.new(set_response(response))
  end

  def get_plans
    response = @server.call('get_pricing_plans', @token, @lcode)
    set_response(response)
  end

  def get_plan_prices(plan_id, room_ids)
    from_date = format_date(Date.today)
    to_date = format_date(Date.today + 3.months)

    response = @server.call_async('fetch_plan_prices', @token, @lcode, plan_id, from_date, to_date, room_ids)
    set_response(response)
  end

  def set_plan_prices(plan_id, room_id, from_date, prices)
    data = {
      room_id => prices
    }

    response = @server.call_async('update_plan_prices', @token, @lcode, plan_id, format_date(from_date), data)
    set_response(response)
  end

  def get_token
    cache = ActiveSupport::Cache::MemoryStore.new

    if cache.fetch('wb_token').nil?
      response = @server.call('get_token', @login, @password)
      if response[1].to_i > 0
        cache.write('wb_token', response[1])
        response[1]
      else
        nil
      end
    else
      cache.fetch('wb_token')
    end
  end

  def get_reservations(from = Date.today, to = 3.month.from_now.to_date)
    response = @server.call(
        'fetch_bookings',
        @token,
        @lcode,
        format_date(from),
        format_date(to)
    )
    answer = set_response(response)
    unless answer.nil?
      answer.map do |r|
        {
          arrival: r['date_arrival'].to_datetime,
          deparute: r['date_departure'].to_datetime,
          created_at: r['date_received'].to_datetime,
          room_ids: r['rooms'].map(&:to_i),
          room_amount: 1,
          price: r['amount'].to_f.to_money('EUR'),
          status: r['status'],
          adults: r['men'].to_i,
          children: r['children'].to_i,
          contact_phone: r['customer_phone'],
          contact_email: r['customer_mail']
        }
      end
    end
  end

  private

  def flatten_params(wb_params)
    wb_f = wb_params.map { |_key, val| val }
    @login = wb_f[0]
    @password = wb_f[1]
    @lcode = wb_f[2]
  end

  def set_response(response)
    response[1].length > 0 ? response[1] : nil
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def set_server
    @server = XMLRPC::Client.new_from_hash(CONNECTION_PARAMS)
  end
end
