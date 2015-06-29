class ConnectorError < StandardError
  def initialize(error = nil)
    if Thread.current[:session].present?
      Thread.current[:session][:connector_error] = error
    end
  end
end
