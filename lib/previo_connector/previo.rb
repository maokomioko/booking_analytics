class PrevioConnector
  #
  # Previo API
  # @doc http://api.previo.cz/en/
  #
  class Previo < Client
    def post(method, params = {})
      result = self.class.post(method_url(method), body: build_xml(params))

      if result['error'].present?
        raise PrevioAPIError.new(result), result['error']['message']
      else
        result
      end
    end

    def get_rates(params = {})
      result = post('Hotel.getRates', prepare_options_for_get_rates(params))
      seasons = result['rates']['season']
      seasons = [seasons] if seasons.is_a?(Hash)
      seasons
    end

    protected

    def method_url(method)
      service, method = method.split('.')
      [url_path, service.downcase, method].join('/')
    end

    def url_path
      '/x1'
    end

    def build_xml(params)
      hash = {
        login: @login,
        password: @password
      }

      hash.deep_merge(params).to_xml(root: :request, skip_types: true)
    end

    private

    def default_term
      {
        from: Date.today.to_s,
        to: 3.month.from_now.to_date.to_s
      }
    end

    def default_currencies
      [
        { code: 'EUR' }
      ]
    end

    def prepare_options_for_get_rates(params)
      {}.tap do |options|
        options['hotId'] = params['hotId']
        options['term'] = params['term'] || default_term
        options['currencies'] = params['currencies'] || default_currencies
        options['prlIds'] = params['prlIds'] if params['prlIds'].present?
        options['obkIds'] = params['obkIds'] if params['obkIds'].present?
      end
    end
  end
end