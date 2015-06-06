class PrevioConnector < AbstractConnector
  #
  # EQC Availability and Rates API
  # @doc https://ewe-quickconnect.s3.amazonaws.com/system/assets/attachments/439/EQC_Public_API_v1.6.pdf
  #
  class AR < Client
    def update_rates(hotel_id, room_id, date, price, allocation = 1)
      date = date.strftime('%Y-%m-%d')
      price = price.to_money.to_s

      body = default_body do |xml|
        xml.send(:'Hotel', id: hotel_id)
        xml.send(:'DateRange', from: date, to: date)
        xml.send(:'RoomType', id: room_id) {
          # xml.send(:'Inventory', 'flexibleAllocation' => allocation)
          xml.send(:'RatePlan', id: '1', closed: false) {
            xml.send(:'Rate', currency: 'EUR') {
              xml.send(:'PerOccupancy', rate: price, occupancy: 1)
            }
          }
        }
      end.to_xml

      self.class.post(url_path, body: body)
    end

    protected

    def url_path
      '/eqc1/ar'
    end

    def xml_schema
      'http://www.expediaconnect.com/EQC/AR/2007/02'
    end

    def default_body(&block)
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.send(:'AvailRateUpdateRQ', xmlns: xml_schema) {
          xml.send(:'Authentication', username: @login, password: @password)
          block.call(xml)
        }
      end
    end
  end
end