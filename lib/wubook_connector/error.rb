require 'connector_error'

class WubookConnector < AbstractConnector
  class WubookAPIError < ConnectorError
    attr_reader :response, :code, :error_message

    def initialize(response = nil)
      @response = response
      @error_message = response[1] rescue 'Unknown Error'
      @code = response[0] rescue ''

      super(@error_message)
    end
  end
end
