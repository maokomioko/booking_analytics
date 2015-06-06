class PrevioConnector < AbstractConnector
  #
  # Previo API
  # @doc http://api.previo.cz/en/
  #
  class Previo < Client

    RESERVATION_STATUSES = {
      1 => { name: 'option', description: 'Customer expressed interest in a specific room for a specific date but has not yet paid deposit' },
      2 => { name: 'confirmed', description: 'Customer has paid the deposit - reservation is confirmed' },
      3 => { name: 'checked in', description: 'Customer is currently staying in booked accommodation' },
      4 => { name: 'paid', description: 'Customer has checked out' },
      5 => { name: 'due', description: 'Reservation is not paid, but still blocks the room (waiting for payment)' },
      6 => { name: 'waiting list', description: 'Reservation is waiting for manual confirmation' },
      7 => { name: 'cancelled', description: 'Reservation was cancelled by either the customer or hotelier (generally before arrival)' },
      8 => { name: 'no-show', description: 'Customer does not arrive on specified date of arrival and failed to cancel the reservation in advance' }
    }

    ACTIVE_RESERVATION_STATUSES = [2,3,4]

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

    def search_reservations(params, active = true)
      if active
        params[:statuses] = Proc.new { |options|
          builder = options[:builder]
          builder.statuses do
            PrevioConnector::Previo::ACTIVE_RESERVATION_STATUSES.each do |status|
              builder.tag!('cosId', status)
            end
          end
        }
      end

      result = post('Hotel.searchReservations', params)

      reservations = result['reservations']['reservation']
      reservations = [reservations] if reservations.is_a?(Hash)
      reservations
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