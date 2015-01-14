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

  attr_accessor :get_rooms, :get_token

  def initialize(wb_params)
    flatten_params(wb_params)

    set_server
    @token = get_token
  end

  def get_rooms
    @server.call('fetch_rooms', @token, @hotel_id)
  end

  def get_token
    response = @server.call('get_token', @login, @password)
    response[1].to_i > 0 ? response[1] : nil
  end

  private

  def flatten_params(wb_params)
    wb_f = wb_params.map{ |key, val| val }
    @login = wb_f[0]
    @password = wb_f[1]
    @lcode = wb_f[2]
  end

  def set_server
    @server = XMLRPC::Client.new_from_hash(CONNECTION_PARAMS)
  end
end
