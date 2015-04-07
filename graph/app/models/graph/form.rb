module Graph
  class Form
    extend ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Conversion

    attr_accessor :date_from, :date_to, :booking_id, :room_id,
                  :related_booking_id
  end
end