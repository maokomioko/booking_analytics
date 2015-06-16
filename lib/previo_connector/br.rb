class PrevioConnector < AbstractConnector
  #
  # EQC Booking Retrieval API
  # @doc https://ewe-quickconnect.s3.amazonaws.com/system/assets/attachments/439/EQC_Public_API_v1.6.pdf
  #
  class BR < Client
    protected

    def url_path
      '/eqc1/br'
    end

    def xml_schema
      'http://www.expediaconnect.com/EQC/BR/2007/02'
    end

    def default_body
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.send(:'BookingRetrievalRQ', xmlns: xml_schema) {
          xml.send(:'Authentication', username: @login, password: @password)
        }
      end
    end
  end
end
