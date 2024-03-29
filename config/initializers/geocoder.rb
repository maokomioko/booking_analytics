Geocoder.configure(
  # geocoding options
  :timeout      => 10,           # geocoding service timeout (secs)
  :lookup       => :google,     # name of geocoding service (symbol)
  # :language     => :en,         # ISO-639 language code
  :use_https    => true,       # use HTTPS for lookup requests? (if supported)
  # :http_proxy   => nil,         # HTTP proxy server (user:pass@host:port)
  # :https_proxy  => nil,         # HTTPS proxy server (user:pass@host:port)
  # :api_key      => nil,         # API key for geocoding service
  :cache        => Redis.new,         # cache object (must respond to #[], #[]=, and #keys)
  :cache_prefix => "geocoder:", # prefix (string) to use for all cache keys

  # exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and TimeoutError
  # :always_raise => [],

  # calculation options
  # :units     => :mi,       # :km for kilometers or :mi for miles
  # :distances => :linear    # :spherical or :linear
)

module Geocoder::Result
  class Google < Base
    def districts
      address_components_of_type(:sublocality).map{ |a| a['long_name'] }
    end
  end

  class Test < Base
    add_result_attribute('districts')
  end
end

HerePlaces.set_keys('NYCjlZLWWbGkq6ULMQph', 'W6GLAbTaAOGBkgqL-8Wg-A')
