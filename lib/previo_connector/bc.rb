class PrevioConnector < AbstractConnector
  #
  # EQC Booking Confirmation API
  # @doc https://ewe-quickconnect.s3.amazonaws.com/system/assets/attachments/439/EQC_Public_API_v1.6.pdf
  #
  class BC < Client
    protected

    def url_path
      '/eqc1/bc'
    end

    def xml_schema
      'http://www.expediaconnect.com/EQC/BR/2007/02'
    end
  end
end