class PrevioConnector
  #
  # EQC Availability and Rates API
  # @doc https://ewe-quickconnect.s3.amazonaws.com/system/assets/attachments/439/EQC_Public_API_v1.6.pdf
  #
  class AR < Client
    protected

    def url_path
      '/eqc1/ar'
    end

    def xml_schema
      'http://www.expediaconnect.com/EQC/AR/2007/02'
    end

    def default_body
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.send(:'AvailRateUpdateRQ', xmlns: xml_schema) {
          xml.send(:'Authentication', username: @login, password: @password)
        }
      end
    end
  end
end