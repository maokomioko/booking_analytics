class PrevioConnector < AbstractConnector
  class PrevioError < StandardError
  end

  class PrevioAPIError < PrevioError
    attr_reader :response, :code, :error_message

    def initialize(response = nil)
      @response = response
      @error_message = response['error']['message'] rescue 'Unknown Error'
      @code = response['error']['code'] rescue ''
    end
  end
end