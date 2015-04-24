class PrevioConnector
  class Client
    include HTTParty
  
    headers 'Accept' => 'text/xml'
    headers 'Content-Type' => 'text/xml'

    format :xml

    base_uri 'https://api.previo.cz'

    logger ::Logger.new('log/previo.log'),
           Rails.env.development? ? :debug : :info,
           :curl

    attr_accessor :login, :password, :params

    def initialize(login = nil, password = nil, params = {})
      @login = login
      @password = password
      @params = params
    end

    def post
      self.class.post(url_path, body: default_body.to_xml)
    end

    protected

    def url_path
      ''
    end

    def xml_schema
      'http://www.expediaconnect.com/EQC'
    end

    def default_body
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.login @login
        xml.password @password
      end
    end
  end
end
