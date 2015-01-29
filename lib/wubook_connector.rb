class WubookConnector
  require 'uri'
  require 'net/http'
  require "xmlrpc/client"

  CONNECTION_PARAMS = {
    host: 'wubook.net',
    port: '443',
    use_ssl: true,
    path: '/xrws'
  }

  attr_accessor :get_rooms, :set_room_prices, :get_token

  def initialize(wb_params)
    flatten_params(wb_params)
    set_server

    @token = get_token
  end

  def get_rooms
    response = @server.call('fetch_rooms', @token, @lcode)
    response[1].length > 0 ? response[1] : nil
  end

  def get_room_prices(room_ids = nil)
    from_date = format_date(Date.today)
    to_date = format_date(Date.today + 2.months)

    unless room_ids.nil?
      response = @server.call('fetch_rooms_values', @token, @lcode, from_date, to_date, room_ids)
    else
      response = @server.call('fetch_rooms_values', @token, @lcode, from_date, to_date)
    end

    response[1].length > 0 ? response[1] : nil
  end

  def set_room_prices(room, dates, prices)

    dates.each_with_index do |date, i|
      date = format_date(date.to_date)
      data = [{
        id: room,
        days: [{
          avail: 1,
          price: prices.size > 0 ? prices[i] : prices[0],
          min_stay: 1
          }]
        }]

      response = @server.call_async('update_rooms_values', @token, @lcode, date, data)
      return response[1].length > 0 ? response[1] : nil
    end
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

  private

  def flatten_params(wb_params)
    wb_f = wb_params.map{ |key, val| val }
    @login = wb_f[0]
    @password = wb_f[1]
    @lcode = wb_f[2]
  end

  def prepare_room_prices

  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def set_server
    @server = XMLRPC::Client.new_from_hash(CONNECTION_PARAMS)
  end
end
