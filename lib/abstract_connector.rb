class AbstractConnector
  def initialize
    raise NotImplementedError.new("#{self.class.name} is an abstract class.")
  end

  def get_rooms
    raise_not_implemented(__method__)
  end

  def get_plans
    raise_not_implemented(__method__)
  end

  def get_plan_prices
    raise_not_implemented(__method__)
  end

  def set_plan_prices
    raise_not_implemented(__method__)
  end

  # Returns reservations list for current hotel
  #
  # Method should return JSON with this minimal schema:
  # [
  #   {
  #     arrival: <DATETIME>,     # arrival date
  #     departure: <DATETIME>,   # departure date
  #     created_at: <DATETIME>,  # created date of booking
  #     room_ids: <INT ARRAY>,   # room id in current connector
  #     room_amount: <INTEGER>,  # room amount
  #     price: <FLOAT>,          # total price
  #     status: <STRING>,
  #     adults: <INTEGER>,       # adults count
  #     children: <INTEGER>,     # children count
  #     contact_phone: <STRING>, #
  #     contact_email: <STRING>  #
  #   }
  # ]
  def get_reservations
    raise_not_implemented(__method__)
  end

  private

  def raise_not_implemented(method_name)
    raise NotImplementedError, "Connector subclass must define `#{ method_name }`."
  end
end